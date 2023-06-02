import 'dart:io';
import 'package:ai_assist/model/db/db_connection.dart';
import 'package:ai_assist/model/db/table/token_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'token_db.g.dart';

@DriftDatabase(tables: [GptTokens])
class AbstractTokenDatabase extends _$AbstractTokenDatabase {
  AbstractTokenDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (m) async {
        await m.createAll();
      });
}

class TokenDatabase extends AbstractTokenDatabase {
  TokenDatabase() : super(openConnection("tokens.db"));

}
