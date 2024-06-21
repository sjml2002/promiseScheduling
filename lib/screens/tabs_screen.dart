import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:promise_schedule/screens/calendar_screen.dart';
import 'package:promise_schedule/screens/chatting_list_screen.dart';
import 'package:promise_schedule/screens/profile_screen.dart';
import 'package:promise_schedule/screens/schedule_list_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  final List<Widget> _pages = [
    ScheduleListScreen(),
    ChatListScreen(),
    CalendarScreen(),
    UserConfigScreen(),
  ];

  final List<AppBar> _appBars = [
    AppBar(
      title: Text("언제 만나"),
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
    ),
    AppBar(
      title: Text("달력"),
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
    ),
    AppBar(
      title: Text("채팅 목록"),
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
    ),
    AppBar(
      title: Text("친구 목록"),
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
    )
  ];

  final List<String> _appBarTitles = [
    '약속 목록',
    '채팅 목록',
    '달력',
    '내 정보',
  ];

  final List<IconData> _floatingButtonIcons = [
    Icons.list_outlined,
    Icons.chat,
    Icons.event,
    Icons.settings,
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _showModal(BuildContext context) {
    TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('제목 입력'),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: '제목',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 창 닫기
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                // 입력한 제목을 저장하거나 사용할 로직 추가
                print('입력한 제목: ${titleController.text}');
                Navigator.of(context).pop(); // 모달 창 닫기
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBars[_selectedPageIndex],
      body: SafeArea(
        child: _pages[_selectedPageIndex],
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          _showModal(context);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: _floatingButtonIcons,
        activeIndex: _selectedPageIndex,
        notchMargin: 0,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.sharpEdge,
        onTap: _selectPage,
        backgroundColor: Colors.blueAccent,
        activeColor: Colors.white,
        inactiveColor: Colors.white70,
      ),
    );
  }
}
