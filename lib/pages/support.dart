import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'package:zavod/widgets/app_drawer.dart';

class SupportChatPage extends StatefulWidget {
  const SupportChatPage({super.key});

  @override
  State<SupportChatPage> createState() => _SupportChatPageState();
}

const supportImage =
    "https://thumbs.dreamstime.com/b/cute-friendly-robot-hand-up-hello-ai-stock-virtual-smart-assistant-bot-icon-customer-support-chat-bot-innovation-cute-358304437.jpg";

class _SupportChatPageState extends State<SupportChatPage> {
  final List<types.Message> _messages = [];
  final _user = const types.User(
    id: 'user',
    imageUrl:
        'https://t3.ftcdn.net/jpg/02/99/04/20/360_F_299042079_vGBD7wIlSeNl7vOevWHiL93G4koMM967.jpg',
  );
  final _supportUser = const types.User(id: 'support', imageUrl: supportImage);

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().toString(),
      text: message.text,
    );

    _addMessage(textMessage);

    // Simulate a response from support
    Future.delayed(Duration(seconds: 1), () {
      final responseMessage = types.TextMessage(
        author: _supportUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: DateTime.now().toString(),
        text: 'Thank you for your message. We will get back to you shortly.',
      );

      _addMessage(responseMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: CircleAvatar(backgroundImage: NetworkImage(supportImage)),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
        showUserAvatars: true,
        showUserNames: true,
        inputOptions: InputOptions(keyboardType: TextInputType.none),
      ),
    );
  }
}
