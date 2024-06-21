import 'package:flutter/material.dart';
import './chatting_room_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ScheduleScreenState createState() => ScheduleScreenState();
}

class ScheduleScreenState extends State<ScheduleScreen> {
  double rectSize = 20;
  static const int _rows = 25;
  static const int _cols = 8;

  List<List<bool>> timeMatrix = List.generate(_rows, (index) => List.generate(_cols, (index) => false));
  final List<String> _daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> _timesOfDay = [
    '12 AM', '1 AM', '2 AM', '3 AM', '4 AM', '5 AM', '6 AM', '7 AM', '8 AM', '9 AM', '10 AM', '11 AM',
    '12 PM', '1 PM', '2 PM', '3 PM', '4 PM', '5 PM', '6 PM', '7 PM', '8 PM', '9 PM', '10 PM', '11 PM'
  ];


  @override
  void initState() {
    //todo
  }

  void selectUpdate(int r, int c) {
    setState(() {
      timeMatrix[r][c] = !timeMatrix[r][c];
    });
  }

  void _passTimeMatrix() {
    print(timeMatrix);
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
            onHorizontalDragEnd: (details){
              if (details.primaryVelocity! > 0){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ChatScreen('roomid'), //id issue
                    ),
                );
              }
            },
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _cols,
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
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: () => selectUpdate(r, c),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width:0.2),
                      color: timeMatrix[r][c] ? Colors.green : Colors.white,
                    ),
                    height: 20,
                  )
                );
              }
            },
            
          ),
        ));
  }
}


