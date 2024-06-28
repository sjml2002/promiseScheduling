import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewMessage extends StatefulWidget {
  NewMessage({super.key, required this.roomId});
  String? roomId;
  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  var _messageController = TextEditingController();

  final db = FirebaseFirestore.instance;

  String? userId = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic>? userData;
  CollectionReference? chatRoomRef;
  DocumentReference? userRef;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userRef = db.collection("users").doc(userId);

    userRef!
        .get()
        .then((value) => userData = value.data() as Map<String, dynamic>);
    // print(userData);
    // print("뿡!");
    // print(userData);

    chatRoomRef =
        db.collection("rooms").doc(widget.roomId).collection("chat_room");
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() {
    if (_messageController.text.trim().isEmpty) return;
    chatRoomRef!.add({
      "text": _messageController.text,
      "createdAt": Timestamp.now(),
      "userId": userId,
      "username": userData!["username"],
      "userImage": userData!["image_url"]
    });
    _messageController.clear();

    FocusScope.of(context).unfocus();

    // Get User information
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
            ),
          ),
          IconButton(
            onPressed: _submitMessage,
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
