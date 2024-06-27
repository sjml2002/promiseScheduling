import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendAddTile extends StatelessWidget {
  const FriendAddTile(
      {super.key,
      required this.userData,
      required this.isFriend,
      required this.addFriend,
      required this.friendId});
  final Map userData;
  final bool isFriend;
  final String friendId;
  final void Function(String) addFriend;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userData['image_url']),
      ),
      title: Text(userData['username']),
      trailing: IconButton(
          onPressed: isFriend
              ? null
              : () {
                  addFriend(friendId);
                },
          icon: isFriend ? const Icon(Icons.check) : const Icon(Icons.add)),
    );
  }
}
