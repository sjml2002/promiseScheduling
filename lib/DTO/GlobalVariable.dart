import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:promise_schedule/DTO/chat_room.dart';

class RoomListProvider extends ChangeNotifier {
////////////// 전역 변수들 /////////////
  List<ChatRoom> userRoomList = [];




////////// 전역 변수들을 변경할 함수들 //////////
  void getUserInRoom(String? userEmail) async {
    print("get user in room 호출됨?"); //debug
    List<ChatRoom> roomlist = [];
    await FirebaseFirestore.instance
        .collection('rooms')
        .where('users', arrayContains: userEmail)
        .get()
        .then((roomData) {
      if (roomData.docs.isNotEmpty) {
        for (var tmp in roomData.docs) {
          Map<String, dynamic> room = tmp.data();
          ChatRoom pushdata = ChatRoom();
          pushdata.setID(tmp.id);
          pushdata.setName(room["roomname"]);
          pushdata.setMode(room["mode"]);
          for (var user in room["users"]) {
            pushdata.appendUser(user.toString());
          }
          //여기 아래 3개는 다시 해야됨
          pushdata.setImg("assets/images/schedule_preview_sample.jpg");
          pushdata.setOvm("임시 미리보기");
          pushdata.setTalkCnt(0);
          roomlist.add(pushdata);
        }
      }
      //return (roomlist);
    }).catchError((error) {
      print("get roomlist something Error: $error");
    });
    userRoomList = roomlist;
    notifyListeners();
  }
}
