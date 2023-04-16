import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

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
  final _scrollController = ScrollController();
  int _index = 0;

  void _handleSubmitted(String prompt) async {
    if (prompt.trim().isEmpty) {
      // 空の文字列が渡された場合は何もしない
      return;
    }

    _controller.clear();
    final now = DateTime.now();
    final formatter = DateFormat('HH:mm:ss');
    final formattedTime = formatter.format(now);
    ++_index;
    final message = Message(
        text: '[$_index] $formattedTime \n $prompt', isUserMessage: true);
    final response = await _chatGptApi.sendMessage(prompt);
    final responseMessage = Message(text: response, isUserMessage: false);

    setState(() {
      _messages.add(message);
      _messages.add(responseMessage);
    });

    // スクロール位置を最下部に設定する
    await Future.delayed(const Duration(milliseconds: 100));
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 1000), curve: Curves.ease);
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin:
                    const EdgeInsets.only(left: 16.0, bottom: 16.0, top: 8.0),
                child: TextField(
                  controller: _controller,
                  onSubmitted: _handleSubmitted,
                  decoration: const InputDecoration(
                    hintText: 'ご質問は？',
                  ),
                  style: const TextStyle(fontSize: 18.0),
                  keyboardType: TextInputType.multiline,
                  maxLines: null, // 入力フィールドの高さを可変にする
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
      controller: _scrollController, // set the controller
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
