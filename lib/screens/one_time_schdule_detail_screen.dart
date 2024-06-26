import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:promise_schedule/screens/chatting_room_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class OneTimeScheduleScreen extends StatefulWidget {
  late final String roomid;
  OneTimeScheduleScreen(String id, {super.key}) {
    roomid = id;
  }

  @override
  _OneTimeScheduleScreenState createState() => _OneTimeScheduleScreenState();
}

class _OneTimeScheduleScreenState extends State<OneTimeScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late String _weeks;

  String userId = FirebaseAuth.instance.currentUser!.uid;
  static const int _rows = 24;
  static const int _cols = 8;

  List<List<int>> timeMatrix =
      List.generate(_rows, (index) => List.generate(_cols, (index) => 0));
  List<List<int>> inputTimeMatrix =
      List.generate(_rows, (index) => List.generate(_cols, (index) => 0));

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

////////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _weeks = _focusedWeeksChangedFormat();
    searchScheduleData_onWeeks();
  }

  String _focusedWeeksChangedFormat() {
    DateTime firstDay =
        _focusedDay.subtract(Duration(days: _focusedDay.weekday));
    DateTime lastDay = firstDay.add(const Duration(days: 6));
    String ret =
        "${DateFormat("yyyy-MM-dd").format(firstDay)}~${DateFormat("yyyy-MM-dd").format(lastDay)}";
    return (ret);
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

  void _calendarPageChanged(DateTime focusedDay) {
    //Firebase Search 후 데이터 받아오기
    _weeks = _focusedWeeksChangedFormat();
    searchScheduleData_onWeeks(); //timeMatrix data 업데이트
  }

  void _passTimeMatrix() {
    //FireStore insert
    CollectionReference scheduleListCollection = FirebaseFirestore.instance
        .collection('one_time_schedule_list')
        .doc(widget.roomid)
        .collection('weeks');
    scheduleListCollection
        .doc(_weeks)
        .set({
          'user:$userId': json.encode(inputTimeMatrix),
        }, SetOptions(merge: true)) //기존 필드값은 건들이지 않도록
        .then((value) {})
        .catchError((error) => print("Firebase add error: $error"));
  }

  //실제로 화면상에 보이는 schedule data를 업데이트 함
  void searchScheduleData_onWeeks() {
    Stream documentStream = FirebaseFirestore.instance
        .collection("one_time_schedule_list")
        .doc(widget.roomid)
        .collection('weeks')
        .doc(_weeks)
        .snapshots();
    documentStream.listen((event) {
      //일단 초기화
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
      //그 다음 event 읽기
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
      } else {
        print("not yet...");
      }
      //받은 값으로 업데이트
      setState(() {
        inputTimeMatrix = resultInputMatrix;
        timeMatrix = resultMatrix;
      });
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
      body: Column(children: [
        Expanded(
            flex: 1,
            child: Row(children: [
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 7,
                  child: PageView(
                    children: [
                      TableCalendar(
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                        ),
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay =
                                focusedDay; // update `_focusedDay` here as well
                          });
                        },
                        onPageChanged: (focusedDay) {
                          //timeMatrix를 전부 다 초기화한 후 새로운 시간 데이터 가져오기
                          //inputTimeMatrix는 초기화 할까?
                          setState(() {
                            _focusedDay = focusedDay;
                            _calendarPageChanged(focusedDay);
                          });
                        },
                      ),
                      // 페이지 뷰의 두 번째 페이지에 다른 화면을 추가할 수 있습니다.
                      Center(child: Text('다른 페이지'))
                    ],
                  ),
                )
              ]),
            ),
        Expanded(
          flex: 5,
          child: GestureDetector(
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
              shrinkWrap: true,
              itemCount: _rows * _cols,
              itemBuilder: (context, index) {
                int r = index ~/ _cols;
                int c = index % _cols;
                if ((index) % (_cols) == 0) {
                  // 첫 번째 열에 시간 표시
                  int rowIndex = (index) ~/ (_cols);
                  return Container(
                    margin: const EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 204, 93, 93),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        _timesOfDay[rowIndex],
                        style: const TextStyle(
                            fontSize: 14,
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
        ),
      ]),
    );
  }
}

////////////////// 시간 선택하는 input Container //////////////
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
                "$userCnt 명",
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
                "$userCnt 명",
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
