import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/widgets/chat_bubble.dart';
import '/services/chatgpt_api.dart';
import '/models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _chatGptApi = ChatGptApi();
  final _messages = <Message>[];

  void _handleSubmitted(String prompt) async {
    if (prompt.trim().isEmpty) {
      // 空の文字列が渡された場合は何もしない
      return;
    }

    _controller.clear();
    final response = await _chatGptApi.sendMessage(prompt);
    final message = Message(text: prompt, isUserMessage: true);
    final responseMessage = Message(text: response, isUserMessage: false);

    setState(() {
      _messages.insert(0, responseMessage);
      _messages.insert(0, message);
    });
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _controller,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_controller.text),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _messages.length,
      itemBuilder: (context, i) {
        final message = _messages[i];
        return ChatBubble(
          text: message.text,
          isUserMessage: message.isUserMessage,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with AI'),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessages()),
          _buildTextComposer(),
        ],
      ),
    );
  }
}
