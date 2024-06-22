import '../DTO/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//// 해당 UserEmail이 들어있는 방들을 Class List로 반환 ////
List<ChatRoom> getUserInRoom(String userEmail) {
  List<ChatRoom> roomlist = [];
  FirebaseFirestore.instance
      .collection('rooms')
      .where('email', arrayContains: userEmail)
      .get()
      .then((roomData) {
    if (roomData.docs.isNotEmpty) {
      print(roomData);

      // for (Map<String, dynamic> data in decodedata) {
      //   ChatRoom pushdata = ChatRoom();
      //   pushdata.setID(data["id"]);
      //   pushdata.setName(data["roomname"]);
      //   pushdata.setMode(data["mode"]);
      //   pushdata.setImg("assets/images/${data["img"]}");
      //   pushdata.setOvm(data["overviewmsg"]);
      //   pushdata.setTalkCnt(int.parse(data["talkcnt"]));
      //   // print(data["users"]); //debug
      //   // print(data["users"].runtimeType); //debug
      //   // List<dynamic> arr = json.decode(data["users"]);
      //   // print(arr.runtimeType); //debug
      //   // for (var usr in arr) {
      //   //   pushdata.appendUser(usr.toString());
      //   // }
      //   roomlist.add(pushdata);
      // }
    }
    return (roomlist);
  }).catchError((error) {
    print("get roomlist something Error: $error");
  });
  return (roomlist);
}
