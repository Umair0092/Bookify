import 'package:bookify/Screens/bus/bus.dart';
import 'package:bookify/Screens/bus/bushomepagecard.dart';
import 'package:bookify/Screens/events/eventhomepagecar.dart';
import 'package:bookify/Screens/events/events.dart';
import 'package:bookify/Screens/flights/flighthomepage.dart';
import 'package:bookify/Screens/flights/flights.dart';
import 'package:bookify/Screens/localservice/localservices.dart';
import 'package:bookify/Screens/localservice/locservcar.dart';
import 'package:bookify/services/flights.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'bus/bussearch.dart';
import 'flights/flight_details_page.dart';
import 'flights/flightsearch.dart';
import 'flights_cards.dart';

const Color white = Colors.white; // Replace with your Colors.dart import

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool _isTapped = false;
  bool _isTapped2 = false;
  bool _isTapped3 = false;
  bool _isTapped4 = false;
  bool _isTapped5 = false;
  
  String name ='';
   final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  @override
  void initState() {
    //
    super.initState();
    print("fligt data");
    
    _initializename();
  }
  Future<void> _initializename() async {
    final currentUser = _auth.currentUser;
    name = currentUser?.displayName ?? "" ;
    if (currentUser != null) {
      // Fetch user data from Firestore
      //print("enter if");
      final docSnapshot = await _firestore.collection('users').doc(currentUser.uid).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        
        name= data?['name'] ?? "user";
        //print(name);
      }
    }
  
    setState(() {}); // Update UI after fetching data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.grey,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        
                        "Hello $name 😀\nHow are you Today",
                        style: TextStyle(color: white),
                      ),
                    ),
                    Icon(
                      Icons.notifications,
                      color: const Color.fromRGBO(255, 193, 7, 1),
                    ),
                  ],
                ),
              ),
              MyCarousel(),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  "Explore Booking\nOptions and Services ",
                  style: TextStyle(
                    color: white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isTapped = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _isTapped = false;
                      });
                      print("Flights tapped!");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Flightsui()),
                      );
                    },
                    onTapCancel: () {
                      setState(() {
                        _isTapped = false;
                      });
                    },
                    child: Container(
                      height: 75,
                      width: MediaQuery.of(context).size.width / 2.5,
                      margin: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color:
                            _isTapped
                                ? const Color.fromRGBO(255, 193, 7, 0.8)
                                : const Color.fromRGBO(255, 193, 7, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.flight, color: Colors.black, size: 50),
                          Text(
                            "Flights",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isTapped2 = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _isTapped2 = false;
                      });
                      print("Buses tapped!");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Bus()),
                      );
                    },
                    onTapCancel: () {
                      setState(() {
                        _isTapped2 = false;
                      });
                    },
                    child: Container(
                      height: 75,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                        color:
                            _isTapped2
                                ? const Color.fromRGBO(255, 193, 7, 0.8)
                                : const Color.fromRGBO(255, 193, 7, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_bus_filled,
                            color: Colors.black,
                            size: 50,
                          ),
                          Text(
                            "Buses",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isTapped3 = true;
                      });
                      //Navigator.push(context,MaterialPageRoute(builder: (context)=>(),));
                    },
                    onTapUp: (_) {
                      setState(() {
                        _isTapped3 = false;
                      });
                      print("Services tapped!");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocalServices(),
                        ),
                      );
                    },
                    onTapCancel: () {
                      setState(() {
                        _isTapped3 = false;
                      });
                    },
                    child: Container(
                      height: 75,
                      width: MediaQuery.of(context).size.width / 2.5,
                      margin: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color:
                            _isTapped3
                                ? const Color.fromRGBO(255, 193, 7, 0.8)
                                : const Color.fromRGBO(255, 193, 7, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.design_services,
                            color: Colors.black,
                            size: 50,
                          ),
                          Text(
                            "Services",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isTapped4 = true;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Events()),
                      );
                    },
                    onTapUp: (_) {
                      setState(() {
                        _isTapped4 = false;
                      });
                      print("Events tapped!");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Events()),
                      );
                    },
                    onTapCancel: () {
                      setState(() {
                        _isTapped4 = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Events()),
                      );
                    },
                    child: Container(
                      height: 75,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                        color:
                            _isTapped4
                                ? const Color.fromRGBO(255, 193, 7, 0.8)
                                : const Color.fromRGBO(255, 193, 7, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event, color: Colors.black, size: 50),
                          Text(
                            "Events",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Flights",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                          GestureDetector(
                            onTapDown: (_) {
                              setState(() {
                                _isTapped5 = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                _isTapped5 = false;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Flightsui(),
                                ),
                              );
                            },
                            onTapCancel: () {
                              setState(() {
                                _isTapped5 = false;
                              });
                            },
                            child: Text(
                              "Show more",
                              style: TextStyle(
                                color: _isTapped5
                                    ? const Color.fromRGBO(255, 193, 7, 0.8)
                                    : const Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: FlightHorizontalList(),
                    ),
                  ],
                ),
              ),

              //const SizedBox(height: 10),

              //////////////////////////////////////////////////////////////////////////////////////////////////////////
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:  const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Bus",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                          GestureDetector(
                            onTapDown: (_) {
                              setState(() {
                                _isTapped5 = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                _isTapped5 = false;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Bus(),
                                ),
                              );
                            },
                            onTapCancel: () {
                              setState(() {
                                _isTapped5 = false;
                              });
                            },
                            child: Text(
                              "Show more",
                              style: TextStyle(
                                color: _isTapped5
                                    ? const Color.fromRGBO(255, 193, 7, 0.8)
                                    : const Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: BusHorizontalList(),
                    ),
                  ],
                ),
              ),

             // const SizedBox(height: 20),
              //////////////////////////////////////////////////////////////////////////////////////////////////////////
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:  const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Events",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                          GestureDetector(
                            onTapDown: (_) {
                              setState(() {
                                _isTapped5 = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                _isTapped5 = false;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Events(),
                                ),
                              );
                            },
                            onTapCancel: () {
                              setState(() {
                                _isTapped5 = false;
                              });
                            },
                            child: Text(
                              "Show more",
                              style: TextStyle(
                                color: _isTapped5
                                    ? const Color.fromRGBO(255, 193, 7, 0.8)
                                    : const Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child:  eventhorizontal(),
                    ),
                  ],
                ),
              ),

              //const SizedBox(height: 20),
              //////////////////////////////////////////////////////////////////////////////////////////////////////////
             Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:  const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "local sevices",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                          GestureDetector(
                            onTapDown: (_) {
                              setState(() {
                                _isTapped5 = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                _isTapped5 = false;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LocalServices(),
                                ),
                              );
                            },
                            onTapCancel: () {
                              setState(() {
                                _isTapped5 = false;
                              });
                            },
                            child: Text(
                              "Show more",
                              style: TextStyle(
                                color: _isTapped5
                                    ? const Color.fromRGBO(255, 193, 7, 0.8)
                                    : const Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: localhoizontal(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


class MyCarousel extends StatelessWidget {
  final List<String> assetImagePaths = [
    'assets/plane2.png',
    'assets/rbus.png',
    'assets/Dj.png',
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: assetImagePaths.map((imagePath) {
        return GestureDetector(
          onTap: () {
            // Handle tap if needed
          },
          child: Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 180,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
