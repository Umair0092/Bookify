import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'Colors.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  bool _isTapped = false;
  bool _isTapped2 = false;
  bool _isTapped3 = false;
  bool _isTapped4 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Color.fromRGBO(255, 193, 7, 1),
        color: Colors.black,
        activeColor: Colors.black,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.map, title: 'Discovery'),
          TabItem(icon: Icons.add, title: 'Add'),
          TabItem(icon: Icons.message, title: 'Message'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        onTap: (int i) => print('click index=$i'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Hello Name 😀\nHow are you Today",
                        style: TextStyle(color: white),
                      ),
                    ),
                    Icon(
                      Icons.notifications,
                      color: Color.fromRGBO(255, 193, 7, 1),
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
                        image: DecorationImage(
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
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              SizedBox(height: 20),
              Container(
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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

                      print("Forgot Password tapped!");
                    },
                    onTapCancel: () {
                      setState(() {
                        _isTapped = false;
                      });
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                       color:  _isTapped
                            ? Color.fromRGBO(255, 193, 7, 0.8)
                            : Color.fromRGBO(255, 193, 7, 1),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.flight, color: Colors.black, size: 50),
                          Text("Flights",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 30,),
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

                      print("Forgot Password tapped!");
                    },
                    onTapCancel: () {
                      setState(() {
                        _isTapped2 = false;
                      });
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                       color:  _isTapped2
                            ? Color.fromRGBO(255, 193, 7, 0.8)
                            : Color.fromRGBO(255, 193, 7, 1),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.directions_bus_filled, color: Colors.black, size: 50),
                          Text("Buses",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isTapped3 = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _isTapped3 = false;
                      });

                      print("Forgot Password tapped!");
                    },
                    onTapCancel: () {
                      setState(() {
                        _isTapped3 = false;
                      });
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color:  _isTapped3
                              ? Color.fromRGBO(255, 193, 7, 0.8)
                              : Color.fromRGBO(255, 193, 7, 1),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.design_services, color: Colors.black, size: 50),
                          Text("Services",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 30,),
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isTapped4 = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _isTapped4 = false;
                      });

                      print("Forgot Password tapped!");
                    },
                    onTapCancel: () {
                      setState(() {
                        _isTapped4 = false;
                      });
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color:  _isTapped4
                              ? Color.fromRGBO(255, 193, 7, 0.8)
                              : Color.fromRGBO(255, 193, 7, 1),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event, color: Colors.black, size: 50),
                          Text("Events",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                child:Column(
                  children: [

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
