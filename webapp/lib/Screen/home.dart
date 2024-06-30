import 'dart:async';

import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    super.key,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  List<String> imageUrls = [
    'assets/3d-delivery-robot-working.jpg',
    'assets/deliver-man-holding-package.jpg',
    'assets/delivery-man-with-clipboard.jpg',
    'assets/delivery-men-loading-carboard-boxes-van-while-getting-ready-shipment.jpg',
  ];
  int currentImageIndex = 0;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Animation duration
    );

    _animation = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
        .animate(_controller);

    // Start timer to change photo every 5 seconds
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        currentImageIndex = (currentImageIndex + 1) % imageUrls.length;
        _controller.forward(from: 0.0); // Start animation from beginning
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Padding(
        padding: const EdgeInsets.all(80.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                //container with   contact us
                Container(
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: NetworkImage(
                          'assets/ThunderDrop-text-Color-logo.png'),
                      fit: BoxFit.contain,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 75,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('HotLine ',
                          style: TextStyle(color: Colors.black)),
                      const Text('+94 779038886',
                          style: TextStyle(color: Colors.blue)),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Contact Us',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Home',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left Container with image
                      SlideTransition(
                        position: _animation,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imageUrls[currentImageIndex]),
                              fit: BoxFit.cover,
                            ),
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width / 2 -
                              50, // Adjust for padding
                          margin: const EdgeInsets.all(10),
                        ),
                      ),

                      // Right Container with buttons
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width / 2 -
                            170, // Adjust for padding
                        margin: const EdgeInsets.all(20),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                        'assets/delivery-service-illustrated_23-2148505081.jpg'),
                                    fit: BoxFit.contain,
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(40),
                                child: Text(
                                  'Welcome to TurboDrop, your premier destination for efficient courier services. We specialize in swift and reliable deliveries, ensuring your packages reach their destination promptly and securely. Explore our user-friendly platform to experience seamless booking, tracking, and management of your deliveries. Join thousands of satisfied customers who trust TurboDrop for their logistics needs',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      elevation:
                                          10, // Elevation (controls the "3D" effect)
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            0), // Button border radius
                                      ),
                                      padding: const EdgeInsets.all(
                                          20), // Padding around the button content
                                      // Add a gradient background
                                    ),
                                    child: const Text('GET START'),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      elevation:
                                          10, // Elevation (controls the "3D" effect)
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            0), // Button border radius
                                      ),
                                      padding: const EdgeInsets.all(
                                          20), // Padding around the button content
                                      // Add a gradient background
                                    ),
                                    child: const Text('SIGNUP'),
                                  )
                                ],
                              ),
                            ]),
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
