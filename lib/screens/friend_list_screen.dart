import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:promise_schedule/widgets/profile_tile.dart';

class FriendListScreen extends StatefulWidget {
  const FriendListScreen({super.key});

  @override
  State<FriendListScreen> createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  String? currentUserId;
  User? currentUser; // 현재 로그인된 사용자
  final userAuthInfo = FirebaseAuth.instance;
  DocumentReference? docRef;
  List<dynamic>? friendList;
  Map<String, dynamic>? currentUserData;

  @override
  void initState() {
    super.initState();
    currentUser = userAuthInfo.currentUser;
    currentUserId = currentUser?.uid;
    if (currentUserId != null) {
      docRef =
          FirebaseFirestore.instance.collection("users").doc(currentUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (docRef == null) {
      return Center(child: Text('User not logged in'));
    }

    return FutureBuilder<DocumentSnapshot>(
      future: docRef!.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('No user data found'));
        }

        currentUserData = snapshot.data!.data() as Map<String, dynamic>;
        friendList = currentUserData!["friend_list"];

        if (friendList == null || friendList!.isEmpty) {
          return Center(child: Text('No friends found'));
        }

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where(FieldPath.documentId, whereIn: friendList)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No friends found'));
            }

            final friendData = snapshot.data!.docs.map((doc) {
              return {
                "id": doc.id,
                "username": doc['username'],
                "image_url": doc['image_url'],
              };
            }).toList();

            return ListView.builder(
              itemCount: friendData.length,
              itemBuilder: (context, index) {
                return ProfileTile(
                  userData: friendData[index],
                );
              },
            );
          },
        );
      },
    );
  }
}
