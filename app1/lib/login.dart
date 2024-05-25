import 'package:flutter/material.dart';

class Loging extends StatelessWidget {
  const Loging({super.key});

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
              Navigator.pushNamed(context, '/singup');
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
              decoration: InputDecoration(
                  label: const Text(
                    'Username',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
              obscureText: true, // This will obscure the text with star marks
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 400,
            child: TextFormField(
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
              Navigator.pushNamed(context, '/singup');
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
