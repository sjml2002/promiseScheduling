import 'package:flutter/material.dart';
import 'package:promise_schedule/widgets/chat_messages.dart';
import 'package:promise_schedule/widgets/new_message.dart';
import './schedule_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  late String roomid;
  ChatScreen(String id, {super.key}) {
    roomid = id;
  }
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  late String roomid = widget.roomid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("id: $roomid"),
        actions: [
          IconButton(
              onPressed: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ScheduleScreen())),
                  },
              icon: const Icon(Icons.lock_clock)),
        ],
      ),
      body: Column(
        children: [Expanded(child: ChatMessages()), NewMessage()],
      ),
    );
  }
}
