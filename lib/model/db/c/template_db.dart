import 'package:ai_assist/model/db/abstract_message_db.dart';

class TemplateDatabase extends AbstractMessageDatabase {
  TemplateDatabase() : super(openConnection("template.db"));
}