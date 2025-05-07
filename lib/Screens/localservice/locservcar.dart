
import 'package:bookify/Screens/localservice/servicebooking.dart';
import 'package:bookify/services/localservice.dart';
import 'package:flutter/material.dart';

class localcar extends StatelessWidget {
  final String id;
  final List<dynamic> services;
 // final rating
 final List<dynamic> time;
  final int cost;
  final int rating;
  //String serv;

  const localcar({
    super.key,
    required this.id,
    required this.services,
    //required this.rating,
    required this.cost,
    required this.rating, required this.time
  });

  AssetImage _getEventImage(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'sports':
        return AssetImage('assets/sports.jpeg');
      case 'concert':
        return AssetImage('assets/concert.jpeg');
      default:
        return AssetImage('assets/events.jpg');
    }
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
        MaterialPageRoute(builder: (context)=>Servicebooking(
              companyName: id, // Using the id as company name
              availableTimes: time.map((t) => t.toString()).toList(),
              rate: cost,
              serv: services.last,
            ),

        )
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
                image: _getEventImage(services.first), 
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
              "$cost\$",
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
             services.isNotEmpty ? services.last : 'Service',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom:50,
            left: 16,
            child: Text(
             id,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          
           Positioned(
            bottom: 12,
            left: 16,
            child:Row(
              children: [
                Row(
                  children: List.generate(5, (starIndex) {
                    return Icon(
                      Icons.star,
                      color: starIndex < rating ? Colors.yellow : Colors.grey,
                      size: 20,
                    );
                  }),
                ),]
            ),
          ),
        ],
      ),
    )
    );
  }
}



class localhoizontal extends StatelessWidget {
  final Localserv localser = Localserv();

  localhoizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<localServicemodel>>(
      future: localser.fetchlocal(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading services'));
        }

        final servi = snapshot.data ?? [];

        if (servi.isEmpty) {
          return Center(child: Text('No service found'));
        }

        return SizedBox(
          height: 130,
          child: ListView.builder(
            itemCount: servi.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final serv = servi[index];
              return Container(
                width: 220,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: localcar(
                  id: serv.id,
                  services: serv.services,
                  //time: serv.time,
                  cost: serv.cost,
                  
                  rating: serv.rating, time: serv.time,
                  
                ),
              );
            },
  ),
);

      },
    );
  }
}