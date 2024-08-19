import 'dart:math';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

// ignore: must_be_immutable
class ParcelEntryScreen extends StatefulWidget {
  const ParcelEntryScreen({super.key, required this.getusername});
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
  final TextEditingController weightController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
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

//add and update parcel
  Future<void> _addParcel() async {
    if (_formKey.currentState!.validate()) {
      if (_parcelExists) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('parcels')
            .doc(_trackingNumberController.text.trim())
            .get();
        Map<String, dynamic> parcelData1 = doc.data() as Map<String, dynamic>;
        if (parcelData1['parcelholder'] == widget.getusername) {
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('DOES NOT HAVE PERMISSION'),
              duration: Duration(seconds: 3),
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
            'weight': weightController.text.trim(),
            'price': priceController.text.trim(),
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
    priceController.clear();
    weightController.clear();
  }

  // delete parcel
  Future<dynamic> deleteparcel(String tracking) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('parcels')
          .doc(tracking)
          .get();
      Map<String, dynamic> parcelData = doc.data() as Map<String, dynamic>;
      if (parcelData['parcelholder'] == widget.getusername) {
        CollectionReference colleref =
            FirebaseFirestore.instance.collection('parcels');
        DocumentReference docuref = colleref.doc(tracking);
        await docuref.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('YOUR PARCEL IS DELETED'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
        DeleteController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Does Not Access to delete !'),
            duration: Duration(seconds: 5), // Adjust the duration as needed
            backgroundColor: Colors.red,
          ),
        );
        DeleteController.clear();
      }
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
            content: Text('YOUR PARCEL HAS DELEVERY COMPLEATED !'),
            duration: Duration(seconds: 5), // Adjust the duration as needed
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
                    deleteparcel(DeleteController.text.trim());
                    Navigator.of(context).pop();

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

// accesing timestamp with firbase
  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  Future<void> Show_parcel_details(
      BuildContext context, String parcelid) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('parcels')
          .doc(parcelid)
          .get();
      Map<String, dynamic> parcelData = doc.data() as Map<String, dynamic>;
      if (parcelData['parcelholder'] == widget.getusername) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                  'Your Parcel Tracking Number is: ${_trackingNumberController.text.trim()}'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoTile(Icons.location_on, 'Destination:',
                        parcelData['destination']),
                    _buildInfoTile(Icons.access_time, 'Last Update:',
                        _formatTimestamp(parcelData['lastupdate'])),
                    _buildInfoTile(Icons.person, 'Parcel Holder:',
                        parcelData['parcelholder']),
                    _buildInfoTile(Icons.account_circle, 'Receiver Name:',
                        parcelData['receiverName']),
                    _buildInfoTile(Icons.phone, 'Receiver Phone:',
                        parcelData['receiverPhone']),
                    _buildInfoTile(
                        Icons.person, 'Sender Name:', parcelData['senderName']),
                    _buildInfoTile(Icons.phone, 'Sender Phone:',
                        parcelData['senderPhone']),
                    _buildInfoTile(Icons.inventory, 'Weight:',
                        '${parcelData['weight']} kg'),
                    _buildInfoTile(Icons.attach_money, 'Price:',
                        '${parcelData['price']} rupees'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    trakingcontroller.clear();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        _scaffoldKey.currentState!.closeDrawer();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Not permition to more details'),
            duration: Duration(seconds: 4), // Adjust the duration as needed
            backgroundColor: Colors.red,
          ),
        );
        trakingcontroller.clear();
      }
    } catch (e) {}
  }

  Widget _buildInfoTile(IconData icon, String title, String? value) {
    return ListTile(
      leading: Icon(icon),
      title: Text('$title $value'),
      contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
    );
  }

  Widget _buildCard({
    required String title,
    required TextEditingController controller,
    required GlobalKey<FormState> formKey,
    required String buttonText,
    required VoidCallback onPressed,
    required Future<void> Function(String) onChanged,
  }) {
    return Card(
      elevation: 8, // Increase elevation for more pronounced shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Slightly rounded corners
      ),
      shadowColor: Colors.black.withOpacity(0.3), // Shadow color with opacity
      child: Container(
        width:
            MediaQuery.of(context).size.width / 2.5, // Adjust width if needed
        height: 200, // Increase height for better spacing
        padding:
            const EdgeInsets.all(15), // Increase padding for better spacing
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.0), // Match border radius
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22, // Slightly larger font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Enter Tracking Number',
                  labelStyle:
                      const TextStyle(color: Colors.black54), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
                onChanged: (value) async {
                  await onChanged(value); // Call the passed async function
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a tracking number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 24.0), // Text color
                  elevation: 5, // Add elevation for button shadow
                  shadowColor:
                      Colors.white.withOpacity(0.3), // Button shadow color
                ),
                child: Text(buttonText, style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
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
                          historyLength1! >= 1 ? Icons.check : Icons.close,
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
                      iconData:
                          historyLength1! >= 2 ? Icons.check : Icons.close,
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
                  child: Text('DELEVARING'),
                ),
                indicatorStyle: IndicatorStyle(
                  iconStyle: IconStyle(
                      iconData:
                          historyLength1! >= 3 ? Icons.check : Icons.close,
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
                  child: Text('DELEVARY OUT'),
                ),
                isLast: true,
                indicatorStyle: IndicatorStyle(
                  iconStyle: IconStyle(
                      iconData:
                          historyLength1! == 4 ? Icons.check : Icons.close,
                      fontSize: 20),
                  color: historyLength1! == 4
                      ? Colors.orange
                      : const Color.fromARGB(255, 87, 65, 65),
                ),
                beforeLineStyle: LineStyle(
                  color: historyLength1! == 4
                      ? Colors.orange
                      : const Color.fromARGB(255, 87, 65, 65),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextButton(
                  onPressed: () {
                    Show_parcel_details(context, trakingcontroller.text.trim());
                    _scaffoldKey.currentState!.closeDrawer();
                  },
                  child: const Text(
                    'More details',
                    style: TextStyle(color: Colors.blue),
                  ))
            ] else ...[
              const SizedBox(
                height: 50,
              ),
              Text('No More tracking Details')
            ]
          ],
        ),
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Tracking Parcels'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
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
                        elevation:
                            8, // Increase elevation for a more pronounced shadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              15.0), // Slightly larger border radius
                        ),
                        shadowColor: Colors.black
                            .withOpacity(0.3), // Shadow color with opacity
                        child: Container(
                          width: MediaQuery.of(context).size.width /
                              1.8, // Adjust width if needed
                          height: 600, // Maintain height
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey[200]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(
                                15.0), // Match border radius
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  20), // Increase padding for better spacing
                              child: SingleChildScrollView(
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _parcelExists
                                            ? 'Update Status'
                                            : 'Add Parcel',
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: _trackingNumberController,
                                        decoration: InputDecoration(
                                          labelText: 'Enter Tracking Number',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a tracking number';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          _checkParcelExists(
                                              _trackingNumberController.text
                                                  .trim());
                                        },
                                      ),
                                      const SizedBox(height: 16),
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
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select a status';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      if (!_parcelExists) ...[
                                        _buildTextField(_senPhoneController,
                                            'Enter Sender Phone Num'),
                                        const SizedBox(height: 16),
                                        _buildTextField(_senNameController,
                                            'Enter Sender Name'),
                                        const SizedBox(height: 16),
                                        _buildTextField(_recPhoneController,
                                            'Enter Receiver Phone Num'),
                                        const SizedBox(height: 16),
                                        _buildTextField(_recNameController,
                                            'Enter Receiver Name'),
                                        const SizedBox(height: 16),
                                        _buildTextField(_destinationController,
                                            'Enter Destination'),
                                        const SizedBox(height: 16),
                                        _buildTextField(
                                            weightController, 'Weight'),
                                        const SizedBox(height: 16),
                                        _buildTextField(
                                            priceController, 'Price'),
                                      ],
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: ElevatedButton(
                                          onPressed: _addParcel,
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14.0,
                                                horizontal: 24.0), // Text color
                                            elevation:
                                                5, // Add elevation for button shadow
                                            shadowColor: Colors.black
                                                .withOpacity(
                                                    0.3), // Button shadow color
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
                          _buildCard(
                            title: 'Delete Parcel',
                            controller: DeleteController,
                            formKey: _formKey_deleteparcel,
                            buttonText: 'Delete Parcel',
                            onChanged: (value) async {
                              // Call _checkParcelExists asynchronously
                              await _checkParcelExists(value.trim());
                            },
                            onPressed: () async {
                              await _showConfirmDialog(
                                  context, DeleteController.text);
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildCard(
                            title: 'Tracking Parcel',
                            controller: trakingcontroller,
                            formKey: formKey_tracking,
                            buttonText: 'Track Parcel',
                            onChanged: (value) async {
                              // Call _checkParcelExists asynchronously
                              await _checkParcelExists(value.trim());
                            },
                            onPressed: () async {
                              if (formKey_tracking.currentState!.validate() &&
                                  _parcelExists) {
                                _scaffoldKey.currentState!.openDrawer();
                                await _fetchhistorylength(
                                    trakingcontroller.text.trim());
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content:
                                        Text('YOUR PARCEL DOES NOT FOUND!'),
                                    duration: Duration(seconds: 3),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
