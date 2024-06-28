import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:promise_schedule/DTO/GlobalVariable.dart';
import 'package:provider/provider.dart';
import './chatting_room_screen.dart';
import '../DTO/chat_room.dart';
import 'package:promise_schedule/widgets/chat_list_card.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  ChatListScreenState createState() => ChatListScreenState();
}

class ChatListScreenState extends State<ChatListScreen> {
  String? userEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  void initState() {
    super.initState();
    //initState에 넣음으로써 Provider의 함수가 한번만 호출되도록 하기
    Provider.of<RoomListProvider>(context, listen: false).getUserInRoom(userEmail);
  }

/////////// Navigation //////////
  NavigationSet(String destination, String data) {
    //data를 setState하기 전에 위젯이 빌드될 경우 오류
    //따라서 addPostFrameCallback을 사용하여 무조건 빌드가 된 후 실행될 수 있도록 하기
    if (destination == "chat_room") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ChatScreen(data)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomListProvider = Provider.of<RoomListProvider>(context);
    List<ChatRoom> roomlist = roomListProvider.userRoomList;
    return SingleChildScrollView(
        child: Column(children: [
      ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: roomlist.length,
        itemBuilder: (context, idx) {
          return GestureDetector(
            onTap: () => NavigationSet("chat_room", roomlist[idx].getRoomId()),
            child: ChatListCard(roomlist[idx]),
          );
        },
      )
    ]));
  }
}
