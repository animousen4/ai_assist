import 'package:ai_assist/model/db/abstract_message_db.dart';

import '../db_connection.dart';

class MessageDatabase extends AbstractMessageDatabase {
  MessageDatabase() : super(openConnection("message.sqlite"));
}
