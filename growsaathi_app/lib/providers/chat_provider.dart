import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat/chat_message_model.dart';
import '../services/chat/ai_service.dart';
import '../services/chat/offline_ai_service.dart';

final aiServiceProvider = Provider<AiService>((ref) => OfflineAiService());

class ChatState {
  final List<ChatMessageModel> messages;
  final bool isTyping;

  const ChatState({this.messages = const [], this.isTyping = false});

  ChatState copyWith({List<ChatMessageModel>? messages, bool? isTyping}) {
    return ChatState(messages: messages ?? this.messages, isTyping: isTyping ?? this.isTyping);
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier(this._aiService)
      : super(ChatState(messages: [
          ChatMessageModel(
            id: 'welcome',
            text: "Hi! I'm GrowSAATHI. Ask me about today's sales, low stock, or inactive customers.",
            sender: ChatSender.bot,
            timestamp: DateTime.now(),
          ),
        ]));

  final AiService _aiService;
  int _counter = 0;

  String _nextId() {
    _counter += 1;
    return 'msg-${DateTime.now().millisecondsSinceEpoch}-$_counter';
  }

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final userMessage = ChatMessageModel(
      id: _nextId(),
      text: trimmed,
      sender: ChatSender.user,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(messages: [...state.messages, userMessage], isTyping: true);

    final answer = await _aiService.ask(trimmed);

    final botMessage = ChatMessageModel(
      id: _nextId(),
      text: answer,
      sender: ChatSender.bot,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(messages: [...state.messages, botMessage], isTyping: false);
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref.watch(aiServiceProvider));
});
