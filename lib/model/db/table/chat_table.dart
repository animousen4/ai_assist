import 'package:drift/drift.dart';

@DataClassName('Message')
class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get data => dateTime()();
  TextColumn get role => text()();
  TextColumn get content => text()();
}
