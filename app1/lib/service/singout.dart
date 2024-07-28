// auth_service.dart
import 'package:app1/sreen/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const Loging()), // Adjust this if your login screen path is different
    );
  } catch (e) {
    print("Error signing out: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error signing out. Please try again.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
