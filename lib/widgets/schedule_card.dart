import "package:flutter/material.dart";
import "package:promise_schedule/DTO/chat_room.dart";
import "package:promise_schedule/screens/one_time_schdule_detail_screen.dart";
import "package:promise_schedule/screens/schedule_detail_screen.dart";

class SchedulePreviewCard extends StatelessWidget {
  late ChatRoom room;
  SchedulePreviewCard(ChatRoom userRoomList, {super.key}) {
    room = userRoomList;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (room.getMode() == "정기모임") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ScheduleScreen(room.getRoomId())));
        } else if (room.getMode() == "일회성만남") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OneTimeScheduleScreen(room.getRoomId())));
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "${room.getRoomName()}",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "${room.getMode()}",
                style: TextStyle(fontSize: 15),
              ),
              Image.asset(room.getImg())
            ],
          ),
        ),
      ),
    );
  }
}
