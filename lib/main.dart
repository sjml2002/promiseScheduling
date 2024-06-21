import 'package:flutter/material.dart';
import 'package:promise_schedule/screens/chatting_room_screen.dart';
import 'package:promise_schedule/screens/login_screen.dart';
import 'package:promise_schedule/screens/schedule_list_screen.dart';
import 'package:promise_schedule/screens/tabs_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _fireBase = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await _fireBase.signInWithEmailAndPassword(
  //     email: "jason808@naver.com", password: "password");

  // Stream loginStream = FirebaseAuth.instance.authStateChanges();
  // if(login)

  runApp(const MainScreen());
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: TabsScreen(),
    );
    // home: const TabsScreen(),
    // home: LoginScreen());
  }
}
