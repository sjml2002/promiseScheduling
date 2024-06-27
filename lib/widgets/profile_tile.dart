import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({super.key, required this.userData});
  final Map userData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userData['image_url']),
      ),
      title: Text(userData['username']),
      onTap: () {
        // 사용자 프로필 페이지로 이동 등의 추가 기능을 구현할 수 있습니다.
      },
    );
  }
}
