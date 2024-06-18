import "package:flutter/material.dart";

class SchedulePreviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Title"),
            Text("description"),
            Image.asset("assets/images/schedule_preview_sample.jpg")
          ],
        ),
      ),
    );
  }
}
