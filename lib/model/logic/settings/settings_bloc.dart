import 'dart:async';

import 'package:ai_assist/model/chat/extended_message.dart';
import 'package:ai_assist/model/logic/auth/token_auth_error.dart';
import 'package:ai_assist/model/logic/chat_manager/chat_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:gpt_api/gpt_api.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:ai_assist/model/db/c/token_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gpt_api/src/logic/model/requests/chat_gpt_request.dart';

import '../auth/authorization_service_v2.dart';
part 'settings_event.dart';
part 'settings_state.dart';

const String autoChatKey = "autoOpenChat";

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final TokenDatabase tokenDatabase;
  final SharedPreferences prefs;
  late final StreamSubscription<List<GptToken>> dataSub;
  final Logger logger = Logger();
  SettingsBloc({required this.tokenDatabase, required this.prefs})
      : super(SettingsState(autoOpenChat: null, tokens: [])) {
    dataSub =
        tokenDatabase.select(tokenDatabase.gptTokens).watch().listen((event) {
      add(ReloadSettings(event));
    });
    on<ReloadSettings>((event, emit) async {
      emit(state.copyWith(
          autoOpenChat: prefs.getBool(autoChatKey), tokens: event.tokens));
    });

    on<ChangeAutoChatStatus>((event, emit) {
      prefs.setBool(autoChatKey, event.newStatus);
      emit(state.copyWith(autoOpenChat: prefs.getBool(autoChatKey)));
    });

    on<AddKey>((event, emit) async {
      int id = await tokenDatabase.into(tokenDatabase.gptTokens).insert(
          GptTokensCompanion.insert(
              isUsing: true,
              status: 1,
              addDate: DateTime.now(),
              token: event.key));
      add(RefreshToken(id));
      logger.d("New key with id: $id");
    });

    on<RefreshToken>((event, emit) async {
      await (tokenDatabase.update(tokenDatabase.gptTokens)
            ..where((tbl) => tbl.id.equals(event.id)))
          .write(GptTokensCompanion(status: Value(2)));

      try {
        await ChatManager(ChatGptService.create(client(AuthorizationServiceV2(
                token: (await (tokenDatabase.select(tokenDatabase.gptTokens)
                          ..where((tbl) => tbl.id.equals(event.id)))
                        .get())
                    .first
                    .token))))
            .newOnlineChat
            .sendUnsavedMessages([
          ExtendedMessage(
              date: DateTime.now(), content: "Hello", role: ChatGptRole.user)
        ]);

        await (tokenDatabase.update(tokenDatabase.gptTokens)
              ..where((tbl) => tbl.id.equals(event.id)))
            .write(GptTokensCompanion(
                status: Value(0), refreshDate: Value(DateTime.now())));
      } on TokenAuthError catch (e){
        logger.d("!!!!!");
        await (tokenDatabase.update(tokenDatabase.gptTokens)
              ..where((tbl) => tbl.id.equals(event.id)))
            .write(GptTokensCompanion(
                status: Value(e.isTemporary ? 4 : 3), refreshDate: Value(DateTime.now())));
      } catch (e) {
        await (tokenDatabase.update(tokenDatabase.gptTokens)
              ..where((tbl) => tbl.id.equals(event.id)))
            .write(GptTokensCompanion(
                status: Value(3), refreshDate: Value(DateTime.now())));
      }
    });
  }

  @override
  Future<void> close() {
    dataSub.cancel();
    return super.close();
  }
}
