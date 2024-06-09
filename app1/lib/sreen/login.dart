import 'package:app1/sreen/home.dart';
import 'package:app1/sreen/singup.dart';
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

  //login fucltion
  Future<User?> Singin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential us_cred = await auth.signInWithEmailAndPassword(
          email: _email.text, password: _password.text);
      user = us_cred.user;
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Homescreen()),
        );
      }
    } catch (e) {
      print("error!!!");
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'hello',
        ),
        backgroundColor: Colors.blue,
        actions: [
          ElevatedButton(
            onPressed: () {
              Singin();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 199, 208, 214)),
            child: const Text(
              'Singin!',
              style: TextStyle(color: Colors.blue, fontSize: 12),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            margin:
                const EdgeInsets.fromLTRB(1000 / 100, 5 / 100, 4, 18000 / 100),
            // color: Colors.red,
            child: const Text(
              'Login your account',
              style: TextStyle(
                  color: Colors.blue,
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
                    'email',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
              obscureText: false, // This will obscure the text with star marks
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
                      color: Colors.blue,
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
              obscureText: true, // This will obscure the text with star marks
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Singupage()),
              );
            },
            child: const Text(
              'already haven`t account',
              style: TextStyle(color: Colors.blue, fontSize: 15),
            ),
          ),
        ]),
      ),
      backgroundColor: Colors.white,
    );
  }
}
