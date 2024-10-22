import 'package:app1/sreen/home.dart';
import 'package:app1/sreen/login.dart';
import 'package:app1/sreen/singup.dart';
import 'package:app1/sreen/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDcarz-F2x343DnkNOsamUU0tdrHm2nSfo",
          appId: "1:433967579812:android:44229e033b64c2a899dc31",
          messagingSenderId: "433967579812",
          storageBucket: 'gs://delevery-mangement-system.appspot.com',
          projectId: "delevery-mangement-system"));
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
