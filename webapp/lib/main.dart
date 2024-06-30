import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:webapp/Screen/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyD_3pg2-1vhda6-8Bo-Gt6CxgDbJoB75hk",
          appId: "1:433967579812:web:8748011e5436b03e99dc31",
          messagingSenderId: "433967579812",
          projectId: "delevery-mangement-system"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}
