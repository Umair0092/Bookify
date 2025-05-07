import 'package:bookify/Screens/flights/flight_details_page.dart';
import 'package:flutter/material.dart';

import 'package:bookify/services/flights.dart';

class Flighthomepagecard extends StatelessWidget {
 final Flight flight;

  const Flighthomepagecard({super.key, required this.flight});

  @override
    @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightBookingPage(flight: flight),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Container(
              height: 140,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(flight.image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    blurStyle: BlurStyle.normal,
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
            Container(
              height: 130,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Text(
                "\$${flight.price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top:56,
              left: 16,
              child: Text(
                flight.airline,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 16,
              child: Text(
                "${flight.departureCity} ➝ ${flight.destinationCity}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 16,
              child: Text(
                "${flight.departureTime.toLocal().toString().substring(0, 16)}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}


class FlightHorizontalList extends StatelessWidget {
  const FlightHorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Flight>>(
      future: Fectchdata.fetchFlightData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading flights'));
        }

        final flights = snapshot.data ?? [];

        if (flights.isEmpty) {
          return const Center(child: Text('No flights found'));
        }

        return SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: flights.length,
            itemBuilder: (context, index) {
              final flight = flights[index];
              return Container(
                width: 220,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: Flighthomepagecard(
                 flight: flight,
                ),
              );
            },
          ),
        );
      },
    );
  }
}