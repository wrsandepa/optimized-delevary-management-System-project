import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

// ignore: must_be_immutable
class ParcelEntryScreen extends StatefulWidget {
  ParcelEntryScreen({Key? key, required this.getusername}) : super(key: key);
  final dynamic getusername;
  @override
  _ParcelEntryScreenState createState() => _ParcelEntryScreenState();
}

class _ParcelEntryScreenState extends State<ParcelEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _formKey_deleteparcel = GlobalKey<FormState>();
  final formKey_tracking = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _trackingNumberController =
      TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _senPhoneController = TextEditingController();
  final TextEditingController _recPhoneController = TextEditingController();
  final TextEditingController _senNameController = TextEditingController();
  final TextEditingController _recNameController = TextEditingController();
  final TextEditingController DeleteController = TextEditingController();
  final TextEditingController trakingcontroller = TextEditingController();

  String? _selectedStatus;
  bool _parcelExists = false;
  int? historyLength1;
  bool? delivered1;

  final List<String> _statuses = [
    'In Process',
    'Shipped',
    'Delivered',
    'Delivered_release'
  ];

  Future<void> _checkParcelExists(String Parcel_id) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('parcels')
          .doc(Parcel_id)
          .get();
      setState(() {
        _parcelExists = doc.exists;
      });
    } catch (e) {
      // ignore: avoid_print
      print('error is :: $e');
    }
  }

  Future<void> _addParcel() async {
    if (_formKey.currentState!.validate()) {
      if (_parcelExists) {
        try {
          CollectionReference collectionRef =
              FirebaseFirestore.instance.collection('parcels');
          DocumentReference parcelDoc =
              collectionRef.doc(_trackingNumberController.text.trim());

          await parcelDoc.update({
            'history': FieldValue.arrayUnion([
              {
                'status': _selectedStatus,
                // Optionally add a timestamp
              }
            ]),
            'lastupdate': FieldValue.serverTimestamp(),
          });

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Parcel updated successfully!'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
            ),
          );

          _formKey.currentState!.reset();
          _clearControllers();
          setState(() {
            _selectedStatus = null;
          });
        } catch (e) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Error updating parcel: $e'),
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        try {
          final collectionRef =
              FirebaseFirestore.instance.collection('parcels');
          final parcelDoc =
              collectionRef.doc(_trackingNumberController.text.trim());

          await parcelDoc.set({
            'parcelholder': widget.getusername,
            'history': [
              {
                'status': _selectedStatus,
              },
            ],
            'destination': _destinationController.text.trim(),
            'senderPhone': _senPhoneController.text.trim(),
            'receiverPhone': _recPhoneController.text.trim(),
            'senderName': _senNameController.text.trim(),
            'receiverName': _recNameController.text.trim(),
            'lastupdate': FieldValue.serverTimestamp(),
          });

          //ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Parcel added successfully!'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
            ),
          );

          _formKey.currentState!.reset();
          _
          _clearControllers();
          setState(() {
            _selectedStatus = null;
          });
        } catch (e) {
          // ignore: use_build_context_synchronously
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Error adding parcel: $e'),
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _clearControllers() {
    _trackingNumberController.clear();
    _destinationController.clear();
    _senPhoneController.clear();
    _recPhoneController.clear();
    _senNameController.clear();
    _recNameController.clear();
  }

  // delete parcel
  Future<dynamic> deleteparcel(String tracking) async {
    try {
      CollectionReference colleref =
          FirebaseFirestore.instance.collection('parcels');
      DocumentReference docuref = colleref.doc(tracking);
      await docuref.delete();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

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
          const SnackBar(
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
      delivered1 = false; // Handle error gracefully
    }

    return delivered1;
  }

// Function to fetch history length to historyLength1
  Future<void> _fetchhistorylength(String parcleId) async {
    try {
      isDelivered(parcleId);
      int? length = await getHistoryLength(parcleId);
      setState(() {
        historyLength1 = length;
      });
      print(historyLength1);
    } catch (e) {
      print('$e');
    }
  }

  Future<dynamic> _showConfirmDialog(
      BuildContext context, String trackingNumber) async {
    try {
      if (_formKey_deleteparcel.currentState!.validate()) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content: Text(
                  'Are you sure you want to delete the parcel with tracking number $trackingNumber?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    deleteparcel(_trackingNumberController.text.trim());
                    Navigator.of(context).pop();
                    DeleteController.clear();
                    _formKey_deleteparcel.currentState?.reset();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
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
                      : const Color.fromARGB(255, 145, 135, 135),
                ),
                afterLineStyle: LineStyle(
                  color: historyLength1! >= 3
                      ? Colors.orange
                      : Color.fromARGB(255, 199, 17, 17),
                ),
              ),
            ]
          ],
        ),
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Tracking Parcels'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: NetworkImage(
                          'assets/ThunderDrop-text-Color-logo.png'),
                      fit: BoxFit.contain,
                    ),
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 600,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: SingleChildScrollView(
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Text(
                                        _parcelExists
                                            ? 'Update Status'
                                            : 'Add Parcel',
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter Tracking Num';
                                          }
                                          return null;
                                        },
                                        controller: _trackingNumberController,
                                        decoration: InputDecoration(
                                          labelText: 'Enter Tracking Num',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          _checkParcelExists(
                                              _trackingNumberController.text
                                                  .trim());
                                        },
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<String>(
                                        value: _selectedStatus,
                                        items: _statuses.map((String status) {
                                          return DropdownMenuItem<String>(
                                            value: status,
                                            child: Text(status),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedStatus = newValue;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Select Status',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select a status';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 8),
                                      if (!_parcelExists) ...[
                                        TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Sender Phone Num';
                                            }
                                            return null;
                                          },
                                          controller: _senPhoneController,
                                          decoration: InputDecoration(
                                            labelText: 'Enter Sender Phone Num',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Sender Name';
                                            }
                                            return null;
                                          },
                                          controller: _senNameController,
                                          decoration: InputDecoration(
                                            labelText: 'Enter Sender Name',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Receiver Phone Num';
                                            }
                                            return null;
                                          },
                                          controller: _recPhoneController,
                                          decoration: InputDecoration(
                                            labelText:
                                                'Enter Receiver Phone Num',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Receiver Name';
                                            }
                                            return null;
                                          },
                                          controller: _recNameController,
                                          decoration: InputDecoration(
                                            labelText: 'Enter Receiver Name',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Destination';
                                            }
                                            return null;
                                          },
                                          controller: _destinationController,
                                          decoration: InputDecoration(
                                            labelText: 'Enter Destination',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: ElevatedButton(
                                          onPressed: _addParcel,
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.0,
                                                horizontal: 24.0),
                                          ),
                                          child: const Text(
                                            'Submit',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3.5,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: SingleChildScrollView(
                                    child: Form(
                                      key: _formKey_deleteparcel,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Delete Parcel',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          const SizedBox(height: 8),
                                          TextFormField(
                                            controller: DeleteController,
                                            decoration: InputDecoration(
                                              labelText:
                                                  'Enter Tracking Number',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a tracking number';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          ElevatedButton(
                                            onPressed: () async {
                                              await _showConfirmDialog(context,
                                                  DeleteController.text);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0,
                                                      horizontal: 24.0),
                                            ),
                                            child: const Text(
                                              'Delete Parcel',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3.5,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Form(
                                    key: formKey_tracking,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Tracking Parcel',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          const SizedBox(height: 16),
                                          TextFormField(
                                            onChanged: (value) {
                                              _checkParcelExists(
                                                  trakingcontroller.text
                                                      .trim());
                                            },
                                            controller: trakingcontroller,
                                            decoration: InputDecoration(
                                              labelText:
                                                  'Enter Tracking Number',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a tracking number';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (formKey_tracking.currentState!
                                                      .validate() &&
                                                  _parcelExists) {
                                                _scaffoldKey.currentState!
                                                    .openDrawer();
                                                _fetchhistorylength(
                                                    trakingcontroller.text
                                                        .trim());
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    content: Text(
                                                        'YOUR PARCEL DOES NOT FOUND !'),
                                                    duration: Duration(
                                                        seconds:
                                                            3), // Adjust the duration as needed
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0,
                                                      horizontal: 24.0),
                                            ),
                                            child: const Text(
                                              'Track Parcel',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
