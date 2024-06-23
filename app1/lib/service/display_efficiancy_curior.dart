import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Display_curior_ser extends StatelessWidget {
  const Display_curior_ser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
          title: const Text(
            'Chose your selection!!',
          ),
          backgroundColor: Colors.orange),
      body: FutureBuilder<List<DocumentSnapshot>>(
          future: getEfficientCourierServices(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            List<DocumentSnapshot> courierServices = snapshot.data ?? [];
            return ListView.builder(
              itemCount: courierServices.length,
              itemBuilder: (context, index) {
                DocumentSnapshot courierService = courierServices[index];
                return Padding(
                  padding: EdgeInsets.all(1),
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(12.0),
                    color: Colors.blueAccent,
                     child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ${courierService['name']}',
                          style: TextStyle(fontSize: 5, color: Colors.black),
                        ),
                        Text('Rating: ${courierService['rating']}',
                            style: TextStyle(fontSize: 5, color: Colors.black)),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  Future<List<DocumentSnapshot>> getEfficientCourierServices() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('courierServices')
        .orderBy('rating',
            descending: true) // Example: order by descending rating
        .limit(2) // Limit to top 5 efficient services
        .get();

    return querySnapshot.docs;
  }
}
