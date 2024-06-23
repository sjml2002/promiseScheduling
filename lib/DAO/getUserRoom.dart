import '../DTO/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//// 해당 UserEmail이 들어있는 방들을 Class List로 반환 ////
Future<List<ChatRoom>> getUserInRoom(String? userEmail) async {
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
        for(var user in room["users"]) {
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
  return (roomlist);
}