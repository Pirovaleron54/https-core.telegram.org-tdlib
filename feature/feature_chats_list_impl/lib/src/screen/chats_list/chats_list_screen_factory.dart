import 'package:feature_chats_list_api/feature_chats_list_api.dart';
import 'package:feature_chats_list_impl/feature_chats_list_impl.dart';
import 'package:feature_chats_list_impl/src/di/chats_list_screen_component.dart';
import 'package:feature_chats_list_impl/src/di/chats_list_screen_component.jugger.dart';
import 'package:feature_chats_list_impl/src/screen/chats_list/chats_list_page.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider_extensions/provider_extensions.dart';
import 'package:tile/tile.dart';

import 'chats_list_view_model.dart';

class ChatsListScreenFactory implements IChatsListScreenFactory {
  ChatsListScreenFactory({
    required ChatsListFeatureDependencies dependencies,
  }) : _dependencies = dependencies;

  final ChatsListFeatureDependencies _dependencies;

  @override
  Widget create() {
    return Scope<ChatsListScreenComponent>(
      create: () => JuggerChatsListScreenComponentBuilder()
          .dependencies(_dependencies)
          .build(),
      providers: (ChatsListScreenComponent value) {
        return <Provider<dynamic>>[
          Provider<TileFactory>(
            create: (_) => value.getTileFactory(),
          ),
          Provider<ChatsListViewModel>(
            dispose: (_, ChatsListViewModel value) {
              value.dispose();
            },
            create: (_) => value.getChatsListViewModel(),
          ),
        ];
      },
      child: const ChatsListPage(),
    );
  }
}