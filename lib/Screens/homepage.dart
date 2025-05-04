import 'package:bookify/Screens/bus/bus.dart';
import 'package:bookify/Screens/bus/bushomepagecard.dart';
import 'package:bookify/Screens/events/eventhomepagecar.dart';
import 'package:bookify/Screens/events/events.dart';
import 'package:bookify/Screens/flights/flights.dart';
import 'package:bookify/Screens/localservice/localservices.dart';
import 'package:bookify/Screens/localservice/locservcar.dart';
import 'package:bookify/services/flights.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
  late List<Flight> _flights;
  bool _isLoading = false;
  Future<void> flightsdata() async {
    setState(() {
      _isLoading = true;
    });
    _flights = await Fectchdata.fetchFlightData();
    print(_flights[0].servicesOffered.toString());
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("fligt data");
    flightsdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

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
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Hello Name 😀\nHow are you Today",
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
              CarouselSlider(
                items: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: NetworkImage(
                            "https://plus.unsplash.com/premium_photo-1742945845688-7c11c2f6d33d?q=80&w=1518&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
                options: CarouselOptions(
                  height: 180,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.horizontal,
                ),
              ),
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
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
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
                                builder: (context) => Flightsearch(),
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
                              color:
                                  _isTapped5
                                      ? const Color.fromRGBO(255, 193, 7, 0.8)
                                      : const Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.27,

                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _flights.isEmpty
                          ? const Center(child: Text('No flights available'))
                          : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            scrollDirection: Axis.horizontal,
                            itemCount: _flights.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final flight = _flights[index];
                              return SizedBox(
                                height: MediaQuery.of(context).size.height * 0.27,
                                width: MediaQuery.of(context).size.width * 0.9,// Dynamic height
                                child: FlightCard(
                                  flight: flight,
                                  onBookNow: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>FlightBookingPage(flight: flight,)));
                                    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => BookingScreen(flight: flight)));
                                  },
                                ),
                              );
                            },
                          ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              //////////////////////////////////////////////////////////////////////////////////////////////////////////
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Buses",
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
                            print("Show more tapped!");
                          },
                          onTapCancel: () {
                            setState(() {
                              _isTapped5 = false;
                            });
                          },
                          child: Text(
                            "Show more",
                            style: TextStyle(
                              color:
                                  _isTapped5
                                      ? const Color.fromRGBO(255, 193, 7, 0.8)
                                      : const Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                   // const SizedBox(height: 10),
                    Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        BusHorizontalList(),
                      ],
                    ),),
                    //const SizedBox(height: 10),
                  ],
                ),
              ),
             // const SizedBox(height: 20),
              //////////////////////////////////////////////////////////////////////////////////////////////////////////
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
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
                              ),);
                            print("Show more tapped!");
                          },
                          onTapCancel: () {
                            setState(() {
                              _isTapped5 = false;
                            });
                          },
                          child: Text(
                            "Show more",
                            style: TextStyle(
                              color:
                                  _isTapped5
                                      ? const Color.fromRGBO(255, 193, 7, 0.8)
                                      : const Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //const SizedBox(height: 10),
                     Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        eventhorizontal(),
                      ],
                    ),),
                    //const SizedBox(height: 10),
                  ],
                ),
              ),
              //const SizedBox(height: 20),
              //////////////////////////////////////////////////////////////////////////////////////////////////////////
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Services",
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
                            print("Show more tapped!");
                          },
                          onTapCancel: () {
                            setState(() {
                              _isTapped5 = false;
                            });
                          },
                          child: Text(
                            "Show more",
                            style: TextStyle(
                              color:
                                  _isTapped5
                                      ? const Color.fromRGBO(255, 193, 7, 0.8)
                                      : const Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                     Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        localhoizontal(),
                      ],
                    ),),
                    const SizedBox(height: 10),
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
