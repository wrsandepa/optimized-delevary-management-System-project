import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
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
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('YOUR PARCEL HAS DELIVERY COMPLETED!'),
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
  Future<void> _fetchhistorylength(String parcelId) async {
    try {
      isDelivered(parcelId);
      int? length = await getHistoryLength(parcelId);
      setState(() {
        historyLength1 = length;
      });
    } catch (e) {
      print('$e');
    }
  }

  // Accessing timestamp with Firebase
  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  Future<void> Show_parcel_details(
      BuildContext context, String parcelId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('parcels')
          .doc(parcelId)
          .get();
      Map<String, dynamic> parcelData = doc.data() as Map<String, dynamic>;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                'Your Parcel Tracking Number is : ${_traking_num.text.trim()}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text('Destination: ${parcelData['destination']}'),
                ),
                ListTile(
                  leading: Icon(Icons.access_time),
                  title: Text(
                      'Last Update: ${_formatTimestamp(parcelData['lastupdate'])}'),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Parcel Holder: ${parcelData['parcelholder']}'),
                ),
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Receiver Name: ${parcelData['receiverName']}'),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('Receiver Phone: ${parcelData['receiverPhone']}'),
                ),
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text('Sender Name: ${parcelData['senderName']}'),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('Sender Phone: ${parcelData['senderPhone']}'),
                ),
                ListTile(
                  leading: Icon(Icons.scale),
                  title: Text('Weight: ${parcelData['weight']} kg'),
                ),
                ListTile(
                  leading: Icon(Icons.monetization_on),
                  title: Text('Price: ${parcelData['price']} rs'),
                )
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
    } catch (e) {}
  }

  int? historyLength1;
  bool? delivered1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Tracking Your Parcel!',
          ),
          backgroundColor: Colors.orange),
      bottomNavigationBar: const BottomAppBar(
        height: 60,
        color: Colors.orange,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Positioned.fill(
            child: Image.network(
              'assets1/annimation/pic2.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                        hintText: "Enter your tracking number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Your tracking number is invalid'
                              : null,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.amber, // Text color
                      shadowColor: Colors.orange, // Shadow color
                      elevation: 5, // Elevation
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(24), // Rounded edges
                      ),
                    ),
                    onPressed: () async {
                      String parcelId = _traking_num.text.trim();
                      if (_formKey1.currentState!.validate()) {
                        await _fetchhistorylength(parcelId);
                        print(historyLength1);
                      }
                    },
                    child: const Text("TRACK"),
                  ),
                  if (historyLength1 != null) ...[
                    TimelineTile(
                      endChild: const Padding(
                        padding: EdgeInsets.all(40),
                        child: Text('PROCESSING'),
                      ),
                      indicatorStyle: IndicatorStyle(
                        iconStyle: IconStyle(
                            iconData: historyLength1! >= 1
                                ? Icons.check
                                : Icons.close,
                            fontSize: 20),
                        color: historyLength1! >= 1
                            ? Colors.orange
                            : const Color.fromARGB(255, 87, 65, 65),
                      ),
                      afterLineStyle: LineStyle(
                        color: historyLength1! >= 2
                            ? Colors.orange
                            : Color.fromARGB(255, 87, 65, 65),
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
                            iconData: historyLength1! >= 2
                                ? Icons.check
                                : Icons.close,
                            fontSize: 20),
                        color: historyLength1! >= 2
                            ? Colors.orange
                            : Color.fromARGB(255, 87, 65, 65),
                      ),
                      beforeLineStyle: LineStyle(
                        color: historyLength1! >= 2
                            ? Colors.orange
                            : Color.fromARGB(255, 87, 65, 65),
                      ),
                      afterLineStyle: LineStyle(
                        color: historyLength1! >= 3
                            ? Colors.orange
                            : Color.fromARGB(255, 87, 65, 65),
                      ),
                    ),
                    TimelineTile(
                      endChild: const Padding(
                        padding: EdgeInsets.all(40),
                        child: Text('DELIVERING'),
                      ),
                      indicatorStyle: IndicatorStyle(
                        iconStyle: IconStyle(
                            iconData: historyLength1! >= 3
                                ? Icons.check
                                : Icons.close,
                            fontSize: 20),
                        color: historyLength1! >= 3
                            ? Colors.orange
                            : Color.fromARGB(255, 87, 65, 65),
                      ),
                      beforeLineStyle: LineStyle(
                        color: historyLength1! >= 3
                            ? Colors.orange
                            : Color.fromARGB(255, 87, 65, 65),
                      ),
                      afterLineStyle: LineStyle(
                        color: historyLength1! >= 4
                            ? Colors.orange
                            : Color.fromARGB(255, 87, 65, 65),
                      ),
                    ),
                    TimelineTile(
                      endChild: const Padding(
                        padding: EdgeInsets.all(40),
                        child: Text('DELIVERY OUT'),
                      ),
                      isLast: true,
                      indicatorStyle: IndicatorStyle(
                        iconStyle: IconStyle(
                            iconData: historyLength1! == 4
                                ? Icons.check
                                : Icons.close,
                            fontSize: 20),
                        color: historyLength1! == 4
                            ? Colors.orange
                            : Color.fromARGB(255, 87, 65, 65),
                      ),
                      beforeLineStyle: LineStyle(
                        color: historyLength1! == 4
                            ? Colors.orange
                            : Color.fromARGB(255, 87, 65, 65),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    TextButton(
                      onPressed: () async {
                        await Show_parcel_details(
                            context, _traking_num.text.trim());
                        _traking_num.clear();
                      },
                      child: const Text(
                        'More Details',
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ] else ...[
                    SizedBox(
                      width: 300,
                      height: 300,
                      child:
                          // Lottie animation
                          LottieBuilder.network(
                              'assets1/annimation/raking.json'),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
