import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:timeline_tile/timeline_tile.dart';

class Trackingmyparcel extends StatefulWidget {
  const Trackingmyparcel({super.key});

  @override
  State<Trackingmyparcel> createState() => _TrackingmyparcelState();
}

final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
final TextEditingController _traking_num = TextEditingController();

class _TrackingmyparcelState extends State<Trackingmyparcel> {
  // Function to get history length from Firestore
  Future<int?> getHistoryLength(String parcelId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    int? historyLength;
    // String parcelId = 'parcel_id_1';
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
  Future<void> _fetchhistorylength(String parcleId) async {
    try {
      int? length = await getHistoryLength(parcleId);
      setState(() {
        historyLength1 = length;
      });
    } catch (e) {
      print('error');
    }
  }

  int? historyLength1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Tracking your parcel!',
          ),
          backgroundColor: Colors.orange),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey1,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            TextFormField(
              controller: _traking_num,
              decoration: InputDecoration(
                  hintText: "enter your tracking number",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Your Tracking number is invalied '
                  : null,
            ),
            ElevatedButton(
                onPressed: () async {
                  String parcelId = _traking_num.text.trim();
                  if (_formKey1.currentState!.validate()) {
                    await _fetchhistorylength(parcelId);
                    print(historyLength1);
                  }
                },
                child: const Text("TRACK")),
            if (historyLength1 != null) ...[
              TimelineTile(
                endChild: const Padding(
                  padding: EdgeInsets.all(40),
                  child: Text('PROCESSING'),
                ),
                indicatorStyle: IndicatorStyle(
                  iconStyle: IconStyle(
                      iconData:
                          historyLength1! >= 0 ? Icons.check : Icons.close,
                      fontSize: 20),
                  color: historyLength1! >= 0
                      ? Colors.orange
                      : const Color.fromARGB(255, 87, 65, 65),
                ),
                afterLineStyle: LineStyle(
                  color: historyLength1! >= 0 ? Colors.orange : Colors.white,
                ),
                isFirst: true,
              ),
              TimelineTile(
                endChild: const Padding(
                  padding: EdgeInsets.all(40),
                  child: Text('SHIPPED'),
                ),
                indicatorStyle: IndicatorStyle(
                  iconStyle: IconStyle(
                      iconData:
                          historyLength1! >= 1 ? Icons.check : Icons.close,
                      fontSize: 20),
                  color: historyLength1! >= 1 ? Colors.orange : Colors.white,
                ),
                beforeLineStyle: LineStyle(
                  color: historyLength1! >= 0 ? Colors.orange : Colors.white,
                ),
                afterLineStyle: LineStyle(
                  color: historyLength1! >= 1 ? Colors.orange : Colors.white,
                ),
              ),
              TimelineTile(
                endChild: const Padding(
                  padding: EdgeInsets.all(40),
                  child: Text('DELEVARING'),
                ),
                indicatorStyle: IndicatorStyle(
                  iconStyle: IconStyle(
                      iconData:
                          historyLength1! >= 2 ? Icons.check : Icons.close,
                      fontSize: 20),
                  color: historyLength1! >= 2 ? Colors.orange : Colors.white,
                ),
                beforeLineStyle: LineStyle(
                  color: historyLength1! >= 1 ? Colors.orange : Colors.white,
                ),
                afterLineStyle: LineStyle(
                  color: historyLength1! >= 2 ? Colors.orange : Colors.white,
                ),
              ),
              TimelineTile(
                endChild: const Padding(
                  padding: EdgeInsets.all(40),
                  child: Text('DELEVARY OUT'),
                ),
                isLast: true,
                indicatorStyle: IndicatorStyle(
                  iconStyle: IconStyle(
                      iconData:
                          historyLength1! >= 3 ? Icons.check : Icons.close,
                      fontSize: 20),
                  color: historyLength1! >= 3
                      ? Colors.orange
                      : const Color.fromARGB(255, 145, 135, 135),
                ),
                beforeLineStyle: LineStyle(
                  color: historyLength1! >= 2 ? Colors.orange : Colors.white,
                ),
              ),
            ] else ...[
              SizedBox(
                width: 300,
                height: 300,
                child:
                    // Lottie animation
                    LottieBuilder.network('assets1/annimation/raking.json'),
              ),
              // Splash message (conditionally shown)
              Container(
                color: Colors.black
                    .withOpacity(0.4), // Semi-transparent background
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Parcel Not Found!...',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
            ]
          ]),
        ),
      ),
    );
  }
}
