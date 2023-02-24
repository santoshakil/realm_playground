import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';
import 'package:realm_playground/data.dart';

late final LocalConfiguration dbConfig;
late final Realm db;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final path = join((await getApplicationDocumentsDirectory()).path, 'db');
  dbConfig = Configuration.local(
    [Student.schema, Teacher.schema],
    schemaVersion: 1,
    path: path,
  );
  db = Realm(dbConfig);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: const RealmList(),
        appBar: AppBar(
          title: const Text('Realm Playground'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => db.write(() {
                db.deleteAll<Student>();
                db.deleteAll<Teacher>();
              }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final studentLenght = db.all<Student>().length;
            final teacherLenght = db.all<Teacher>().length;

            final teacher = Teacher(teacherLenght)
              ..name = 'Teacher $teacherLenght';

            final student = Student(studentLenght)
              ..name = 'Student $studentLenght'
              ..roll = studentLenght
              ..teachers.add(teacher);

            db.write(() {
              db.add(teacher);
              db.add(student);
            });
          },
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
            stream: db.all<Student>().changes,
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
      title: Text('${student.roll} - ${student.name}'),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final teacher in student.teachers) Text(teacher.name),
        ],
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
          title: Text(teacher.name),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final student in teacher.students) Text(student.name),
            ],
          ),
          onTap: () {
            db.write(
                () => teacher.name = 'Teacher ${DateTime.now().millisecond}');
          },
        );
      },
    );
  }
}
