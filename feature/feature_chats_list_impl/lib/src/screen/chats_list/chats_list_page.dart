import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tile/tile.dart';

import 'chats_list_state.dart';
import 'chats_list_view_model.dart';

class ChatsListPage extends StatelessWidget {
  const ChatsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ChatsListState>(
        stream: context.read<ChatsListViewModel>().chatsListState,
        initialData: const ChatsListState.loading(),
        builder:
            (BuildContext context, AsyncSnapshot<ChatsListState> snapshot) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: snapshot.data!.when(
              loading: () => const _Skeleton(),
              data: (List<ITileModel> models) => _Data(models: models),
            ),
          );
        },
      ),
    );
  }
}

class _SkeletonItem extends StatelessWidget {
  const _SkeletonItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 78,
          child: Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: CircleAvatar(radius: 28),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 16.0,
                        color: Colors.white,
                      ),
                      // const SizedBox(height: 16),
                      const Spacer(),
                      Container(
                        height: 16.0,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, __) => const _SkeletonItem(),
      ),
    );
  }
}

class _Data extends StatelessWidget {
  const _Data({
    required this.models,
    Key? key,
  }) : super(key: key);

  final List<ITileModel> models;

  @override
  Widget build(BuildContext context) {
    final TileFactory tileFactory = context.read();
    return Scrollbar(
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return Divider(indent: 72, height: 0, color: Colors.grey[400]);
        },
        itemCount: models.length,
        itemBuilder: (BuildContext context, int index) {
          return tileFactory.create(context, models[index]);
        },
      ),
    );
  }
}