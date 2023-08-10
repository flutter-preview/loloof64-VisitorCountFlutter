import 'package:drift/drift.dart';

part 'database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
}

@DriftDatabase(tables: [Users])
class VisitorDatabase extends _$VisitorDatabase {
  VisitorDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}
