import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleScreen extends StatefulWidget {
  late String roomid;
  ScheduleScreen(String id, {super.key}) {
    roomid = id;
  }

  @override
  ScheduleScreenState createState() => ScheduleScreenState();
}

class ScheduleScreenState extends State<ScheduleScreen> {
  static const int _rows = 25;
  static const int _cols = 8;
  final userSize = 10;

  //이거 int로 하면 안되고 string 배열로 또 해서 id값 하나하나씩 비교 해야함

  List<List<int>> timeMatrix =
      List.generate(_rows, (index) => List.generate(_cols, (index) => 0));
  List<List<int>> inputTimeMatrix =
      List.generate(_rows, (index) => List.generate(_cols, (index) => 0));

  final List<String> _daysOfWeek = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  final List<String> _timesOfDay = [
    '12 AM',
    '1 AM',
    '2 AM',
    '3 AM',
    '4 AM',
    '5 AM',
    '6 AM',
    '7 AM',
    '8 AM',
    '9 AM',
    '10 AM',
    '11 AM',
    '12 PM',
    '1 PM',
    '2 PM',
    '3 PM',
    '4 PM',
    '5 PM',
    '6 PM',
    '7 PM',
    '8 PM',
    '9 PM',
    '10 PM',
    '11 PM'
  ];

  @override
  void initState() {
    print(widget.roomid);
  }

  void selectUpdate(int r, int c) {
    setState(() {
      if (inputTimeMatrix[r][c] == 1) {
        inputTimeMatrix[r][c] = 0;
      } else {
        inputTimeMatrix[r][c] = 1;
      }
    });
  }

  void _passTimeMatrix() {
    print(timeMatrix + inputTimeMatrix);

    //FireStore insert
    FirebaseFirestore.instance
        .collection('schedule_list')
        .doc(widget.roomid)
        .set({
      'scheduleData': timeMatrix + inputTimeMatrix,
      'weeks': '24/06/17 ~ 24/06/23',
    });

    //schedule view update
    Stream documentStream = FirebaseFirestore.instance
        .collection('schedule_list')
        .doc(widget.roomid)
        .snapshots();
    documentStream.listen((event) {
      Map<String, dynamic> data = jsonDecode(event);
      print(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("스케줄 드르륵 표"),
        actions: [
          TextButton(
            child: const Text("적용하기"),
            onPressed: () => _passTimeMatrix(),
          )
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _cols,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 4),
        ),
        itemCount: _rows * _cols,
        itemBuilder: (context, index) {
          int r = index ~/ _cols;
          int c = index % _cols;
          if (index == 0) {
            // 첫 번째 칸은 빈 칸으로 둡니다.
            return Container();
          } else if (index < _cols) {
            // 첫 번째 행에 요일을 표시합니다.
            return Container(
              margin: const EdgeInsets.all(1.0),
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  _daysOfWeek[index - 1],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            );
          } else if ((index) % (_cols) == 0) {
            // 첫 번째 열에 시간을 표시합니다.
            int rowIndex = (index - 1) ~/ (_cols);
            return Container(
              margin: const EdgeInsets.all(1.0),
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  _timesOfDay[rowIndex],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            );
          } else {
            int userCnt = timeMatrix[r][c] + inputTimeMatrix[r][c];
            return GestureDetector(
              onTap: () => selectUpdate(r, c),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.2),
                  color: userCnt > 0
                      ? Colors.green.withOpacity((userCnt / 10).toDouble())
                      : Colors.white,
                  //
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
