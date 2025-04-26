import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/Screens/Home.dart';
import 'package:bookify/Screens/flights/buildcard.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class Flightsearch extends StatefulWidget {
  const Flightsearch({super.key});

  @override
  State<Flightsearch> createState() => _FlightsearchState();
}

class _FlightsearchState extends State<Flightsearch> {
  final TextStyle whiteTextStyle = TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Color(0xFFFFD700),
        color: Colors.black,
        activeColor: Colors.black,
        height: 66,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.map, title: 'Discover'),
          TabItem(icon: Icons.add, title: 'Add'),
          TabItem(icon: Icons.message, title: 'Message'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        onTap: (int i) => {
          if(i==0){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>home()))
          }
        },
      ),
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Search Flights',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('From', style: whiteTextStyle),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('To', style: whiteTextStyle),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('April 24, 2024', style: whiteTextStyle),
              ),
              SizedBox(height: 20),
               Expanded(
                child: ListView(
                  children: [
                   Buildcard(
                      logoPath: 'assets/flight.jpg',
                      title: 'NEW York',
                      time: '9:00 AM',
                      route: 'JFK → LAX',
                      duration: '6h20 min',
                      airline: 'Arrecrian Airlines',
                    ),
                  Buildcard(
                      logoPath: 'assets/flight.jpg',
                      title: 'Delta',
                      time: '1:00 PM',
                      route: 'JFK → SFO',
                      duration: '6h20 min',
                      airline: 'Greyhound',
                    ),
                    Buildcard(
                      logoPath: 'assets/flight.jpg',
                      title: 'United',
                      time: '4:30 PM',
                      route: 'JFK → ORD',
                      duration: '6h20 min',
                      airline: 'FlixBus',
                    ),
                  ],
                ),
              )
             
            ],
          ),
        ),
      
    ),);
  }
}
