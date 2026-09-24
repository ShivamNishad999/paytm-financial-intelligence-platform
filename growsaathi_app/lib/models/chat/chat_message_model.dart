enum ChatSender { user, bot }

class ChatMessageModel {
  final String id;
  final String text;
  final ChatSender sender;
  final DateTime timestamp;

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
  });

  bool get isUser => sender == ChatSender.user;
}
