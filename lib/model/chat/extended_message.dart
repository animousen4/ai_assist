import 'package:gpt_api/gpt_api.dart';

class ExtendedMessage extends MessageAdapter{
  final DateTime date;

  ExtendedMessage({required this.date, required super.content, required super.role});
}
