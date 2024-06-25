import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './chatting_room_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleScreen extends StatefulWidget {
  late final String roomid;
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
  String userId = FirebaseAuth.instance.currentUser!.uid;

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
    //super.initState();
    print(widget.roomid);
    setScheduling();
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
    //FireStore insert

    CollectionReference scheduleListCollection =
        FirebaseFirestore.instance.collection('schedule_list');
    scheduleListCollection.doc(widget.roomid).set({
      'user:$userId': json.encode(inputTimeMatrix),
      'weeks': '24/06/17 ~ 24/06/23',
    }, SetOptions(merge: true)) //기존 필드값은 건들이지 않도록
        .then((value) {
      print("scheduling setting!"); //debug
    }).catchError((error) => print("Firebase add error: $error"));
  }

  void setScheduling() {
    Stream documentStream = FirebaseFirestore.instance
        .collection("schedule_list")
        .doc(widget.roomid)
        .snapshots();
    documentStream.listen((event) {
      //우선 초기화
      List<List<int>> resultMatrix = [];
      List<List<int>> resultInputMatrix = [];
      for (int r = 0; r < _rows; r++) {
        resultMatrix.add([]);
        resultInputMatrix.add([]);
        for (int c = 0; c < _cols; c++) {
          resultMatrix[r].add(0);
          resultInputMatrix[r].add(0);
        }
      }
      //그 다음에 event 읽기
      if (event.exists) {
        Map<String, dynamic> mapdata = event.data() as Map<String, dynamic>;
        mapdata.forEach((key, value) {
          if (key == "user:$userId") {
            List<List<int>> resMatrix =
                List_dynamic_to_Matrix(json.decode(value));
            resultInputMatrix = resMatrix;
          } else if (key.contains("user:")) {
            List<List<int>> resMatrix =
                List_dynamic_to_Matrix(json.decode(value));
            for (int r = 0; r < _rows; r++) {
              for (int c = 0; c < _cols; c++) {
                resultMatrix[r][c] += resMatrix[r][c];
              }
            }
          }
        });
        setState(() {
          inputTimeMatrix = resultInputMatrix;
          timeMatrix = resultMatrix;
        });
      } else {
        print("not yet...");
      }
    });
  }

  List<List<int>> List_dynamic_to_Matrix(List<dynamic> data) {
    List<List<int>> ret =
        data.map((innerList) => List<int>.from(innerList)).toList();
    return (ret);
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
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    ChatScreen(widget.roomid),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(-1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          }
        },
        child: GridView.builder(
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
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    _daysOfWeek[index - 1],
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              );
            } else if ((index) % (_cols) == 0) {
              // 첫 번째 열에 시간을 표시합니다.
              int rowIndex = (index - 1) ~/ (_cols);
              return Container(
                margin: const EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 204, 93, 93),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    _timesOfDay[rowIndex],
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              );
            } else {
              int userCnt = timeMatrix[r][c] + inputTimeMatrix[r][c];
              return GestureDetector(
                onTap: () => selectUpdate(r, c),
                child: inputTimeMatrix[r][c] == 1
                    ? MyScheduleContainer(userCnt)
                    : OtherScheduleContainer(userCnt),
              );
            }
          },
        ),
      ),
    );
  }
}

class OtherScheduleContainer extends StatelessWidget {
  late final int userCnt;
  OtherScheduleContainer(int uc, {super.key}) {
    userCnt = uc;
  }

  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: userCnt > 0
            ? Colors.green.withOpacity((userCnt / 10).toDouble())
            : Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.black.withOpacity(0.2)),
      ),
      child: Center(
        child: userCnt > 0
            ? Text(
                "Text($userCnt 명)",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            : null,
      ),
    );
  }
}

class MyScheduleContainer extends StatelessWidget {
  late final int userCnt;
  MyScheduleContainer(int uc, {super.key}) {
    userCnt = uc;
  }

  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: userCnt > 0
            ? Colors.purple.withOpacity((userCnt / 10).toDouble())
            : Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.black.withOpacity(0.2)),
      ),
      child: Center(
        child: userCnt > 0
            ? Text(
                "Text($userCnt 명)",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            : null,
      ),
    );
  }
}
