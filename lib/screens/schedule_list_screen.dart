import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:promise_schedule/DTO/GlobalVariable.dart';
import 'package:promise_schedule/DTO/chat_room.dart';
import 'package:promise_schedule/widgets/schedule_card.dart';
import 'package:provider/provider.dart';

class ScheduleListScreen extends StatefulWidget {
  @override
  _ScheduleListScreenState createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
  String? userEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  void initState() {
    super.initState();
    //initState에 넣음으로써 Provider의 함수가 한번만 호출되도록 하기
    Provider.of<RoomListProvider>(context, listen: false).getUserInRoom(userEmail);
  }

  @override
  Widget build(BuildContext context) {
    final roomListProvider = Provider.of<RoomListProvider>(context);
    List<ChatRoom> roomlist = roomListProvider.userRoomList;
    //print(roomlist); //debug

    return SingleChildScrollView(
        child: Column(children: [
      ListView.builder(
        shrinkWrap: true, // 중요: 필요한 공간만 차지하도록 설정
        itemCount: roomlist.length,
        itemBuilder: (context, idx) {
          return SchedulePreviewCard(roomlist[idx]);
        },
      )
    ]));
  }
}
