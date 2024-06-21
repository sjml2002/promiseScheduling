import 'package:flutter/material.dart';
import 'package:promise_schedule/widgets/schedule_card.dart';

class ScheduleListScreen extends StatelessWidget {
  ScheduleListScreen({super.key});

  final List<String> roomid = ['1', '2', '3', '4'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SchedulePreviewCard(roomid[0]),
          SchedulePreviewCard(roomid[1]),
          SchedulePreviewCard(roomid[2]),
          SchedulePreviewCard(roomid[3])
        ],
      ),
    );
  }
}
