import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Trackingmyparcel extends StatefulWidget {
  const Trackingmyparcel({super.key});

  @override
  State<Trackingmyparcel> createState() => _TrackingmyparcelState();
}

class _TrackingmyparcelState extends State<Trackingmyparcel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'hello',
          ),
          backgroundColor: Colors.orange),
      body: GestureDetector(
        onTap: () {
          getHistoryLength();
        },
        child: Container(
          width: 50,
          height: 50,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}

Future<void> getHistoryLength() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int? historyLength;
  String parcelId = 'parcel_id_1';
  try {
    // Reference to the specific document in the parcels collection
    DocumentSnapshot document =
        await firestore.collection('parcels').doc(parcelId).get();
    var data = document.data() as Map<String, dynamic>;
    List<dynamic> history = data['history'];
    historyLength = history.length;
  } catch (e) {
    print(e);
  }
  print(historyLength);
}
