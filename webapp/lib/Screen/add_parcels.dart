import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ParcelEntryScreen extends StatefulWidget {
  const ParcelEntryScreen({Key? key}) : super(key: key);

  @override
  _ParcelEntryScreenState createState() => _ParcelEntryScreenState();
}

class _ParcelEntryScreenState extends State<ParcelEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _trackingNumberController =
      TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _senPhoneController = TextEditingController();
  final TextEditingController _recPhoneController = TextEditingController();
  final TextEditingController _senNameController = TextEditingController();
  final TextEditingController _recNameController = TextEditingController();

  String? _selectedStatus;
  bool _parcelExists = false;

  final List<String> _statuses = [
    'In Process',
    'Shipped',
    'Delivered',
    'Delivered_release'
  ];

  Future<void> _checkParcelExists() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('parcels')
          .doc(_trackingNumberController.text.trim())
          .get();
      setState(() {
        _parcelExists = doc.exists;
      });
    } catch (e) {
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
            'parcelholder': 'pronto',
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

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Parcel added successfully!'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Add Parcel Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Add Parcel',
                                        style: TextStyle(fontSize: 20),
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
                                          _checkParcelExists();
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
                                      Visibility(
                                        visible: !_parcelExists,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Destination';
                                            }
                                            return null;
                                          },
                                          controller: _destinationController,
                                          decoration: InputDecoration(
                                            labelText: 'Destination',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Visibility(
                                        visible: !_parcelExists,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Receiver phone number';
                                            }
                                            return null;
                                          },
                                          controller: _recPhoneController,
                                          decoration: InputDecoration(
                                            labelText: 'Receiver phone number',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Visibility(
                                        visible: !_parcelExists,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Sender phone number';
                                            }
                                            return null;
                                          },
                                          controller: _senPhoneController,
                                          decoration: InputDecoration(
                                            labelText: 'Sender phone number',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Visibility(
                                        visible: !_parcelExists,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Sender name';
                                            }
                                            return null;
                                          },
                                          controller: _senNameController,
                                          decoration: InputDecoration(
                                            labelText: 'Sender name',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Visibility(
                                        visible: !_parcelExists,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Receiver name';
                                            }
                                            return null;
                                          },
                                          controller: _recNameController,
                                          decoration: InputDecoration(
                                            labelText: 'Receiver name',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: _addParcel,
                                        child: Text(
                                            _parcelExists ? 'Update' : 'Add'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 150,
                                height: 300,
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
                                child: const Text(
                                  'Delete parcels',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 150,
                                height: 300,
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
                                child: const Text(
                                  'Tracking parcel',
                                  style: TextStyle(fontSize: 20),
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
      ),
    );
  }
}
