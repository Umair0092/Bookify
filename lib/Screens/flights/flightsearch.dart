import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/Screens/Home.dart';
import 'package:bookify/Screens/flights/buildcard.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../../services/flights.dart';
import '../flights_cards.dart';
import 'flight_details_page.dart';

class Flightsearch extends StatefulWidget {
  const Flightsearch({super.key});

  @override
  State<Flightsearch> createState() => _FlightsearchState();
}

class _FlightsearchState extends State<Flightsearch> {
  final TextStyle whiteTextStyle = TextStyle(color: Colors.white);
  late List<Flight> _flights;
  bool _isLoading = false;
  Future<void> flightsdata() async {
    setState(() {
      _isLoading = true;
    });
    _flights = await Fectchdata.fetchFlightData();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flightsdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Color(0xFFFFD700),
        title: Text(
          'Search Flights',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.27,

                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _flights.isEmpty
                    ? const Center(child: Text('No flights available'))
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  //scrollDirection: Axis.vertical,
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

            ],
          ),
        ),
      
    ),);
  }
}
