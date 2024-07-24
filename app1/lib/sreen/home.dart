import 'dart:io' show Platform, File; // Import 'dart:io' safely

import 'package:app1/service/display_efficiancy_curior.dart';
import 'package:app1/sreen/ratingwindow.dart';
import 'package:app1/sreen/tracking.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class Homescreen extends StatefulWidget {
  final dynamic user1;
  const Homescreen({super.key, required this.user1});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

final TextEditingController _confirmok = TextEditingController();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldState> _enddrawerkey = GlobalKey<ScaffoldState>();
XFile? _imageFile; // To store the selected image file

class _HomescreenState extends State<Homescreen> {
  late dynamic user1;
  final ImagePicker _imagePicker = ImagePicker();
  String? _downloadURL;
  String? _imageUrl; // To store the download URL
  String? _userN; // To store the user username
  String? _email; // To store the email

  Future<void> _pickImage() async {
    try {
      XFile? pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        if (kIsWeb) {
          await _uploadImageWeb(pickedFile);
        } else {
          await _uploadImageMobile(File(pickedFile.path));
        }
        _fetchUserData();
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _uploadImageMobile(File image) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      UploadTask uploadTask = storageRef.putFile(image);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        _downloadURL = downloadURL;
      }); // Update Firestore with the new image URL
      await FirebaseFirestore.instance
          .collection('userapp')
          .doc(user1.uid)
          .update({"imageurl": _downloadURL});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Upload successful.'),
          backgroundColor: Colors.green,
        ),
      );
      print('File uploaded successfully. Download URL: $downloadURL');
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _uploadImageWeb(XFile image) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      UploadTask uploadTask = storageRef.putData(await image.readAsBytes());

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        _downloadURL = downloadURL;
      }); // Update Firestore with the new image URL
      await FirebaseFirestore.instance
          .collection('userapp')
          .doc(user1.uid)
          .update({"imageurl": _downloadURL});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Upload successful.'),
          backgroundColor: Colors.green,
        ),
      );
      print('File uploaded successfully. Download URL: $downloadURL');
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('userapp')
          .doc(user1.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          _imageUrl = userDoc['imageurl'];
          _userN = userDoc['username'];
          _email = userDoc['email'];
        });
      }
      print('_fetchUserData is: ${_imageUrl}');
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> updateParcelConfirmation(String parcelId) async {
    try {
      DocumentReference parcelRef =
          FirebaseFirestore.instance.collection('parcels').doc(parcelId);
      DocumentSnapshot snapshot = await parcelRef.get();
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        if (data['confirmation'] != 'delivered') {
          await parcelRef.update({
            'confirmation': 'delivered',
            'confirmationTime': FieldValue.serverTimestamp()
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Parcel marked as delivered.'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Rating_w(
                        parcelId_pass: _confirmok.text,
                      )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Parcel already marked as delivered.'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Failed to update parcel confirmation.'),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.red,
          ),
        );
        print('error!!!!!!!!!!!!');
      }
    } catch (e) {
      print('$e');
    }
  }

  @override
  void initState() {
    super.initState();
    user1 = widget.user1;
    _fetchUserData();
  }

  Widget _enddrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const CircleAvatar(
                  radius: 30.0,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: const CircleAvatar(
                      radius: 12,
                      child: Icon(Icons.add_a_photo),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Handle settings tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Handle logout tap
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Menu'),
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.account_circle),
            iconSize: 35,
          )
        ],
        backgroundColor: Colors.orange,
      ),
      bottomNavigationBar: const BottomAppBar(
        height: 60,
        color: Colors.orange,
      ),
      endDrawer: _enddrawer(context), // Set the end drawer here
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.amberAccent),
              accountName: Text('$_userN',
                  style: const TextStyle(
                      color: Colors.black)), // Replace with actual user name
              accountEmail: Text('$_email',
                  style: const TextStyle(
                      color: Colors.black)), // Replace with actual user email
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: _imageUrl != null
                    ? ClipOval(
                        child: Image.network(
                          _imageUrl!, // Use _imageUrl here
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading image: $error');
                            print('Stack trace: $stackTrace');
                            return const Icon(
                              Icons.error,
                              size: 50,
                              color: Colors.red,
                            );
                          },
                        ),
                      )
                    : const Text(
                        "U", // Display the first letter of the user name
                        style: TextStyle(fontSize: 40.0),
                      ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Handle settings tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Handle logout tap
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 50),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Trackingmyparcel()),
                    )
                  },
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 255, 191, 0),
                            Colors.amberAccent
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ), // Setting the background color using decoration
                        borderRadius: BorderRadius.circular(20.0)),
                    child: const Center(
                      child: Text(
                        "TRACKING",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Display_curior_ser()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 100.0,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 255, 191, 0),
                            Colors.amberAccent
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ), // Setting the background color using decoration
                        borderRadius: BorderRadius.circular(20.0)),
                    child: const Center(
                      child: Text(
                        "ADD PARCEL",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.amber,
                          title: const Text('Tracking number'),
                          content: TextFormField(
                            controller: _confirmok,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                if (_confirmok.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                        'Failed to update parcel confirmation.'),
                                    duration: Duration(seconds: 5),
                                    backgroundColor: Colors.red,
                                  ));
                                }

                                Navigator.of(context).pop();
                                updateParcelConfirmation(
                                    _confirmok.text.trim());
                              },
                              child: const Text(
                                'confirm',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.red),
                                )),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 100.0,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 255, 191, 0),
                            Colors.amberAccent
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ), // Setting the background color using decoration
                        borderRadius: BorderRadius.circular(20.0)),
                    child: const Center(
                      child: Center(
                        child: Text(
                          "CONFIRMS",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
