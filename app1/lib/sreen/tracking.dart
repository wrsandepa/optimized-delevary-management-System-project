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

// Function to check if confirmation status is "delivered"
  Future<bool?> isDelivered(String parcelId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Reference to the specific document in the parcels collection
      DocumentSnapshot document =
          await firestore.collection('parcels').doc(parcelId).get();

      var data = document.data() as Map<String, dynamic>;

      // Check if the document exists and has confirmation field
      if (document.exists && data.isNotEmpty) {
        String confirmationStatus = data['confirmation'];
        delivered1 = (confirmationStatus == 'delivered');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('YOUR PARCEL HAS DELEVERY CVOMPLEATED !'),
            duration: Duration(seconds: 3), // Adjust the duration as needed
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Handle case where confirmation field doesn't exist or is null
        delivered1 = false;
      }
    } catch (e) {
      print("Error checking confirmation status: $e");
      delivered1 = false; // Handle error gracefully
    }

    return delivered1;
  }

// Function to fetch history length to _historyLength
  Future<void> _fetchhistorylength(String parcleId) async {
    try {
      isDelivered(parcleId);
      int? length = await getHistoryLength(parcleId);
      setState(() {
        historyLength1 = length;
      });
    } catch (e) {
      print('error');
    }
  }

  int? historyLength1;
  bool? delivered1;

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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('assets1/annimation/pic.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey1,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
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
                    controller: _traking_num,
                    decoration: InputDecoration(
                        hintText: "enter your tracking number",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                    validator: (value) => value == null ||
                            value.trim().isEmpty ||
                            getHistoryLength(_traking_num.text.trim()) == null
                        ? 'Your Tracking number is invalied '
                        : null,
                  )),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple, // Text color
                    shadowColor: Colors.deepPurpleAccent, // Shadow color
                    elevation: 5, // Elevation
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24), // Rounded edges
                    ),
                  ),
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
                    color: historyLength1! >= 2
                        ? Colors.orange
                        : Color.fromARGB(255, 145, 135, 135),
                  ),
                  afterLineStyle: LineStyle(
                    color: historyLength1! >= 3
                        ? Colors.orange
                        : Color.fromARGB(255, 199, 17, 17),
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
      ),
    );
  }
}
