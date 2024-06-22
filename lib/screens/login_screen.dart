import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import "package:firebase_auth/firebase_auth.dart";
import 'package:path_provider/path_provider.dart';
import 'package:promise_schedule/screens/user_image_picker.dart';
import 'package:uri_to_file/uri_to_file.dart';

final _fireBase = FirebaseAuth.instance;

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.create(recursive: true);
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  bool _loginMode = true;

  final _formKey = GlobalKey<FormState>();

  String _enteredEmail = '';
  String _enteredPassword = '';
  String _enteredUsername = '';

  File? _selectedImage;
  bool? _isAuthenticating;

  void _selectUserImage(File imageFile) {
    _selectedImage = imageFile;
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();

      try {
        if (_loginMode == true) {
          final userCredential = await _fireBase.signInWithEmailAndPassword(
              email: _enteredEmail, password: _enteredPassword);
        } else {
          if (_selectedImage == null) {
            _selectedImage = await getImageFileFromAssets(
                "images/schedule_preview_sample.jpg");
          }

          setState(() {
            _isAuthenticating = true;
          });

          final userCredential = await _fireBase.createUserWithEmailAndPassword(
              email: _enteredEmail, password: _enteredPassword);

          final storageRef = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child('${userCredential.user!.uid}.jpg');

          await storageRef.putFile(_selectedImage!);
          final imageUrl = await storageRef.getDownloadURL();

          FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'username': _enteredUsername,
            'email': _enteredEmail,
            'image_url': imageUrl
          });

          setState(() {
            _isAuthenticating = false;
          });
        }
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication failed.'),
          ),
        );

        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  void initState() {
    _loginMode = true;
    _isAuthenticating = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                width: 200,
                child: Image.asset("assets/images/schedule_preview_sample.jpg"),
              ),
              Form(
                  key: _formKey,
                  child: Card(
                    margin: const EdgeInsets.only(
                        top: 15, left: 20, right: 20, bottom: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          if (!_loginMode)
                            UserImagePicker(selectUserImage: _selectUserImage),
                          if (!_loginMode)
                            TextFormField(
                              decoration: InputDecoration(
                                label: const Text("Username"),
                                labelStyle:
                                    const TextStyle().copyWith(fontSize: 15),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                              ),
                              keyboardType: TextInputType.text,
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null || value.trim().length < 5) {
                                  return "Username should be at least 5 characters";
                                }
                              },
                              onSaved: (newValue) {
                                _enteredUsername = newValue!;
                              },
                            ),
                          TextFormField(
                            decoration: InputDecoration(
                              label: const Text("Email"),
                              labelStyle:
                                  const TextStyle().copyWith(fontSize: 15),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            enableSuggestions: false,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return "Please enter a vaild email address";
                              }
                            },
                            onSaved: (newValue) {
                              _enteredEmail = newValue!;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                label: const Text("Password"),
                                labelStyle:
                                    const TextStyle().copyWith(fontSize: 15),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5)),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return "Password should be at least 6 characters";
                              }
                            },
                            onSaved: (newValue) {
                              _enteredPassword = newValue!;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          _isAuthenticating!
                              ? const CircularProgressIndicator()
                              : FilledButton(
                                  onPressed: () {
                                    _submit();
                                  },
                                  child: Text(_loginMode ? "Login" : "Sign up"),
                                ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _loginMode = !_loginMode;
                              });
                            },
                            child: Text(_loginMode
                                ? "Create an account"
                                : "Already have an Account"),
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
