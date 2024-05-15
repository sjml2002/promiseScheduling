import 'package:flutter/material.dart';
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

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = ScheduleListScreen();

    switch (_selectedPageIndex) {
      case 0: // 스케줄 목록
        activePage = ScheduleListScreen();
        break;
      case 1: // 채팅창 목록
        activePage = ChatListScreen();
        break;
      case 2: // 사용자 설정
        activePage = UserConfigScreen();
        break;
      default:
    }

    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: '약속 목록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '채팅 목록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts_outlined),
            label: '내 정보',
          ),
        ],
      ),
    );
  }
}
