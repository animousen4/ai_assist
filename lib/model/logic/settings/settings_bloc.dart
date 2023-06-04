import 'dart:async';

import 'package:ai_assist/model/chat/extended_message.dart';
import 'package:ai_assist/model/logic/auth/token_auth_error.dart';
import 'package:ai_assist/model/logic/chat_manager/chat_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:gpt_api/gpt_api.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:ai_assist/model/db/c/token_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gpt_api/src/logic/model/requests/chat_gpt_request.dart';

import '../auth/authorization_service_v2.dart';
import '../theme/theme_bloc.dart';
part 'settings_event.dart';
part 'settings_state.dart';

const String autoChatKey = "autoOpenChat";
const String codeViewThemeIndexKey = "codeViewThemeIndex";

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final TokenDatabase tokenDatabase;
  final SharedPreferences prefs;
  late final StreamSubscription<List<GptToken>> dataSub;
  final Logger logger = Logger();
  SettingsBloc({required this.tokenDatabase, required this.prefs})
      : super(SettingsState(
            autoOpenChat: prefs.getBool(autoChatKey) ?? true,
            tokens: [],
            codeViewThemeIndex: prefs.getInt(codeViewThemeIndexKey) ?? 0,
            selectedTokens: [])) {
    dataSub = (tokenDatabase.select(tokenDatabase.gptTokens)
          ..where((tbl) => tbl.status.isNotValue(5)))
        .watch()
        .listen((event) {
      add(ReloadSettings(event));
    });
    on<ReloadSettings>((event, emit) async {
      emit(state.copyWith(tokens: event.tokens));
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
      await refreshToken(event.id);
    });
    on<SelectItem>((event, emit) {
      state.selectedTokens.contains(event.id)
          ? state.selectedTokens.remove(event.id)
          : state.selectedTokens.add(event.id);
      emit(state.copyWith(selectedTokens: state.selectedTokens));

      //logger.d(state.selectedTokens);
    });

    on<DeleteSelectedKeys>((event, emit) async {
      //emit(state);

      await (tokenDatabase.update(tokenDatabase.gptTokens)
            ..where((tbl) => tbl.id.isIn(state.selectedTokens)))
          .write(GptTokensCompanion(status: Value(5)));
      emit(state.copyWith(selectedTokens: []));
    });

    on<SelectSyntaxTheme>((event, emit) async {
      await prefs.setInt(codeViewThemeIndexKey, event.index);
      emit(state.copyWith(codeViewThemeIndex: event.index));
    });
  }

  Future<void> refreshToken(int id) async {
    await (tokenDatabase.update(tokenDatabase.gptTokens)
          ..where((tbl) => tbl.id.equals(id))
          ..where((tbl) => tbl.status.isNotValue(5)))
        .write(GptTokensCompanion(status: Value(2)));

    try {
      await ChatManager(ChatGptService.create(client(AuthorizationServiceV2(
              token: (await (tokenDatabase.select(tokenDatabase.gptTokens)
                        ..where((tbl) => tbl.id.equals(id)))
                      .get())
                  .first
                  .token))))
          .newOnlineChat
          .sendUnsavedMessages([
        ExtendedMessage(
            date: DateTime.now(), content: "Hello", role: ChatGptRole.user)
      ]);

      await (tokenDatabase.update(tokenDatabase.gptTokens)
            ..where((tbl) => tbl.id.equals(id)))
          .write(GptTokensCompanion(
              status: Value(0), refreshDate: Value(DateTime.now())));
    } on TokenAuthError catch (e) {
      logger.d("!!!!!");
      await (tokenDatabase.update(tokenDatabase.gptTokens)
            ..where((tbl) => tbl.id.equals(id)))
          .write(GptTokensCompanion(
              status: Value(e.isTemporary ? 4 : 3),
              refreshDate: Value(DateTime.now())));
    } catch (e) {
      await (tokenDatabase.update(tokenDatabase.gptTokens)
            ..where((tbl) => tbl.id.equals(id)))
          .write(GptTokensCompanion(
              status: Value(3), refreshDate: Value(DateTime.now())));
    }
  }

  Future<void> refreshAll() async {
    List<Future<void>> updates =
        (await (tokenDatabase.select(tokenDatabase.gptTokens)
                  ..where((tbl) => tbl.status.isNotValue(5)))
                .get())
            .map((e) => refreshToken(e.id))
            .toList();
    await Future.wait(updates);
  }

  @override
  Future<void> close() {
    dataSub.cancel();
    return super.close();
  }
}
