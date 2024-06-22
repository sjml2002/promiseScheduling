import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker({super.key, required this.selectUserImage});

  void Function(File) selectUserImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);

    if (pickedImage == null) {
      return;
    } else {
      setState(() {
        _pickedImageFile = File(pickedImage.path);
      });

      widget.selectUserImage(_pickedImageFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
          backgroundColor: Colors.grey,
          radius: 40,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text("Add Image"),
        )
      ],
    );
  }
}
