import 'package:flutter/material.dart';
import 'package:promise_schedule/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    // 더미 데이터 생성
    const loadedMessages = [
      {
        'userId': 'user1',
        'userImage': 'https://example.com/user1.png',
        'username': 'User One',
        'text': 'Hello there!',
      },
      {
        'userId': 'user2',
        'userImage': 'https://example.com/user2.png',
        'username': 'User Two',
        'text': 'Hi! How are you?',
      },
      {
        'userId': 'user1',
        'userImage': 'https://example.com/user1.png',
        'username': 'User One',
        'text': 'I am good, thanks!',
      },
    ];

    // 사용자 인증 정보 더미 데이터 (실제로는 인증 로직에서 가져와야 함)
    const authenticatedUser = {
      'uid': 'user1', // 예시 사용자 ID
    };

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
  }
}
