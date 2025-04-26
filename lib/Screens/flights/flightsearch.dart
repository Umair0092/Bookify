import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/Screens/flights/buildcard.dart';
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
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
                  'Search Flights',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
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
                      logoPath: 'flight.jpg',
                      title: 'NEW York',
                      time: '9:00 AM',
                      route: 'JFK → LAX',
                      duration: '6h20 min',
                      airline: 'Arrecrian Airlines',
                    ),
                  Buildcard(
                      logoPath: 'flight.jpg',
                      title: 'Delta',
                      time: '1:00 PM',
                      route: 'JFK → SFO',
                      duration: '6h20 min',
                      airline: 'Greyhound',
                    ),
                    Buildcard(
                      logoPath: 'flight.jpg',
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
