import 'package:app1/service/display_efficiancy_curior.dart';
import 'package:app1/sreen/ratingwindow.dart';
import 'package:app1/sreen/tracking.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

final TextEditingController _confirmok = TextEditingController();

class _HomescreenState extends State<Homescreen> {
  // the function use in hear snackbar is must define under scaffold
  Future<void> updateParcelConfirmation(String parcelId) async {
    try {
      // Get reference to the parcel document
      DocumentReference parcelRef =
          FirebaseFirestore.instance.collection('parcels').doc(parcelId);
      // Check if the document exists
      DocumentSnapshot snapshot = await parcelRef.get();
      if (snapshot.exists) {
        // Update the confirmation field to 'delivered'
        var data = snapshot.data() as Map<String, dynamic>;
        if (data['confirmation'] != 'delivered') {
          await parcelRef.update({
            'confirmation': 'delivered',
            'confirmationTime': FieldValue.serverTimestamp()
          });
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            // Show success snackbar
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Parcel marked as delivered.'),
              duration: Duration(seconds: 3), // Adjust the duration as needed
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
            // Show success snackbar
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Parcel already marked as delivered.'),
              duration: Duration(seconds: 3), // Adjust the duration as needed
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // ignore: use_build_context_synchronously
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
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Menu!',
          ),
          backgroundColor: Colors.orange),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.orange,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('assets1/annimation/pic.jpg'),
            fit: BoxFit.cover,
          ),
        ),
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
                const SizedBox(
                  height: 60,
                ),
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
                const SizedBox(
                  height: 50,
                ),
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
