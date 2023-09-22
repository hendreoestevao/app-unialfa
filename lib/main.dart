import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app_unialfa/screens/auth/login_screen.dart';
 import 'package:firebase_core/firebase_core.dart'; // 
 import 'firebase_options.dart'; // Generated file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
        title: 'UniAlfa',
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 1,
                iconTheme: IconThemeData(color: Colors.black),
                titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 19,
                    backgroundColor: Colors.white))),
        home: LoginScreen(),
        debugShowCheckedModeBanner: false);
  }
}

_initializeFirebase() async {
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
}
