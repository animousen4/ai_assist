import 'dart:async';

import 'package:ai_assist/model/db/c/token_db.dart';
import 'package:drift/drift.dart';
import 'package:gpt_api/gpt_api.dart';
import 'package:logger/logger.dart';

class NoAuthorizationKeys implements Exception {}

class MultiAuthorizationService extends AuthorizationService {
  final TokenDatabase tokenDatabase;
  final Logger logger = Logger();

  MultiAuthorizationService(this.tokenDatabase);

  @override
  FutureOr<String> getApiBearerToken() async {
    final tokens = await (tokenDatabase.select(tokenDatabase.gptTokens)
              ..where((tbl) => tbl.status.equals(0))
              ..where((tbl) => tbl.isUsing.equals(true)))
            .get() +
        await (tokenDatabase.select(tokenDatabase.gptTokens)
              ..where((tbl) => tbl.status.equals(4))
              ..where((tbl) => tbl.isUsing.equals(true))
              ..where((tbl) => tbl.refreshDate
                  .modify(DateTimeModifier.seconds(20))
                  .isSmallerOrEqualValue(DateTime.now())))
            .get();
    if (tokens.isEmpty) {
      throw NoAuthorizationKeys();
    } else {
      await (tokenDatabase.update(tokenDatabase.gptTokens)
            ..where((tbl) => tbl.id.equals(tokens.first.id)))
          .write(GptTokensCompanion(
              status: Value(0), refreshDate: Value(DateTime.now())));
      return tokens.first.token;
    }
  }

  @override
  Future<String> updateApiBearerToken(String? oldToken, int code) async {
    logger.d("New token is required. Old token: $oldToken");
    // if header is null, correct the code Chopper -> send(req, response, request);
    await (tokenDatabase.update(tokenDatabase.gptTokens)
          ..where((tbl) => tbl.token.equals(oldToken!)))
        .write(GptTokensCompanion(
            status: Value(code == 429 ? 4 : 3),
            refreshDate: Value(DateTime.now())));
    return await getApiBearerToken();
  }
}
