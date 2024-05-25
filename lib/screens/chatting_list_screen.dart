import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

class ChatlistData {
  late String roomname; 
  late String overviewmsg; //미리보기 메세지
  late String img; //채팅방 대표 이미지 (URL, assets 폴더 안에 있음)
  late int talkcnt; //몇개의 톡이 와있는가
}

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);
  ChatListScreenState createState() => ChatListScreenState();
}



class ChatListScreenState extends State<ChatListScreen> {
  List<ChatlistData> roomlist = [];

  String jsondataUrl = "assets/json/chat_list_dummy_data.json";

  //read .json file
  Future<void> readJson(String url) async {
    String jsonString = await rootBundle.loadString(url);
    final List decodedata = await json.decode(jsonString);
    print("decodedata: $decodedata"); //debug
    setState(() {
      for(Map<String, dynamic> data in decodedata) {
        ChatlistData pushdata = ChatlistData();
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


  @override
  Widget build(BuildContext context) {
    for (var room in roomlist) {
      print(room.roomname);
    }
    return Column(
      children: [
        Expanded(
        flex: 1,
        child: ListView.builder(
          itemCount: roomlist.length,
          itemBuilder: (context, idx) {
            return Row(
                children: [
                  Container(
                    child: Image.asset(
                      roomlist[idx].img,
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain
                    ),
                  ),
                  Container(
                    child: Text("${roomlist[idx].roomname}"),
                  ),
                  Container(
                    child: Text(roomlist[idx].overviewmsg),
                  ),
                  Container(
                    child: Text(roomlist[idx].talkcnt.toString()),
                  ),
                ],
            );
          }
        ),
      )]
    );
  }
}
