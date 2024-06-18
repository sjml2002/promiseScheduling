import 'package:flutter/material.dart';
import 'package:promise_schedule/widgets/schedule_card.dart';

class ScheduleListScreen extends StatelessWidget {
  const ScheduleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SchedulePreviewCard(),
          SchedulePreviewCard(),
          SchedulePreviewCard(),
          SchedulePreviewCard()
        ],
      ),
    );
  }
}
