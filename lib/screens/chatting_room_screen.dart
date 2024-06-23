import 'package:flutter/material.dart';
import 'package:promise_schedule/widgets/chat_messages.dart';
import 'package:promise_schedule/widgets/new_message.dart';
import './schedule_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  late String roomid;
  ChatScreen(String id, {super.key}) {
    roomid = id;
  }

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen>{
  late String roomid = widget.roomid;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(roomid),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0){
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ScheduleScreen(),
                ),
            );
          }
        },
        child: Column(
          children: [Expanded(child: ChatMessages()), NewMessage()],
        ),
      ),
    );
  }
}
