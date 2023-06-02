import 'dart:async';

import 'package:ai_assist/model/db/c/token_db.dart';
import 'package:ai_assist/model/logic/auth/token_auth_error.dart';
import 'package:gpt_api/gpt_api.dart';

class AuthorizationServiceV2 implements AuthorizationService {
  final String token;
  AuthorizationServiceV2({required this.token}) {}

  @override
  Future<String> updateApiBearerToken(String? oldToken, int code) {
    throw TokenAuthError(oldToken, code);
  }

  @override
  String getApiBearerToken() {
    return token;
  }
}
