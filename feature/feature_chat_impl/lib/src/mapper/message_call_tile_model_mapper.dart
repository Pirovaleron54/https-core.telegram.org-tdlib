import 'package:core_utils/core_utils.dart';
import 'package:coreui/coreui.dart';
import 'package:feature_chat_impl/feature_chat_impl.dart';
import 'package:feature_chat_impl/src/resolver/sender_name_resolver.dart';
import 'package:intl/intl.dart';
import 'package:localization_api/localization_api.dart';
import 'package:tdlib/td_api.dart' as td;

import 'additional_info_mapper.dart';
import 'message_reply_info_mapper.dart';

class MessageCallTileModelMapper {
  MessageCallTileModelMapper(
      {required ILocalizationManager localizationManager,
      required SenderNameResolver senderNameResolver,
      required AdditionalInfoMapper additionalInfoMapper,
      required MessageReplyInfoMapper messageReplyInfoMapper,
      required DateParser dateParser})
      : _localizationManager = localizationManager,
        _senderNameResolver = senderNameResolver,
        _additionalInfoMapper = additionalInfoMapper,
        _messageReplyInfoMapper = messageReplyInfoMapper,
        _dateParser = dateParser;

  final DateFormat _callDateFormat = DateFormat('HH:mm');

  final SenderNameResolver _senderNameResolver;
  final ILocalizationManager _localizationManager;
  final MessageReplyInfoMapper _messageReplyInfoMapper;
  final AdditionalInfoMapper _additionalInfoMapper;
  final DateParser _dateParser;

  Future<ITileModel> mapToTileModel({
    required td.Message message,
    required td.MessageCall content,
  }) async {
    final DateTime callDate =
        _dateParser.parseUnixTimeStampToDate(message.date);
    // todo handle video calls
    return MessageCallTileModel(
        id: message.id,
        senderName: await _senderNameResolver.resolve(message.sender),
        replyInfo: await _messageReplyInfoMapper.mapToReplyInfo(message),
        additionalInfo: await _additionalInfoMapper.map(message),
        isOutgoing: message.isOutgoing,
        duration: _getDuration(content.duration),
        date: _callDateFormat.format(callDate),
        title: _toHumanString(message.isOutgoing, content.discardReason));
  }

  String? _getDuration(int durationSeconds) {
    if (durationSeconds <= 0) {
      return null;
    }

    final Duration duration = Duration(seconds: durationSeconds);

    // TODO plurals for hours and etc.
    return '${duration.inSeconds} seconds';
  }

  String _toHumanString(bool isOutgoing, td.CallDiscardReason reason) {
    switch (reason.getConstructor()) {
      case td.CallDiscardReasonEmpty.CONSTRUCTOR:
        {
          //TODO replace by actual text
          return 'todo ???';
        }
      case td.CallDiscardReasonMissed.CONSTRUCTOR:
        {
          if (isOutgoing) {
            return _localizationManager.getString('CallMessageOutgoingMissed');
          }
          return _localizationManager.getString('CallMessageIncomingMissed');
        }
      case td.CallDiscardReasonDeclined.CONSTRUCTOR:
        {
          if (isOutgoing) {
            return _localizationManager.getString('CallMessageOutgoing');
          }
          return _localizationManager.getString('CallMessageIncomingDeclined');
        }
      case td.CallDiscardReasonDisconnected.CONSTRUCTOR:
        {
          //TODO replace by actual text
          return 'todo Disconnected';
        }
      case td.CallDiscardReasonHungUp.CONSTRUCTOR:
        {
          if (isOutgoing) {
            return _localizationManager.getString('CallMessageOutgoing');
          }
          return _localizationManager.getString('CallMessageIncoming');
        }
    }
    return '';
  }
}
