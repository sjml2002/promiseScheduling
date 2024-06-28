import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:promise_schedule/DTO/GlobalVariable.dart';
import 'package:provider/provider.dart';
import 'package:promise_schedule/DTO/chat_room.dart';
import 'package:promise_schedule/screens/login_screen.dart';
import 'package:promise_schedule/screens/tabs_screen.dart';
import 'firebase_options.dart';
import 'package:promise_schedule/DTO/GlobalVariable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoomListProvider()),
      ],
      child: MainApp(),
    ),);
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            //로그인 성공
            return TabsScreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 63, 17, 177),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
