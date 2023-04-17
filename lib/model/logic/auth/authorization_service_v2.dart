import 'dart:async';

import 'package:ai_assist/model/db/c/token_db.dart';
import 'package:gpt_api/gpt_api.dart';

class AuthorizationServiceV2 implements AuthorizationService {
  final TokenDatabase td;
  AuthorizationServiceV2({required this.td}) {}

  @override
  Future<String> updateApiBearerToken() {
    throw UnimplementedError();
  }

  @override
  String getApiBearerToken() {
    (td.select(td.gptTokens)
          ..where((tbl) => tbl.isUsing)
          ..where((tbl) => tbl.status.equals(0)))
        .get();
    // TODO: implement getApiBearerToken
    throw UnimplementedError();
  }
}
