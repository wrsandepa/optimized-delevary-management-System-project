import 'package:app1/sreen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Rating_w extends StatefulWidget {
  final dynamic parcelId_pass;
  final dynamic user3;
  const Rating_w({super.key, required this.parcelId_pass, required this.user3});

  @override
  State<Rating_w> createState() => _Rating_wState();
}

class _Rating_wState extends State<Rating_w> {
  double Rating = 0;

  Future<void> updateCourierServiceRatingByParcel(
      String parcelId, double userRating) async {
    try {
      // Get reference to the parcel document
      DocumentReference parcelRef =
          FirebaseFirestore.instance.collection('parcels').doc(parcelId);

      // Get the parcel document
      DocumentSnapshot parcelSnapshot = await parcelRef.get();

      if (parcelSnapshot.exists) {
        var parcelData = parcelSnapshot.data() as Map<String, dynamic>;
        String? courierServiceId = parcelData['parcelholder'];

        if (courierServiceId != null) {
          // Get reference to the courier service document
          DocumentReference courierRef = FirebaseFirestore.instance
              .collection('courierServices')
              .doc(courierServiceId);

          // Get the current data of the courier service
          DocumentSnapshot courierSnapshot = await courierRef.get();

          if (courierSnapshot.exists) {
            var courierData = courierSnapshot.data() as Map<String, dynamic>;
            int userCounter =
                courierData['userCounter'] ?? 0; // Ensure default value if null
            double currentRating =
                courierData['rating'] ?? 0; // Ensure default value if null

            // Calculate new rating
            double newRating = ((currentRating * userCounter) + userRating) /
                (userCounter + 1);

            // Update userCounter and rating in the document
            await courierRef
                .update({'userCounter': userCounter + 1, 'rating': newRating});

            // Show success snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Rating updated successfully.'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            // Show error snackbar if the courier service does not exist
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Courier service does not exist.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          // Show error snackbar if the parcel holder is null
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Parcel holder is null.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Show error snackbar if the parcel does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Parcel does not exist.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Show error snackbar for any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating rating: $e'),
          backgroundColor: Colors.red,
        ),
      );
      print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var ratingBar = Container(
      color: const Color.fromARGB(255, 209, 206, 206).withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.all(70),
        child: RatingBar.builder(
          updateOnDrag: true,
          initialRating: 0,
          itemCount: 5,
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (value) {
            print(Rating);
            setState(() {
              Rating = value;
            });
          },
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Rate Us!',
          ),
          backgroundColor: Colors.orange),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Rating',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              '$Rating',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            ratingBar,
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('drag for hear'),
                Icon(Icons.arrow_right_alt),
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            const Text(
                'Rate the courier service of your delevery based on \ntime,price and customer services'),
            TextButton(
              onPressed: () {
                if (Rating > 0) {
                  updateCourierServiceRatingByParcel(
                      widget.parcelId_pass, Rating);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Homescreen(
                                user1: widget.user3,
                              )));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No rating added try again!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                'ok',
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
