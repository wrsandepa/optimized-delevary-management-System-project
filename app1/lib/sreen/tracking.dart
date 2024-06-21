import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:timeline_tile/timeline_tile.dart';

class Trackingmyparcel extends StatefulWidget {
  const Trackingmyparcel({super.key});

  @override
  State<Trackingmyparcel> createState() => _TrackingmyparcelState();
}

class _TrackingmyparcelState extends State<Trackingmyparcel> {
  // Function to get history length from Firestore
  Future<int?> getHistoryLength() async {
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
      print("error");
    }
    return historyLength;
  }

// Function to fetch history length to _historyLength
  Future<void> _fetchhistorylength() async {
    try {
      int? length = await getHistoryLength();
      setState(() {
        historyLength = length;
      });
    } catch (e) {}
  }

  int? historyLength;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'hello',
          ),
          backgroundColor: Colors.orange),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          TextFormField(
            decoration: InputDecoration(
                hintText: "enter your tracking number",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
          ElevatedButton(
              onPressed: () async {
                await _fetchhistorylength();
                print(historyLength);
                setState(() {});
              },
              child: const Text("TRACK")),
          if (historyLength != null) ...[
            TimelineTile(
              indicatorStyle: const IndicatorStyle(
                  color: Colors.black, padding: EdgeInsets.all(2)),
              afterLineStyle: const LineStyle(
                color: Colors.blueAccent,
              ),
              isFirst: true,
            ),
            TimelineTile(
              indicatorStyle: const IndicatorStyle(
                color: Colors.blueAccent,
                padding: EdgeInsets.all(2),
              ),
              beforeLineStyle:
                  const LineStyle(color: Color.fromARGB(115, 206, 32, 32)),
              afterLineStyle: const LineStyle(color: Colors.blueAccent),
            ),
            TimelineTile(
              indicatorStyle: const IndicatorStyle(
                  color: Colors.blueAccent, padding: EdgeInsets.all(2)),
              beforeLineStyle:
                  const LineStyle(color: Color.fromARGB(115, 206, 32, 32)),
              afterLineStyle: const LineStyle(color: Colors.blueAccent),
            ),
            TimelineTile(
              isLast: true,
              indicatorStyle: const IndicatorStyle(
                  color: Colors.blueAccent, padding: EdgeInsets.all(2)),
              beforeLineStyle:
                  const LineStyle(color: Color.fromARGB(115, 206, 32, 32)),
              afterLineStyle: const LineStyle(color: Colors.blueAccent),
            ),
          ] else
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                width: 500,
                height: 50,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          Container(
              width: 300,
              height: 300,
              child: LottieBuilder.network('assets1/annimation/raking.json'))
        ]),
      ),
    );
  }
}
