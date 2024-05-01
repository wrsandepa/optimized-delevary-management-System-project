import 'package:flutter/material.dart';

class Singupage extends StatelessWidget {
  const Singupage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      appBar: AppBar(
        title: const Text(
          'hello',
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('welocom! sing up to continue'),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text(
              'singup',
              style: TextStyle(color: Colors.blue, fontSize: 15),
            ),
          ),
        ]),
      ),
    );
  }
}
