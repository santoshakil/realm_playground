import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';
import 'package:realm_playground/data.dart';
import 'package:synchronized/synchronized.dart';

final schemas = [Student.schema, Teacher.schema, Class.schema];
late final LocalConfiguration dbConfig;
late final Realm db;
final lock = Lock();

void initDB(String path) {
  final start = DateTime.now().millisecondsSinceEpoch;
  dbConfig = Configuration.local(
    schemas,
    path: path,
    shouldDeleteIfMigrationNeeded: !kReleaseMode,
  );
  db = Realm(dbConfig);
  final end = DateTime.now().millisecondsSinceEpoch;
  debugPrint('DB initialized in ${end - start}ms');
}

Future<void> writeData() async => lock.synchronized(() async {
      final receivePort = ReceivePort();
      final isolate = await Isolate.spawn(
        _writeData,
        [dbConfig.path, receivePort.sendPort],
      );
      isolate.addOnExitListener(receivePort.sendPort);
      await for (final v in receivePort) {
        if (v == 0) break;
      }
      receivePort.close();
      isolate.kill();
    });

void _writeData(v) {
  final path = (v as List).first as String;
  final sendPort = v.last as SendPort;
  initDB(path);

  final students = <Student>[];
  final length = db.all<Student>().length;

  for (var i = 0; i < 1000000; i++) {
    final teacher = Teacher(i + length)..name = 'Teacher ${i + length}';

    final student = Student(i + length)
      ..name = 'Student ${i + length}'
      ..teachers.add(teacher);

    students.add(student);
  }

  final start = DateTime.now().millisecondsSinceEpoch;
  db.write(() => db.addAll(students));
  final end = DateTime.now().millisecondsSinceEpoch;
  debugPrint('Writen in ${end - start}ms');

  final strat2 = DateTime.now().millisecondsSinceEpoch;
  final length2 = db.all<Student>().length;
  final end2 = DateTime.now().millisecondsSinceEpoch;
  debugPrint('Read in ${end2 - strat2}ms, length: $length2');

  sendPort.send(0);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final path = join((await getApplicationDocumentsDirectory()).path, 'db');
  initDB(path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        listTileTheme: const ListTileThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      home: Scaffold(
        body: const RealmList(),
        appBar: AppBar(
          title: const Text('Realm Playground'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final start = DateTime.now().millisecondsSinceEpoch;
                db.write(() {
                  db.deleteAll<Student>();
                  db.deleteAll<Teacher>();
                });
                final end = DateTime.now().millisecondsSinceEpoch;
                debugPrint('Deleted in ${end - start}ms');
                await compute(
                  (path) {
                    initDB(path);
                    return Realm.compact(dbConfig);
                  },
                  dbConfig.path,
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async => await writeData(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class RealmList extends StatelessWidget {
  const RealmList({super.key = const Key('RealmList')});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: db.query<Student>('id > 100000').changes,
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final students = snapshot.data!.results;
              return ListView.builder(
                itemCount: students.length,
                itemBuilder: (_, i) {
                  final student = students[i];
                  return StudentTile(
                    key: ValueKey(student.id),
                    student: student,
                  );
                },
              );
            },
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: db.all<Teacher>().changes,
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final teachers = snapshot.data!.results;
              return ListView.builder(
                itemCount: teachers.length,
                itemBuilder: (_, i) {
                  final teacher = teachers[i];
                  return TeacherTile(
                    key: ValueKey(teacher.id),
                    teacher: teacher,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class StudentTile extends StatelessWidget {
  const StudentTile({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(student.name, maxLines: 1),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final teacher in student.teachers)
            Text(teacher.name, maxLines: 1),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () => db.write(
          () => student.teachers.add(
            Teacher(DateTime.now().millisecondsSinceEpoch)
              ..name = 'Teacher ${DateTime.now().millisecondsSinceEpoch}',
          ),
        ),
      ),
      onTap: () {
        db.write(() => student.name = 'Student ${DateTime.now().millisecond}');
      },
    );
  }
}

class TeacherTile extends StatelessWidget {
  const TeacherTile({super.key, required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: teacher.students.changes,
      builder: (context, snapshot) {
        return ListTile(
          title: Text(teacher.name, maxLines: 1),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final student in teacher.students)
                Text(student.name, maxLines: 1),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => db.write(() => db.delete(teacher)),
          ),
          onTap: () {
            db.write(
              () => teacher.name = 'Teacher ${DateTime.now().millisecond}',
            );
          },
        );
      },
    );
  }
}
