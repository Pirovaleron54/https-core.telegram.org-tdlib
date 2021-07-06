import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => <Object>[];
}

abstract class ActionEvent extends ChatEvent {
  const ActionEvent();
}

class ScrollEvent extends ChatEvent {
  const ScrollEvent();
}