import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/ai_models.dart';
import '../providers/app_providers.dart';
import '../services/groq_service.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/typing_indicator.dart';

class AIchatScreen extends ConsumerStatefulWidget {
  const AIchatScreen({super.key});

  @override
  ConsumerState<AIchatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends ConsumerState<AIchatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final chatNotifier = ref.read(chatMessagesProvider.notifier);
    final welcomeMessage = ChatMessage(
      id: 'welcome',
      content: '''Hello! I'm your AI career assistant. I can help you with:

🎯 Career planning and advice
📝 Resume optimization
💼 Job search strategies
🎤 Interview preparation
📊 Skill development recommendations
🔍 Industry insights

What would you like to discuss today?''',
      isUser: false,
      timestamp: DateTime.now(),
      type: ChatMessageType.text,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatNotifier.addMessage(welcomeMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatMessages = ref.watch(chatMessagesProvider);
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.psychology,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text('AI Career Assistant'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearChat,
            tooltip: 'Clear Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          if (userProfile == null) _buildProfilePrompt(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: chatMessages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == chatMessages.length && _isTyping) {
                  return const TypingIndicator();
                }

                final message = chatMessages[index];
                return ChatMessageWidget(
                  message: message,
                  isUser: message.isUser,
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildProfilePrompt() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Upload your resume or add profile details for personalized advice!',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Ask me anything about your career...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton.small(
            onPressed: _isTyping
                ? null
                : () => _sendMessage(_messageController.text),
            child: _isTyping
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String text) async {
    print('DEBUG: _sendMessage called with text: $text');
    print('DEBUG: GroqService.isConfigured: ${GroqService.isConfigured}');
    print('DEBUG: GROQ_API_KEY: ${dotenv.env['GROQ_API_KEY']}');
    final groqService = ref.read(groqServiceProvider);
    if (text.trim().isEmpty) return;

    final chatNotifier = ref.read(chatMessagesProvider.notifier);
    final userProfile = ref.read(userProfileProvider);
    final chatMessages = ref.read(chatMessagesProvider);

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: text,
      isUser: true,
      timestamp: DateTime.now(),
      type: ChatMessageType.text,
    );

    chatNotifier.addMessage(userMessage);
    _messageController.clear();
    _scrollToBottom();

    // Show typing indicator
    setState(() {
      _isTyping = true;
    });

    try {
      // Get AI response
      final response = await groqService.chatWithAssistant(
        userMessage: text,
        conversationHistory: chatMessages,
        userProfile: userProfile,
      );

      // Add AI response
      final aiMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response,
        isUser: false,
        timestamp: DateTime.now(),
        type: ChatMessageType.text,
      );

      chatNotifier.addMessage(aiMessage);
    } catch (e, stack) {
      print('DEBUG: Error in _sendMessage:');
      print(e);
      print(stack);
      // Add error message
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content:
            'Sorry, I encountered an error. Please make sure you have configured your API key and try again.',
        isUser: false,
        timestamp: DateTime.now(),
        type: ChatMessageType.text,
      );

      chatNotifier.addMessage(errorMessage);
    } finally {
      setState(() {
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearChat() {
    final chatNotifier = ref.read(chatMessagesProvider.notifier);
    chatNotifier.clearMessages();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
