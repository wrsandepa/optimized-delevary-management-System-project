import 'dart:js_interop';
import 'dart:ui';

import 'package:app1/sreen/dashboard.dart';
import 'package:app1/sreen/tracking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class Display_curior_ser extends StatefulWidget {
  const Display_curior_ser({super.key});

  @override
  State<Display_curior_ser> createState() => _Display_curior_serState();
}

class _Display_curior_serState extends State<Display_curior_ser> {
  final TextEditingController home_town = TextEditingController();
  Future<List<Map<String, dynamic>>>? _futureCourierServices;
  List<Map<String, dynamic>> courierServices1 = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chose your selection!!!!',
        ),
        backgroundColor: Colors.orange,
      ),
      drawer: Drawer(
        backgroundColor: Colors.amber,
        child: ListView(
          children: [
            DrawerHeader(child: Text("LOGO")),
            Icon(Icons.home),
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 16.0), // Add padding here
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DashboardScreen(courierServices: courierServices1),
                  ),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 16.0), // Add padding here
              title: Text('Tracking'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Trackingmyparcel(),
                    ));
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 16.0), // Add padding here
              title: Text('Logout'),
              onTap: () {},
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.amber,
      ),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 255, 191, 0),
                        Colors.amberAccent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(6, 6),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        offset: const Offset(-6, -6),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: home_town,
                    decoration: InputDecoration(
                      labelText: 'Enter home town',
                      labelStyle: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 218, 12, 12)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  )),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.amberAccent),
              onPressed: () {
                if (home_town.text.isNotEmpty) {
                  setState(() {
                    _futureCourierServices =
                        getEfficientCourierServices(home_town.text);
                  });
                }
                if (home_town.text.isEmpty || home_town.text.trim().isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 100,
                          ),
                          backgroundColor: Colors.amber,
                          title: const Text('Could`t find name'),
                          content: Text(' empty entry!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  });
                  ;
                }
              },
              child: const Text('Submit'),
            ),
            if (_futureCourierServices != null)
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _futureCourierServices,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    ;
                    List<Map<String, dynamic>> courierServices =
                        snapshot.data ?? [];

                    return ListView.builder(
                      itemCount: courierServices.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> courierService =
                            courierServices[index];
                        return InkWell(
                          onTap: () {
                            courierServices1 = snapshot.data ?? [];
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Thank you choosing us!',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  backgroundColor: Colors.amber,
                                  content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'email: ${courierService['address']['email_address']}',
                                          style: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          'phone: ${courierService['address']['phone_number']}',
                                          style: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          'Address: ${courierService['address']['address']}',
                                          style: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.black),
                                        )
                                      ]),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'OK',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 255, 191, 0),
                                    Colors.amberAccent,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(6, 6),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.8),
                                    offset: const Offset(-6, -6),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ' ${courierService['name']}',
                                    style: const TextStyle(
                                        fontSize: 24, color: Colors.black),
                                  ),
                                  Text(
                                    'Rating: ${courierService['rating']}',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            SizedBox(height: 100),
            Container(
              height: 100,
              width: 100,
              child: LottieBuilder.network(
                'assets1/annimation/openwindow.json',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getEfficientCourierServices(
    String hometown,
  ) async {
    List<Map<String, dynamic>> result = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('courierServices')
        .orderBy('rating',
            descending: true) // Example: order by descending rating
        .limit(2) // Limit to top 2 efficient services
        .get();

    for (var courierServiceDoc in querySnapshot.docs) {
      QuerySnapshot branchSnapshot = await FirebaseFirestore.instance
          .collection('courierServices')
          .doc(courierServiceDoc.id)
          .collection('branches')
          .where('location_address', isEqualTo: hometown)
          .get();
      if (branchSnapshot.docs.isNotEmpty) {
        result.add({
          'id': courierServiceDoc.id,
          'name': courierServiceDoc['name'],
          'rating': courierServiceDoc['rating'],
          'address': branchSnapshot.docs.first.data(),
        });
      }
      if (result.length >= 10) {
        break;
      }
    }
    return result;
  }
}
