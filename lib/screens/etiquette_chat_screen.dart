import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/etiquette_message.dart';
import '../services/ai_service.dart';

class EtiquetteChatScreen extends StatefulWidget {
  const EtiquetteChatScreen({super.key, required this.aiService});

  final AiService aiService;

  @override
  State<EtiquetteChatScreen> createState() => _EtiquetteChatScreenState();
}

class _EtiquetteChatScreenState extends State<EtiquetteChatScreen> {
  final _controller = TextEditingController();
  final _uuid = const Uuid();
  bool _loading = false;
  final List<EtiquetteMessage> _messages = [
    EtiquetteMessage(
      id: 'welcome',
      role: 'assistant',
      content:
          'Ask me about Japanese manners, trains, restaurants, shrines, temples, onsen, garbage rules, taxis, and travel situations.',
      createdAt: DateTime.now(),
    ),
  ];

  final _quickQuestions = const [
    'Can I eat while walking?',
    'Do I tip in Japan?',
    'Can I talk on the train?',
    'How do I behave at a shrine?',
    'What are onsen rules?',
    'How do I throw away garbage?',
    'What should I do if I am late?',
    'Can I use credit cards everywhere?',
    'Should I remove my shoes?',
    'How do I use a Japanese taxi?',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Etiquette Q&A')),
      body: Column(
        children: [
          SizedBox(
            height: 54,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final question = _quickQuestions[index];
                return ActionChip(
                  label: Text(question),
                  onPressed: _loading ? null : () => _submit(question),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: _quickQuestions.length,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: _messages.length + (_loading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return const _ChatBubble(
                    role: 'assistant',
                    content: 'Thinking...',
                  );
                }
                final message = _messages[index];
                return _ChatBubble(
                  role: message.role,
                  content: message.content,
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      decoration: const InputDecoration(
                        hintText: 'Ask about travel etiquette',
                      ),
                      onSubmitted: _loading ? null : _submit,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: 'Send',
                    onPressed: _loading ? null : () => _submit(_controller.text),
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit(String rawQuestion) async {
    final question = rawQuestion.trim();
    if (question.isEmpty) return;
    _controller.clear();
    setState(() {
      _loading = true;
      _messages.add(
        EtiquetteMessage(
          id: _uuid.v4(),
          role: 'user',
          content: question,
          createdAt: DateTime.now(),
        ),
      );
    });

    try {
      final answer = await widget.aiService.answerEtiquetteQuestion(question);
      if (!mounted) return;
      setState(() {
        _messages.add(
          EtiquetteMessage(
            id: _uuid.v4(),
            role: 'assistant',
            content: answer,
            createdAt: DateTime.now(),
          ),
        );
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          EtiquetteMessage(
            id: _uuid.v4(),
            role: 'assistant',
            content: 'Sorry, I could not answer that right now.',
            createdAt: DateTime.now(),
          ),
        );
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.role, required this.content});

  final String role;
  final String content;

  @override
  Widget build(BuildContext context) {
    final isUser = role == 'user';
    final colors = Theme.of(context).colorScheme;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 330),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser ? colors.primaryContainer : colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          content,
          style: TextStyle(
            color: isUser ? colors.onPrimaryContainer : colors.onSurface,
          ),
        ),
      ),
    );
  }
}
