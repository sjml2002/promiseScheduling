import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:promise_schedule/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  ChatMessages({super.key, required this.chatRoomId});
// 사용자 인증 정보 더미 데이터 (실제로는 인증 로직에서 가져와야 함)
  Map authenticatedUser = {
    'uid': FirebaseAuth.instance.currentUser!.uid, // 예시 사용자 ID
  };
  String? chatRoomId;

  @override
  Widget build(BuildContext context) {
    // 더미 데이터 생성
    // const loadedMessages = [
    //   {
    //     'userId': 'user1',
    //     'userImage': 'https://example.com/user1.png',
    //     'username': 'User One',
    //     'text': 'Hello there!',
    //   },
    //   {
    //     'userId': 'user2',
    //     'userImage': 'https://example.com/user2.png',
    //     'username': 'User Two',
    //     'text': 'Hi! How are you?',
    //   },
    //   {
    //     'userId': 'user1',
    //     'userImage': 'https://example.com/user1.png',
    //     'username': 'User One',
    //     'text': 'I am good, thanks!',
    //   },
    // ];

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('rooms')
            .doc(chatRoomId)
            .collection("chat_room")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Message Found"),
            );
          }

          final loadedMessages = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(
              bottom: 40,
              left: 13,
              right: 13,
            ),
            reverse: true,
            itemCount: loadedMessages.length,
            itemBuilder: (ctx, index) {
              final chatMessage = loadedMessages[index];
              final nextChatMessage = index + 1 < loadedMessages.length
                  ? loadedMessages[index + 1]
                  : null;

              final currentMessageUserId = chatMessage['userId'];
              final nextMessageUserId =
                  nextChatMessage != null ? nextChatMessage['userId'] : null;
              final nextUserIsSame = nextMessageUserId == currentMessageUserId;

              if (nextUserIsSame) {
                return MessageBubble.next(
                  message: chatMessage['text']!,
                  isMe: authenticatedUser['uid'] == currentMessageUserId,
                );
              } else {
                return MessageBubble.first(
                  userImage: chatMessage['userImage'],
                  username: chatMessage['username'],
                  message: chatMessage['text']!,
                  isMe: authenticatedUser['uid'] == currentMessageUserId,
                );
              }
            },
          );
        });
  }
}
