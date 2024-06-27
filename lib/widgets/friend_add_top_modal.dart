import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:promise_schedule/screens/friend_list_screen.dart';
import 'package:promise_schedule/widgets/friend_add_tile.dart';
import 'package:promise_schedule/widgets/profile_tile.dart';

class FriendAddSheet extends StatefulWidget {
  @override
  State<FriendAddSheet> createState() => _FriendAddSheetState();
}

class _FriendAddSheetState extends State<FriendAddSheet> {
  final _emailController = TextEditingController();
  final userAuthInfo = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  void addFriend(String newFriendId) async {
    final docRef = db.collection("users").doc(currentUserId);
    final friendRef = db.collection("users").doc(newFriendId);
    await docRef.update({
      'friend_list': FieldValue.arrayUnion([newFriendId])
    });

    await friendRef.update({
      'friend_list': FieldValue.arrayUnion([currentUserId])
    });

    setState(() {
      currentUserFriendList!.add(newFriendId);
      isFriend = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool validate = false;
  bool found = false;
  bool isFriend = false;

  Map<String, dynamic>? resultData;
  List<dynamic>? currentUserFriendList;
  String? resultId;

  String? searchEmail;
  String? currentUserId;
  User? currentUser; // 현재 로그인된 아이디

  @override
  Widget build(BuildContext context) {
    currentUser = userAuthInfo.currentUser;
    currentUserId = currentUser!.uid;
    final docRef = db.collection("users").doc(currentUserId);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final currentUserData = doc!.data() as Map<String, dynamic>;
        currentUserFriendList = currentUserData["friend_list"];
      },
      onError: (e) => print("Error getting document: $e"),
    );

    return Container(
      height: 200,
      padding: EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '친구 추가',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter the User's Email",
                      errorText: validate ? "Value Can't be Empty" : null),
                ),
              ),
              IconButton.filled(
                onPressed: () {
                  setState(() {
                    validate = _emailController.text.isEmpty;
                  });

                  if (!validate) {
                    // print(_emailController.text);
                    searchEmail = _emailController.text;

                    final query = db
                        .collection("users")
                        .where("email", isEqualTo: _emailController.text);
                    query.get().then(
                      (value) {
                        if (value.docs.isEmpty ||
                            value.docs[0].id == currentUserId) {
                          setState(() {
                            found = false;
                          });
                        } else {
                          resultData = value.docs[0].data();
                          resultId = value.docs[0].id;
                          // If result Id in friend list, set isFriend = true
                          setState(() {
                            isFriend =
                                currentUserFriendList!.contains(resultId);
                            found = true;
                          });
                        }
                      },
                    );
                  }
                },
                icon: Icon(Icons.search),
              )
            ],
          ),
          found
              ? FriendAddTile(
                  userData: resultData!,
                  isFriend: isFriend,
                  addFriend: addFriend,
                  friendId: resultId!)
              : Text("No User found")
        ],
      ),
    );
  }
}
