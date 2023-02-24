import 'package:realm/realm.dart';

part 'data.g.dart';

@RealmModel()
class _Teacher {
  @PrimaryKey()
  late final int id;

  String name = '';

  @Indexed()
  RealmValue date = RealmValue.dateTime(DateTime.now());

  @Backlink(Symbol('teachers'))
  final students = const Iterable<_Student>.empty();
}

@RealmModel()
class _Student {
  @PrimaryKey()
  late final int id;

  String name = '';
  int roll = 0;

  @Indexed()
  RealmValue date = RealmValue.dateTime(DateTime.now());

  final teachers = <_Teacher>[];
  final classes = <_Class>[];
}

@RealmModel()
class _Class {
  @PrimaryKey()
  late final int id;

  String name = '';

  @Backlink(Symbol('classes'))
  final students = const Iterable<_Student>.empty();
}
