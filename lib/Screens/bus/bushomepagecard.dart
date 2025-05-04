import 'package:bookify/Screens/bus/Buses_Detais.dart';
import 'package:bookify/services/busservice.dart';
import 'package:flutter/material.dart';

class Bushomepagecard extends StatefulWidget {
  final String from;
  final String to;
  final String date;
  final String time;
  final String id;
  const Bushomepagecard({super.key, required this.from, required this.to, required this.date, required this.time, required this.id});

  @override
  State<Bushomepagecard> createState() => _BushomepagecardState();
}

class _BushomepagecardState extends State<Bushomepagecard> {
  @override
  Widget build(BuildContext context) {
      return InkWell(
      onTap: () {
        Navigator.push(context,
        MaterialPageRoute(builder: (context)=>BusBookingPage(busId:widget.id)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 2.0,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                "https://plus.unsplash.com/premium_photo-1683120929511-af05758ec1e5?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Image.asset(
                    "images/img1.jpg",
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  15,
                  10,
                  10,
                  10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.5),
                      Color.fromRGBO(255, 234, 0, 1),
                    ],
                    end: Alignment.topLeft,
                    begin: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                    "${widget.from}->${widget.to}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Text(
                          widget.date,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.time,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class BusHorizontalList extends StatelessWidget {
  final BusService _busService = BusService();

  BusHorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Busmodel>>(
      future: _busService.fetchBuses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading buses'));
        }

        final buses = snapshot.data ?? [];

        if (buses.isEmpty) {
          return Center(child: Text('No buses found'));
        }

        return SizedBox(
          height: 130, // Enough height for horizontal cards
          child: ListView.builder(
            itemCount: buses.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final bus = buses[index];
              return Container(
                width: 220,
                //margin: EdgeInsets.only(right: 12),
                child: Bushomepagecard(
                  id:bus.id,
                  from: bus.from,
                  to: bus.to,
                  date: bus.date,
                  time: bus.time,
                ),
              );
            },
          ),
        );
      },
    );
  }
}