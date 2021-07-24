import 'package:feature_chat_impl/src/tile/model/base_conversation_message_tile_model.dart';
import 'package:feature_chat_impl/src/widget/chat_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReplyInfoFactory {
  Widget? createFromMessageModel(
      BuildContext context, BaseConversationMessageTileModel messageModel) {
    final ReplyInfo? replyInfo = messageModel.replyInfo;
    if (replyInfo == null) {
      return null;
    }

    return _buildDecoration(context, _buildBody(context, replyInfo));
  }

  Widget _buildDecoration(
    BuildContext context,
    Widget child,
  ) {
    final ChatContextData chatContextData = ChatContext.of(context);
    return Padding(
      padding: EdgeInsets.only(
        right: chatContextData.horizontalPadding,
        top: chatContextData.verticalPadding,
        bottom: chatContextData.verticalPadding,
      ),
      child: CustomPaint(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
          ),
          child: child,
        ),
        painter: _Painter(
          theme: Theme.of(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ReplyInfo replyInfo) {
    final ThemeData theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                replyInfo.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    theme.textTheme.button!.copyWith(color: theme.primaryColor),
              ),
              Text(
                replyInfo.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        )
      ],
    );
  }
}

class _Painter extends CustomPainter {
  _Painter({required ThemeData theme})
      : _paint = Paint()
          ..color = theme.primaryColor
          ..strokeWidth = 2;

  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
        const Offset(horOffsetX, 0), Offset(horOffsetX, size.height), _paint);
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return _paint != oldDelegate._paint;
  }

  static const double horOffsetX = 8;
}