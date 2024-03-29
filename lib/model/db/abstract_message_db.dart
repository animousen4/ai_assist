import 'dart:io';
import 'package:ai_assist/model/db/table/messages_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';


import 'table/chats_table.dart';
part 'abstract_message_db.g.dart';

@DriftDatabase(tables: [Messages, Chats])
class AbstractMessageDatabase extends _$AbstractMessageDatabase {
  AbstractMessageDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (m) async {
        await m.createAll();
  });
}




