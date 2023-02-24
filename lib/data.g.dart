// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Teacher extends _Teacher with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Teacher(
    int id, {
    String name = '',
    RealmValue date = const RealmValue.nullValue(),
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Teacher>({
        'name': '',
        'date': RealmValue.dateTime(DateTime.now()),
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'date', date);
  }

  Teacher._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => throw RealmUnsupportedSetError();

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  RealmValue get date =>
      RealmObjectBase.get<RealmValue>(this, 'date') as RealmValue;
  @override
  set date(RealmValue value) => RealmObjectBase.set(this, 'date', value);

  @override
  RealmResults<Student> get students =>
      RealmObjectBase.get<Student>(this, 'students') as RealmResults<Student>;
  @override
  set students(covariant RealmResults<Student> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Teacher>> get changes =>
      RealmObjectBase.getChanges<Teacher>(this);

  @override
  Teacher freeze() => RealmObjectBase.freezeObject<Teacher>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Teacher._);
    return const SchemaObject(ObjectType.realmObject, Teacher, 'Teacher', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('date', RealmPropertyType.mixed,
          optional: true, indexed: true),
      SchemaProperty('students', RealmPropertyType.linkingObjects,
          linkOriginProperty: 'teachers',
          collectionType: RealmCollectionType.list,
          linkTarget: 'Student'),
    ]);
  }
}

class Student extends _Student with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Student(
    int id, {
    String name = '',
    int roll = 0,
    RealmValue date = const RealmValue.nullValue(),
    Iterable<Teacher> teachers = const [],
    Iterable<Class> classes = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Student>({
        'name': '',
        'roll': 0,
        'date': RealmValue.dateTime(DateTime.now()),
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'roll', roll);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set<RealmList<Teacher>>(
        this, 'teachers', RealmList<Teacher>(teachers));
    RealmObjectBase.set<RealmList<Class>>(
        this, 'classes', RealmList<Class>(classes));
  }

  Student._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => throw RealmUnsupportedSetError();

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  int get roll => RealmObjectBase.get<int>(this, 'roll') as int;
  @override
  set roll(int value) => RealmObjectBase.set(this, 'roll', value);

  @override
  RealmValue get date =>
      RealmObjectBase.get<RealmValue>(this, 'date') as RealmValue;
  @override
  set date(RealmValue value) => RealmObjectBase.set(this, 'date', value);

  @override
  RealmList<Teacher> get teachers =>
      RealmObjectBase.get<Teacher>(this, 'teachers') as RealmList<Teacher>;
  @override
  set teachers(covariant RealmList<Teacher> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<Class> get classes =>
      RealmObjectBase.get<Class>(this, 'classes') as RealmList<Class>;
  @override
  set classes(covariant RealmList<Class> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Student>> get changes =>
      RealmObjectBase.getChanges<Student>(this);

  @override
  Student freeze() => RealmObjectBase.freezeObject<Student>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Student._);
    return const SchemaObject(ObjectType.realmObject, Student, 'Student', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('roll', RealmPropertyType.int),
      SchemaProperty('date', RealmPropertyType.mixed,
          optional: true, indexed: true),
      SchemaProperty('teachers', RealmPropertyType.object,
          linkTarget: 'Teacher', collectionType: RealmCollectionType.list),
      SchemaProperty('classes', RealmPropertyType.object,
          linkTarget: 'Class', collectionType: RealmCollectionType.list),
    ]);
  }
}

class Class extends _Class with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Class(
    int id, {
    String name = '',
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Class>({
        'name': '',
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
  }

  Class._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => throw RealmUnsupportedSetError();

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  RealmResults<Student> get students =>
      RealmObjectBase.get<Student>(this, 'students') as RealmResults<Student>;
  @override
  set students(covariant RealmResults<Student> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Class>> get changes =>
      RealmObjectBase.getChanges<Class>(this);

  @override
  Class freeze() => RealmObjectBase.freezeObject<Class>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Class._);
    return const SchemaObject(ObjectType.realmObject, Class, 'Class', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('students', RealmPropertyType.linkingObjects,
          linkOriginProperty: 'classes',
          collectionType: RealmCollectionType.list,
          linkTarget: 'Student'),
    ]);
  }
}
