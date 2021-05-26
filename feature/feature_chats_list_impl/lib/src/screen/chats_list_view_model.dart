import 'package:feature_chats_list_impl/src/chats_list_screen_router.dart';
import 'package:feature_chats_list_impl/src/list/chat_list.dart';
import 'package:feature_chats_list_impl/src/tile/chat_tile_model.dart';
import 'package:jugger/jugger.dart' as j;

import 'package:core_arch/core_arch.dart';
import 'package:tdlib/td_api.dart' as td;

class ChatsListViewModel extends BaseViewModel {
  @j.inject
  ChatsListViewModel(this._router, this._interactor) {
    _interactor.load();
  }

  final IChatsListScreenRouter _router;

  final ChatListInteractor _interactor;

  Stream<List<ChatTileModel>> get chats => _interactor.chats;

  void onChatTap(int id) {
    _router.toChat(id);
  }

  void onChatPinToggleTap(int id) {
    final td.Chat chat = _interactor.getChat(id);

    // appComponent.getTdClient().send<td.Ok>(td.ToggleChatIsPinned(
    //     chatList: const td.ChatListMain(),
    //     chatId: chat.id,
    //     isPinned: !chat.positions[0].isPinned));
  }

  void onScroll() {
    _interactor.load();
  }

  @override
  void dispose() {
    _interactor.dispose();
    super.dispose();
  }
}