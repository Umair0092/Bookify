import 'package:bookify/Screens/events/event_details.dart';
import 'package:bookify/services/eventservices.dart';
import 'package:flutter/material.dart';

class Eventcard extends StatefulWidget {
  final String eventname;
  final String time ;
  final String date;
  final String id;
final String cat;
  final int price;
  const Eventcard({super.key, required this.eventname, required this.time, required this.date, required this.id, required this.price, required this.cat});

  @override
  State<Eventcard> createState() => _EventcardState();
}

class _EventcardState extends State<Eventcard> {
  AssetImage _getEventImage(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'sports':
        return AssetImage('assets/stadium.png');
      case 'concert':
        return AssetImage('assets/Dj.png');
      default:
        return AssetImage('assets/events.jpg');
    }
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
        MaterialPageRoute(builder: (context)=>EventBookingPage(eventid: widget.id))
        );
      },
      child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
         Container(
            height: 140,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _getEventImage(widget.cat), 
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
              "${widget.price}\$",
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
              widget.eventname,
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


// ignore: camel_case_types
class eventhorizontal extends StatelessWidget {
  final EventService evetserv = EventService();

  eventhorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Eventmodel>>(
      future: evetserv.fetchevents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading event'));
        }

        final event = snapshot.data ?? [];

        if (event.isEmpty) {
          return Center(child: Text('No event found'));
        }

        return SizedBox(
          height: 150, // Enough height for horizontal cards
          child: ListView.builder(
            itemCount: event.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final even = event[index];
              return Container(
                width: 220,
                margin: EdgeInsets.only(left: 12),
                child: Eventcard(
                  id:even.id,
                  eventname:even.eventname,
                  date: even.date,
                  time: even.time,
                  price: even.cost,
                  
                  cat:even.category,
                ),
              );
            },
          ),
        );
      },
    );
  }
}