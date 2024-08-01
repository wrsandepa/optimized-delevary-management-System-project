import 'package:app1/service/forgetpassword.dart';
import 'package:app1/sreen/home.dart';
import 'package:app1/sreen/singup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loging extends StatefulWidget {
  const Loging({super.key});

  @override
  State<Loging> createState() => _LogingState();
}

class _LogingState extends State<Loging> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController username_log = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final forgetpassword_bottom_sheet = GlobalKey<FormState>();

  //login function
  Future<User?> Singin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential us_cred = await auth.signInWithEmailAndPassword(
          email: _email.text, password: _password.text);
      user = us_cred.user;
      if (user != null) {
        String? userenaming = await isuserexist(user);
        if (userenaming == username_log.text.trim()) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Homescreen(user1: user)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Sign-in failed. Please try again.'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Incorrect username or password'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
    return user;
  }

  // Check if the username exists in the userapp collection
  Future<String?> isuserexist(User user) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('userapp').doc(user.uid);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      if (userDocSnapshot.exists) {
        var data = userDocSnapshot.data() as Map<String, dynamic>;
        String confirmationStatus = data['username'];
        return confirmationStatus;
      }
    } catch (e) {
      print('$e');
    }

    return null;
  }

  void _showForgotPasswordBottomSheet() {
    final TextEditingController _forgotPasswordEmailController =
        TextEditingController();

    showModalBottomSheet(
      backgroundColor: Colors.orange,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: forgetpassword_bottom_sheet,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Forgot Password',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _forgotPasswordEmailController,
                  decoration: InputDecoration(
                    labelText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (forgetpassword_bottom_sheet.currentState!.validate()) {
                      String email = _forgotPasswordEmailController.text.trim();

                      await sendPasswordResetEmail(email, context);
                      Navigator.of(context)
                          .pop(); // Close the bottom sheet after sending the email
                    } else {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your email.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('hello'),
          backgroundColor: Colors.orange,
          actions: [
            TextButton(
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  Singin();
                }
              },
              child: const Text(
                'Signin',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            )
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(45),
            child: Form(
              key: _formkey,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade100, Colors.orange.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 5, 4, 180),
                          child: const Text(
                            'Login your account',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 20,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        SizedBox(
                          width: 400,
                          child: TextFormField(
                            controller: _email,
                            decoration: InputDecoration(
                                label: const Text(
                                  'Email',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25))),
                            obscureText:
                                false, // This will not obscure the text
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 400,
                          child: TextFormField(
                            controller: _password,
                            decoration: InputDecoration(
                                label: const Text(
                                  'Password',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25))),
                            obscureText: true, // This will obscure the text
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 400,
                          child: TextFormField(
                            controller: username_log,
                            decoration: InputDecoration(
                                label: const Text(
                                  'Username',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25))),
                            obscureText:
                                false, // This will not obscure the text
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 50),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Singupage()),
                            );
                          },
                          child: const Text(
                            'Don\'t have an account?',
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextButton(
                          onPressed: () {
                            _showForgotPasswordBottomSheet();
                          },
                          child: const Text(
                            'Forgot password?',
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 14),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
