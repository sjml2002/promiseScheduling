import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import './chatting_room_screen.dart';

class ChatlistData {
  late String id;
  late String roomname;
  late String overviewmsg; //미리보기 메세지
  late String img; //채팅방 대표 이미지 (URL, assets 폴더 안에 있음)
  late int talkcnt; //몇개의 톡이 와있는가
}

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});
  ChatListScreenState createState() => ChatListScreenState();
}

class ChatListScreenState extends State<ChatListScreen> {
  List<ChatlistData> roomlist = [];

  String jsondataUrl = "assets/json/chat_list_dummy_data.json";

  //read .json file
  Future<void> readJson(String url) async {
    String jsonString = await rootBundle.loadString(url);
    final List decodedata = await json.decode(jsonString);
    setState(() {
      for (Map<String, dynamic> data in decodedata) {
        ChatlistData pushdata = ChatlistData();
        pushdata.id = data["id"];
        pushdata.roomname = data["roomname"];
        pushdata.overviewmsg = data["overviewmsg"];
        pushdata.img = "assets/images/${data["img"]}";
        pushdata.talkcnt = int.parse(data["talkcnt"]);
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: roomlist.length,
          itemBuilder: (context, idx) {
            return GestureDetector(
              onTap: () => NavigationSet("chat_room", roomlist[idx].id),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(roomlist[idx].img,
                            width: 60, height: 60, fit: BoxFit.cover),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              roomlist[idx].roomname,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              roomlist[idx].overviewmsg,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[600]),
                                  maxLines:1,
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
                          roomlist[idx].talkcnt.toString(),
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
      ),
    );
  }
}
