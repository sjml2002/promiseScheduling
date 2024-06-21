import "package:flutter/material.dart";
import "package:promise_schedule/screens/schedule_detail_screen.dart";

class SchedulePreviewCard extends StatelessWidget {
  late String roomid;
  SchedulePreviewCard(String id, {super.key}) {
    roomid = id;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ScheduleScreen(roomid)));
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
                "Title",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "description",
                style: TextStyle(fontSize: 15),
              ),
              Image.asset("assets/images/schedule_preview_sample.jpg")
            ],
          ),
        ),
      ),
    );
  }
}
