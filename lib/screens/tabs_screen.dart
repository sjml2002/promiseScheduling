import 'dart:convert';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:promise_schedule/DTO/chat_room.dart';
import 'package:promise_schedule/screens/calendar_screen.dart';
import 'package:promise_schedule/screens/chatting_list_screen.dart';
import 'package:promise_schedule/screens/friend_list_screen.dart';
import 'package:promise_schedule/screens/profile_screen.dart';
import 'package:promise_schedule/screens/schedule_list_screen.dart';
import 'package:promise_schedule/widgets/friend_add_top_modal.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';

class TabsScreen extends StatefulWidget {
  late Future<List<ChatRoom>> userRoomList;
  TabsScreen(Future<List<ChatRoom>> roomlist, {super.key}) {
    userRoomList = roomlist;
  }

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  //late var userRoomList = widget.userRoomList;
  int _selectedPageIndex = 0;

  late final List<Widget> _pages = [
    ScheduleListScreen(widget.userRoomList),
    ChatListScreen(widget.userRoomList), //userRoomList
    CalendarScreen(),
    FriendListScreen(),
  ];

  AppBar _buildAppBar(BuildContext context) {
    switch (_selectedPageIndex) {
      case 0:
        return AppBar(
          title: Text("언제 만나"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings),
            ),
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.exit_to_app),
            ),
          ],
        );
      case 1:
        return AppBar(
          title: Text("달력"),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
        );
      case 2:
        return AppBar(
          title: Text("채팅 목록"),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
        );
      case 3:
        return AppBar(
          title: Text("친구 목록"),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
            IconButton(
                onPressed: () async {
                  _showTopSheet(context); // 친구 추가 버튼을 눌렀을 때 호출
                },
                icon: Icon(Icons.person_add_alt_rounded)),
          ],
        );
      default:
        return AppBar(title: Text("언제 만나"));
    }
  }

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
    Icons.people,
  ];

  void _selectPage(int index) async {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _showTopSheet(BuildContext context) async {
    await showTopModalSheet(context, FriendAddSheet());
  }

///////////////// 방 만들기 ////////////
  void _createRoomWithModal(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const createRoom();
        });
  }

////////////// Widget build  //////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: _pages[_selectedPageIndex],
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          _createRoomWithModal(context);
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

////////// 방 만들기 ///////////

class createRoom extends StatefulWidget {
  const createRoom({super.key});

  @override
  _createRoomState createState() => _createRoomState();
}

class _createRoomState extends State<createRoom> {
  List<String> selectedUsers = [];
  List<String> foundUsers = [];
  String searchUserEmail = '';
  String modeOption = "정기모임";
  String roomname = '';

  Future<void> searchUser(String userEmail) async {
    foundUsers = []; //초기화

    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get()
        .then((usrData) {
      if (usrData.docs.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('User not found')));
      } else {
        //email은 무조건 한명 이므로 forEach 할 필요 없음
        setState(() => foundUsers.add(userEmail));
        print("user found!!!"); //debug
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Something Error'),
      ));
    });
  }

  Future<void> _createRoomOnFireStore() async {
    if (roomname == '') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('방 제목을 입력하세요.'),
      ));
      return;
    }
    if (selectedUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('한 명 이상의 친구를 초대하세요'),
      ));
      return;
    }
    //roomid 자동 지정
    FirebaseFirestore.instance
        .collection('rooms')
        .add({
          'roomname': roomname,
          'users': selectedUsers,
          'mode': modeOption,
        })
        .then((value) => print(value))
        .catchError((error) => print("create Room Error! $error"));

    // FirebaseFirestore.instance.collection("chat_rooms").
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('약속의 옵션'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: '방 이름',
                ),
                onChanged: (value) {
                  roomname = value;
                },
              ),
            ),
            const SizedBox(height: 20),
            RadioListTile<String>(
              title: const Text('정기모임'),
              value: "정기모임",
              groupValue: modeOption,
              onChanged: (value) {
                setState(() {
                  modeOption = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('일회성만남'),
              value: "일회성만남",
              groupValue: modeOption,
              onChanged: (value) {
                setState(() {
                  modeOption = value!;
                });
              },
            ),
            Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter user email to search',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => searchUser(searchUserEmail),
                    ),
                  ),
                  onChanged: (value) {
                    searchUserEmail = value;
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  width: 300,
                  height: 100,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: foundUsers.length,
                    itemBuilder: (context, index) {
                      String email = foundUsers[index];
                      bool isSelected = selectedUsers.contains(email);
                      return ListTile(
                        title: Text(email),
                        trailing: IconButton(
                          icon: Icon(
                            isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                          ),
                          onPressed: () {
                            setState(() {
                              if (isSelected) {
                                selectedUsers.remove(email);
                              } else {
                                selectedUsers.add(email);
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                  child: Text("초대된 사람들"),
                ),
                Container(
                  width: 300,
                  height: 400,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: selectedUsers.length,
                    itemBuilder: (context, index) {
                      String email = selectedUsers[index];
                      bool isSelected = selectedUsers.contains(email);
                      return ListTile(
                        title: Text(email),
                        trailing: IconButton(
                          icon: Icon(
                            isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                          ),
                          onPressed: () {
                            setState(() {
                              if (isSelected) {
                                selectedUsers.remove(email);
                              } else {
                                selectedUsers.add(email);
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        if (selectedUsers.isNotEmpty)
          ElevatedButton(
            onPressed: () {
              _createRoomOnFireStore();
              Navigator.of(context).pop();
            },
            child: const Text('방 만들기'),
          ),
      ],
    );
  }
}
