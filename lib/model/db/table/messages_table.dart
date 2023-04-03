import 'package:ai_assist/model/db/table/chats_table.dart';
import 'package:drift/drift.dart';

@DataClassName('Message')
class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();

  // 0 - ok; 1 - deleted; 2 - modified;
  IntColumn get messageStatus => integer()();

  IntColumn get chatId => integer().references(Chats, #chatId)();

  DateTimeColumn get data => dateTime()();

  TextColumn get role => text()();

  TextColumn get content => text()();
}
