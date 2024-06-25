import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> courierServices;

  const DashboardScreen({Key? key, required this.courierServices})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              print(courierServices.length);
            },
            child: const Text('Dashboard')),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: courierServices.length,
          itemBuilder: (context, index) {
            final courierService = courierServices[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
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
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${courierService['name']}',
                      style: const TextStyle(fontSize: 24, color: Colors.black),
                    ),
                    Text(
                      'Rating: ${courierService['rating']}',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Text(
                      'Email: ${courierService['address']['email_address']}',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Text(
                      'Phone: ${courierService['address']['phone_number']}',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Text(
                      'Address: ${courierService['address']['address']}',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
