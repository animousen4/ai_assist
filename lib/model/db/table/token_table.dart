import 'package:ai_assist/model/db/table/chats_table.dart';
import 'package:drift/drift.dart';

@DataClassName('GptToken')
class GptTokens extends Table {
  IntColumn get id => integer().autoIncrement()();

  BoolColumn get isUsing => boolean()();
  // 0 - ok, 1 - unavailable, 2 - refreshing, 3 - deleted
  IntColumn get status => integer()();

  DateTimeColumn get addDate => dateTime()();

  DateTimeColumn get refreshDate => dateTime().nullable()();

  TextColumn get token => text()();
}
