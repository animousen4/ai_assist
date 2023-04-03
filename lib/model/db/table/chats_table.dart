import 'package:drift/drift.dart';

@DataClassName('Chat')
class Chats extends Table {
  IntColumn get chatId => integer().autoIncrement()();

  // 0 - ok; 1 - deleted;
  IntColumn get chatStatus => integer()();

  // 0 - talk; 1 - template
  IntColumn get chatType => integer()();

  TextColumn get chatName => text()();

  DateTimeColumn get creationDate => dateTime()();

  DateTimeColumn get closeDate => dateTime().nullable()();
}
