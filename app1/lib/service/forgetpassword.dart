import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> sendPasswordResetEmail(String email, BuildContext context) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 4),
        content: Text('Password reset email sent. Please check your inbox.'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    print("Error sending password reset email: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error sending password reset email. Please try again.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
