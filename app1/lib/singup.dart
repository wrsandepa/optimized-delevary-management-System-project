import 'package:flutter/material.dart';

class Singupage extends StatelessWidget {
  Singupage({super.key});
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawerEnableOpenDragGesture: false,
      appBar: AppBar(
        title: const Text(
          'hello',
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            margin: const EdgeInsets.fromLTRB(2.2, 5, 4, 15000 / 100),
            // color: Colors.red,
            child: const Text(
              'welocom! sing up to continue',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
          ),
          SizedBox(
            width: 400,
            child: TextFormField(
              controller: _username,
              decoration: InputDecoration(
                  label: const Text(
                    'Username',
                    style: TextStyle(color: Colors.blue),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 400,
            child: TextFormField(
              controller: _password, // Assign the controller
              decoration: InputDecoration(
                  label: const Text(
                    'password',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
              obscureText: true, // This will obscure the text with star marks
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 400,
            child: TextFormField(
              controller: _email,
              decoration: InputDecoration(
                  label: const Text(
                    'Email',
                    style: TextStyle(color: Colors.blue),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 400,
            child: TextFormField(
              controller: _name,
              decoration: InputDecoration(
                  label: const Text(
                    'Name',
                    style: TextStyle(color: Colors.blue),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              String username = _username.text;
              String name = _name.text;
              String password = _password.text;
              String email = _email.text;
              Navigator.pushNamed(context, '/login'); //navigater mark left top
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
