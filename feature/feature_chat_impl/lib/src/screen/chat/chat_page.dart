import 'package:core_arch/core_arch.dart';
import 'package:feature_chat_header_info_api/feature_chat_header_info_api.dart';
import 'package:feature_chat_impl/src/widget/chat_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tile/tile.dart';

import 'bloc/chat_state.dart';
import 'bloc/chat_view_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final ScrollController _messagesScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messagesScrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _messagesScrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ChatViewModel viewModel = context.read();
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        titleSpacing: 0.0,
        title: StreamListener<HeaderState>(
          stream: viewModel.headerStateStream,
          builder: (BuildContext context, HeaderState data) {
            final IChatHeaderInfoFactory chatHeaderInfoFactory = context.read();
            return chatHeaderInfoFactory.create(
              context: context,
              info: data.info,
            );
          },
        ),
      ),
      body: StreamListener<BodyState>(
        stream: viewModel.bodyStateStream,
        builder: (BuildContext context, BodyState data) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: data.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (List<ITileModel> models) {
                return _ChatContextWrapper(
                  child: _Messages(
                    scrollController: _messagesScrollController,
                    models: models,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _onScroll() {
    final double extentAfter = _messagesScrollController.position.extentAfter;
    if (extentAfter < 200) {
      context.read<ChatViewModel>().onLoadMore();
    }
  }
}

class _ChatContextWrapper extends StatelessWidget {
  const _ChatContextWrapper({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ChatContext(
          data: ChatContextData.desktop(maxWidth: constraints.maxWidth),
          child: child,
        );
      },
    );
  }
}

class _Messages extends StatelessWidget {
  const _Messages(
      {Key? key, required this.scrollController, required this.models})
      : super(key: key);

  final ScrollController scrollController;
  final List<ITileModel> models;

  @override
  Widget build(BuildContext context) {
    final TileFactory tileFactory = context.read();
    return Scrollbar(
      child: ListView.builder(
        // todo extract to config
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        controller: scrollController,
        reverse: true,
        itemCount: models.length,
        itemBuilder: (BuildContext context, int index) {
          final ITileModel tileModel = models[index];
          return tileFactory.create(context, tileModel);
        },
      ),
    );
  }
}
