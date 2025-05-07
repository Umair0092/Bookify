import 'package:bookify/Screens/bus/Buses_Detais.dart';
import 'package:bookify/services/busservice.dart';
import 'package:flutter/material.dart';

class Bushomepagecard extends StatefulWidget {
  final String from;
  final String to;
  final String date;
  final String time;
  final String id;
  final int cost;
  const Bushomepagecard({super.key, required this.from, required this.to, required this.date, required this.time, required this.id, required this.cost});

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
      child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
         Container(
            height: 140,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bus2.png"),
                fit: BoxFit.fill,
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
              "${widget.cost}\$",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 16,
            child: Text(
             "${widget.from}->${widget.to}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          if (widget.date.isNotEmpty)
            Positioned(
              bottom: 12,
              left: 16,
              child: Text(
                widget.date,
                style: TextStyle(color: Colors.white),
              ),
            ),
           Positioned(
            bottom: 12,
            right: 16,
            child: Text(
              widget.time,
              style: TextStyle(
               // fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    )
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
          print(snapshot.error);
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
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final bus = buses[index];
              return Container(
                width: 220,
                margin: EdgeInsets.only(right: 8),
                child: Bushomepagecard(
                  id:bus.id,
                  from: bus.from,
                  to: bus.to,
                  date: bus.date,
                  time: bus.time,
                  cost:bus.ticketcost
                ),
              );
            },
          ),
        );
      },
    );
  }
}