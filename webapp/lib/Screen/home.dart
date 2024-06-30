import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    super.key,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  List<String> imageUrls = [
    'assets/3d-delivery-robot-working.jpg',
    'assets/deliver-man-holding-package.jpg',
    'assets/delivery-man-with-clipboard.jpg',
    'assets/delivery-men-loading-carboard-boxes-van-while-getting-ready-shipment.jpg',
  ];
  int currentImageIndex = 0;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Animation duration
    );

    _animation =
        Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
            .animate(_controller);

    // Start timer to change photo every 5 seconds
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        currentImageIndex = (currentImageIndex + 1) % imageUrls.length;
        _controller.forward(from: 0.0); // Start animation from beginning
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text(
                'Sign In',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Handle sign-in
                    },
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      endDrawer: _buildSignupDrawer(context),
      backgroundColor: Colors.black,
      body: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(80.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  //container with   contact us
                  Container(
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: NetworkImage(
                            'assets/ThunderDrop-text-Color-logo.png'),
                        fit: BoxFit.contain,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('HotLine ',
                            style: TextStyle(color: Colors.black)),
                        const Text('+94 779038886',
                            style: TextStyle(color: Colors.blue)),
                        TextButton(
                          onPressed: () {
                            _showContactDialog;
                          },
                          child: const Text(
                            'Contact Us',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: const Text(
                            'Home',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left Container with image
                        SlideTransition(
                          position: _animation,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    NetworkImage(imageUrls[currentImageIndex]),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width / 2 -
                                50, // Adjust for padding
                            margin: const EdgeInsets.all(10),
                          ),
                        ),

                        // Right Container with buttons
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width / 2 -
                              170, // Adjust for padding
                          margin: const EdgeInsets.all(20),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 300,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                          'assets/delivery-service-illustrated_23-2148505081.jpg'),
                                      fit: BoxFit.contain,
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      ' Welcome to TurboDrop !',
                                      style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.orangeAccent),
                                    )),
                                const Padding(
                                  padding: EdgeInsets.all(40),
                                  child: Text(
                                    'your premier destination for efficient courier services. We specialize in swift and reliable deliveries, ensuring your packages reach their destination promptly and securely. Explore our user-friendly platform to experience seamless booking, tracking, and management of your deliveries. Join thousands of satisfied customers who trust TurboDrop for their logistics needs',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        letterSpacing: 1.2),
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Scaffold.of(context).openDrawer();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orangeAccent,
                                        elevation:
                                            10, // Elevation (controls the "3D" effect)
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              0), // Button border radius
                                        ),
                                        padding: const EdgeInsets.all(
                                            20), // Padding around the button content
                                        // Add a gradient background
                                      ),
                                      child: const Text('GET START'),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Scaffold.of(context).openEndDrawer();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orangeAccent,
                                        elevation:
                                            10, // Elevation (controls the "3D" effect)
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              0), // Button border radius
                                        ),
                                        padding: const EdgeInsets.all(
                                            20), // Padding around the button content
                                        // Add a gradient background
                                      ),
                                      child: const Text('SIGNUP'),
                                    )
                                  ],
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

final TextEditingController singupemail = TextEditingController();
final TextEditingController singuppass = TextEditingController();
final _formKey = GlobalKey<FormState>();
Widget _buildSignupDrawer(BuildContext context) {
  Future<dynamic> singup() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: singupemail.text, password: singuppass.text);
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

  return Form(
    key: _formKey,
    child: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: Text(
              'Sign Up',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                  },
                  controller: singupemail,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                  },
                  controller: singuppass,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    print(singupemail.text);
                    if (_formKey.currentState!.validate()) {
                      singup();
                      singupemail.clear();
                      singuppass.clear();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('Succesfully Sing up!'),
                          duration: Duration(
                              seconds: 3), // Adjust the duration as needed
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
//singup funtion

/// display contactus button
void _showContactDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Contact Us'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('+94 779038886'),
              subtitle: Text('Call us for any inquiries.'),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('support@turbodrop.com'),
              subtitle: Text('Email us your questions.'),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('123 TurboDrop St.'),
              subtitle: Text('Colombo, Sri Lanka'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
