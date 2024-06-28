import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './chatting_room_screen.dart';
import '../DTO/chat_room.dart';
import 'package:promise_schedule/widgets/chat_list_card.dart';

class ChatListScreen extends StatefulWidget {
  late final Future<List<ChatRoom>> roomlist;
  ChatListScreen(Future<List<ChatRoom>> futureroomlist, {super.key}) {
    roomlist = futureroomlist;
  }

  ChatListScreenState createState() => ChatListScreenState();
}

class ChatListScreenState extends State<ChatListScreen> {
  String jsondataUrl = "assets/json/chat_list_dummy_data.json";

  @override
  void initState() {
    super.initState();
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
    return FutureBuilder(
        future: widget.roomlist,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ChatRoom> roomlist = snapshot.data!;
            return SingleChildScrollView(
                child: Column(children: [
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: roomlist.length,
                itemBuilder: (context, idx) {
                  return GestureDetector(
                    onTap: () =>
                        NavigationSet("chat_room", roomlist[idx].getRoomId()),
                    child: ChatListCard(roomlist[idx]),
                  );
                },
              )
            ]));
          } else {
            return (const Text("Loading..."));
          }
        });
  }
}
