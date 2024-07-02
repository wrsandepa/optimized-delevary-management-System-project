import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    super.key,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

final _formkey1 = GlobalKey<FormState>();

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

  Widget _buildSignupDrawer(BuildContext context) {
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
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Re type  password';
                      }
                      if (value != singuppass.text) {
                        return 'Does not match your password';
                      }
                    },
                    controller: comfirmsinguppass,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  // TextFormField(
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Re type  username';
                  //     }
                  //   },
                  //   controller: username,
                  //   decoration: const InputDecoration(
                  //     labelText: 'username',
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  // TextFormField(
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'confirm username';
                  //     }
                  //     if (value != username.text) {
                  //       return 'Does not match your usrname';
                  //     }
                  //   },
                  //   controller: comfirm_username,
                  //   decoration: const InputDecoration(
                  //     labelText: 'confirm username',
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: (value) {
                      if ((value == null || value.isEmpty) &&
                          value?.length != 10) {
                        return 'enter phone number';
                      }
                    },
                    controller: phone_num,
                    decoration: const InputDecoration(
                      labelText: 'phone number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'enter Address';
                      }
                    },
                    controller: addres,
                    decoration: const InputDecoration(
                      labelText: 'location address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    items: ['domex', 'pronto', 'transex'].map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedRole = newValue!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Name of the courier',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a role';
                      }
                      return null; // Return null if the input is valid
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectbranches,
                    items:
                        ['matara', 'akuressa', 'vavuniya'].map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectbranches = newValue!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'branch name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a role';
                      }
                      return null; // Return null if the input is valid
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print(selectedRole); //dropdown value
                      print(singupemail.text);
                      if (_formKey.currentState!.validate()) {
                        singup();
                        addCourierData(
                            selectedRole!,
                            selectedRole!,
                            singupemail.text,
                            selectbranches!,
                            phone_num.text,
                            addres.text); //String name,

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
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text('Oops Sumthing went Wrong!'),
                            duration: Duration(
                                seconds: 3), // Adjust the duration as needed
                            backgroundColor: Colors.red,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Form(
        key: _formkey1,
        child: Drawer(
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
                        controller: singinemail,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                        }),
                    const SizedBox(height: 16),
                    TextFormField(
                        controller: singinpass,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                        }),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formkey1.currentState!.validate()) {
                          Singin();
                          singinemail.clear();
                          singinpass.clear();
                          Navigator.pop(context);
                          //go to inside

                          if (user != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text('Succesfully!'),
                                duration: Duration(
                                    seconds:
                                        3), // Adjust the duration as needed
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text('Invalied email or password!'),
                                duration: Duration(
                                    seconds:
                                        3), // Adjust the duration as needed
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          ;
                        }
                        ;
                      },
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
final TextEditingController singinemail = TextEditingController();
final TextEditingController singinpass = TextEditingController();
final TextEditingController comfirmsinguppass = TextEditingController();
final TextEditingController username = TextEditingController();
final TextEditingController comfirm_username = TextEditingController();
final TextEditingController phone_num = TextEditingController();
final TextEditingController addres = TextEditingController();
final TextEditingController branches = TextEditingController();

final _formKey = GlobalKey<FormState>();
String? selectedRole;
String? selectbranches;
User? user;
//sing in function
Future<dynamic> singup() async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: singupemail.text, password: singuppass.text);
    print('hiii');
  } catch (e) {}
}

//sing in function
Future<User?> Singin() async {
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    UserCredential us_cred = await auth.signInWithEmailAndPassword(
        email: singinemail.text, password: singinpass.text);
    user = us_cred.user;
    if (user != null) {}
  } catch (e) {
    print("error!!!");
  }
  return user;
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

//function of add courier services data

Future<void> addCourierData(
  String courierServicesdocid,
  String name,
  String email,
  String locationAddress,
  String phoneNumber,
  String address,
) async {
  try {
    // Reference to the main collection
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('courierServices');

    // Check if the courier service document already exists
    DocumentSnapshot docSnapshot =
        await collectionRef.doc(courierServicesdocid).get();

    if (!docSnapshot.exists) {
      // Set the data for the courier service document if it does not exist
      await collectionRef.doc(courierServicesdocid).set({
        'name': name,
        'user_counter': 0,
      });
    }

    // Reference to the branches subcollection within the courier service document
    DocumentReference courierServiceDoc =
        collectionRef.doc(courierServicesdocid);
    CollectionReference branchesCollection =
        courierServiceDoc.collection('branches');

    // Add data to the branches subcollection with a new document ID
    await branchesCollection.add({
      'email_address': email,
      'location_address': locationAddress,
      'phone_number': phoneNumber,
      'address': address,
    });

    print('Courier service and branch data added successfully!');
  } catch (e) {
    print('Error adding courier service and branch data: $e');
    // Handle any errors here
  }
}
