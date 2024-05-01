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
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('welocom! sing up to continue'),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/singup');
            },
            child: const Text(
              'backtosinup',
              style: TextStyle(color: Colors.blue, fontSize: 15),
            ),
          ),
        ]),
      ),
      backgroundColor: Colors.amber,
    );
  }
}
