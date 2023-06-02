import 'package:ai_assist/model/db/c/token_db.dart';
import 'package:ai_assist/model/logic/chat_manager/chat_manager.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/logic/settings/settings_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //..add(ReloadSettings())
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (contextWithBloc, state) {
          return state.autoOpenChat == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: [
                    ListTile(
                      title: Text(
                        "Common",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SwitchListTile(
                        title: Text("Auto open chat"),
                        value: state.autoOpenChat!,
                        onChanged: (v) {
                          contextWithBloc
                              .read<SettingsBloc>()
                              .add(ChangeAutoChatStatus(v));
                        }),
                    ListTile(
                      title: Text(
                        "OpenAI Keys",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          String key = "";
                          showModalBottomSheet(
                              context: contextWithBloc,
                              builder: (context) => BottomSheet(
                                  onClosing: () {},
                                  builder: (context) => Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Add new key",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            TextFormField(
                                              onChanged: (value) =>
                                                  key = value,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Align(
                                              alignment:
                                                  Alignment.centerRight,
                                              child: TextButton(
                                                child: Text("Add"),
                                                onPressed: () {
                                                  contextWithBloc
                                                      .read<SettingsBloc>()
                                                      .add(AddKey(key));
                                                  context.popRoute();
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      )));
                        },
                      ),
                    ),
                    for (int i = 0; i < state.tokens.length; i++)
                      (GptToken gptToken) {
                        return ListTile(
                          title: Text(gptToken.token),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(gptToken.status == 0
                                ? Icons.check
                                : gptToken.status == 1
                                    ? Icons.question_mark
                                    : gptToken.status == 2
                                        ? Icons.refresh
                                        : gptToken.status == 3
                                            ? Icons.warning
                                            : Icons.remove),
                          ),
                          subtitle: Text(
                              "Last time update: ${gptToken.status == 2 ? "updating" : gptToken.refreshDate ?? "unknown"}"),
                          onLongPress: () {
                            contextWithBloc
                                .read<SettingsBloc>()
                                .add(RefreshToken(gptToken.id));
                          },
                        );
                      }(state.tokens[i])
                  ],
                );
        },
      ),
    );
  }
}
