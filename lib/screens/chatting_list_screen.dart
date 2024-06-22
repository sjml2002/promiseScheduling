import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import './chatting_room_screen.dart';
import '../DTO/chat_room.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});
  ChatListScreenState createState() => ChatListScreenState();
}

class ChatListScreenState extends State<ChatListScreen> {
  List<ChatRoom> roomlist = [];

  String jsondataUrl = "assets/json/chat_list_dummy_data.json";

  //read .json file
  Future<void> readJson(String url) async {
    String jsonString = await rootBundle.loadString(url);
    final List decodedata = await json.decode(jsonString);
    setState(() {
      for (Map<String, dynamic> data in decodedata) {
        ChatRoom pushdata = ChatRoom();
        pushdata.setID(data["id"]);
        pushdata.setName(data["roomname"]);
        pushdata.setMode(data["mode"]);
        pushdata.setImg("assets/images/${data["img"]}");
        pushdata.setOvm(data["overviewmsg"]);
        pushdata.setTalkCnt(int.parse(data["talkcnt"]));
        // print(data["users"]); //debug
        // print(data["users"].runtimeType); //debug
        // List<dynamic> arr = json.decode(data["users"]);
        // print(arr.runtimeType); //debug
        // for (var usr in arr) {
        //   pushdata.appendUser(usr.toString());
        // }
        roomlist.add(pushdata);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    readJson(jsondataUrl);
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat List"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: roomlist.length,
        itemBuilder: (context, idx) {
          return GestureDetector(
            onTap: () => NavigationSet("chat_room", roomlist[idx].getRoomId()),
            child: Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(roomlist[idx].getImg(),
                          width: 60, height: 60, fit: BoxFit.cover),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            roomlist[idx].getRoomName(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            roomlist[idx].getOvm(),
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        roomlist[idx].getTalkCnt().toString(),
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
