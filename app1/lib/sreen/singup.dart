import 'package:app1/sreen/home.dart';
import 'package:app1/sreen/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Singupage extends StatefulWidget {
  const Singupage({super.key});

  @override
  State<Singupage> createState() => _SingupageState();
}

class _SingupageState extends State<Singupage> {
  final TextEditingController _username = TextEditingController();

  final TextEditingController _password = TextEditingController();

  final TextEditingController _name = TextEditingController();

  final TextEditingController _email = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<dynamic> _singup() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text, password: _password.text);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Loging()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Oops Sumthing went Wrong!'),
          duration: Duration(seconds: 3), // Adjust the duration as needed
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Singup',
          ),
          backgroundColor: Colors.orange),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('assets1/annimation/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(2.2, 5, 4, 15000 / 100),
                      // color: Colors.red,
                      child: const Text(
                        'welcome! sing up to continue',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontStyle: FontStyle.italic),
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
                                color: Colors.white,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25))),
                        obscureText:
                            true, // This will obscure the text with star marks
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
                              style: TextStyle(color: Colors.white),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25))),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextButton(
                      onPressed: () {
                        if (_email.text.isNotEmpty &&
                            _password.text.isNotEmpty) {
                          if (_password.text.trim().length >= 8) {
                            _singup();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content:
                                    Text('Password Must be atleast 8 digit!'),
                                duration: Duration(
                                    seconds:
                                        3), // Adjust the duration as needed
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text('Invalied Entry!'),
                              duration: Duration(
                                  seconds: 3), // Adjust the duration as needed
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'singup',
                        style: TextStyle(color: Colors.blueGrey, fontSize: 15),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
