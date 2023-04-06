import 'package:ai_assist/model/db/table/chats_table.dart';
import 'package:drift/drift.dart';

@DataClassName('GptToken')
class GptTokens extends Table {
  IntColumn get id => integer().autoIncrement()();

  // 0 - ok, 1 - unavailable
  IntColumn get status => integer()();

  DateTimeColumn get addDate => dateTime()();

  DateTimeColumn get refreshDate => dateTime().nullable()();

  TextColumn get token => text()();
}
