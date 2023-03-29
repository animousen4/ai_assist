import 'package:drift/drift.dart';

@DataClassName('Chat')
class Chats extends Table {
  IntColumn get chatId => integer().autoIncrement()();
  IntColumn get chatStatus => integer()();
  IntColumn get chatType => integer()();
  TextColumn get chatName => text()();
  DateTimeColumn get creationDate => dateTime()();
  DateTimeColumn get closeDate => dateTime().nullable()();
}
