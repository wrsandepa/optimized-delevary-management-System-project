import 'package:app1/service/display_efficiancy_curior.dart';
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
        await parcelRef.update({
          'confirmation': 'delivered',
          'confirmationTime': FieldValue.serverTimestamp()
        });
        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Parcel marked as delivered.'),
            duration: Duration(seconds: 3), // Adjust the duration as needed
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
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
            'hellod',
          ),
          backgroundColor: Colors.orange),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.amber,
      ),
      body: Center(
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
                height: 60,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.amber,
                        title: const Text('Could`t find name'),
                        content: TextFormField(
                          controller: _confirmok,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              updateParcelConfirmation(_confirmok.text.trim());

                              Navigator.of(context).pop();
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
                  width: 10000,
                  height: 200.0,
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
    );
  }
}
