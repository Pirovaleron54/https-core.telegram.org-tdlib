import 'package:coreui/coreui.dart' as tg;
import 'package:feature_chat_api/feature_chat_api.dart';
import 'package:feature_chat_header_info_api/feature_chat_header_info_api.dart';
import 'package:feature_chat_impl/feature_chat_impl.dart';
import 'package:feature_chat_impl/src/di/di.dart';
import 'package:feature_chat_impl/src/screen/chat/bloc/chat_bloc.dart';
import 'package:feature_chat_impl/src/screen/chat/chat_args.dart';
import 'package:feature_chat_impl/src/screen/chat/chat_page.dart';
import 'package:feature_chat_impl/src/widget/chat_message/chat_message.dart';
import 'package:feature_chat_impl/src/widget/theme/chat_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization_api/localization_api.dart';
import 'package:provider/provider.dart';

class ChatScreenFactory implements IChatScreenFactory {
  ChatScreenFactory({required this.dependencies});

  final IChatFeatureDependencies dependencies;

  @override
  Widget create(BuildContext context, int chatId) {
    return Provider<ChatScreenComponent>(
      create: (_) => JuggerChatScreenComponentBuilder()
          .dependencies(dependencies)
          .chatArgs(ChatArgs(chatId))
          .build(),
      child: MultiProvider(
        providers: <Provider<dynamic>>[
          Provider<tg.TileFactory>(
            create: (BuildContext context) =>
                context.getComponent().getTileFactory(),
          ),
          Provider<ChatMessageFactory>(
            create: (BuildContext context) =>
                context.getComponent().getChatMessageFactory(),
          ),
          Provider<ILocalizationManager>(
            create: (BuildContext context) =>
                context.getComponent().getLocalizationManager(),
          ),
          Provider<IChatHeaderInfoFactory>(
            create: (BuildContext context) =>
                context.getComponent().getChatHeaderInfoFactory(),
          ),
        ],
        child: BlocProvider<ChatBloc>(
            create: (BuildContext context) =>
                context.getComponent().getChatBloc(),
            child: ChatTheme(
              data: ChatThemeData.light(context: context),
              child: const ChatPage(),
            )),
      ),
    );
  }
}

extension _ContextExt on BuildContext {
  ChatScreenComponent getComponent() =>
      Provider.of<ChatScreenComponent>(this, listen: false);
}