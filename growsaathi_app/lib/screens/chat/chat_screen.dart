import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/chat/chat_message_bubble.dart';

const _suggestedQuestions = [
  "Today's sales?",
  'Low stock?',
  'Inactive customers',
  'Best-selling products',
  'What should I do today?',
];

/// Ask GrowSAATHI (Module 4). Fully offline — answers come from
/// `OfflineAiService`'s local business rules, not a language model
/// (see the backend AI reality check: the real backend's chatbot is
/// the same kind of rule-based system, just server-side).
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send([String? preset]) async {
    final text = preset ?? _controller.text;
    if (text.trim().isEmpty) return;
    _controller.clear();
    await ref.read(chatProvider.notifier).send(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    _scrollToBottom();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.smart_toy_outlined, color: AppColors.purple),
            SizedBox(width: 8),
            Text('Ask GrowSAATHI'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.aiSurface,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Running in offline mode — answers use on-device business rules, not live AI.',
                style: AppTextStyles.caption,
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: chatState.messages.length + (chatState.isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= chatState.messages.length) {
                    return const TypingIndicatorBubble();
                  }
                  return ChatMessageBubble(message: chatState.messages[index]);
                },
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _suggestedQuestions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final question = _suggestedQuestions[index];
                  return ActionChip(
                    label: Text(question),
                    onPressed: chatState.isTyping ? null : () => _send(question),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(hintText: 'Ask about your business...'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: chatState.isTyping ? null : () => _send(),
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
