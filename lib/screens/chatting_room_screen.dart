import 'package:flutter/material.dart';
import 'package:promise_schedule/widgets/chat_messages.dart';
import 'package:promise_schedule/widgets/new_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterChat'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.exit_to_app,
            ),
          ),
        ],
      ),
      body: Column(
        children: [Expanded(child: ChatMessages()), NewMessage()],
      ),
    );
  }
}
