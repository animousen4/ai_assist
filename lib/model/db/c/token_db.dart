import 'dart:io';
import 'package:ai_assist/model/db/table/token_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'token_db.g.dart';

@DriftDatabase(tables: [GptTokens])
class TokenDatabase extends _$TokenDatabase {
  TokenDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (m) async {
        await m.createAll();
  });
}
