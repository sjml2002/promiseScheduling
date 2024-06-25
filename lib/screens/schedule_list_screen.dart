import 'package:flutter/material.dart';
import 'package:promise_schedule/DTO/chat_room.dart';
import 'package:promise_schedule/widgets/schedule_card.dart';

class ScheduleListScreen extends StatelessWidget {
  late Future<List<ChatRoom>> futureroomlist;
  ScheduleListScreen(Future<List<ChatRoom>> userRoomList, {super.key}) {
    futureroomlist = userRoomList;
  }

  final List<String> roomid = ['1', '2', '3', '4'];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureroomlist,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ChatRoom> roomlist = snapshot.data!;
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
          } else {
            return Text("Loading...");
          }
        });
  }
}
