
import 'package:flutter/material.dart';

import 'flight_details_page.dart';
import 'flights.dart';

class Buildcard extends StatelessWidget {
  final String logoPath;
  final String title;
  final String route;
  final String time;
  final String duration;
  final String airline;
  const Buildcard({super.key,
  required this.logoPath, required this.title, required  this.route,
  required  this.time, required this.duration,required  this.airline
  });

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>FlightBookingPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(logoPath),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(route, style: TextStyle(color: Colors.white70)),
                    Text(airline, style: TextStyle(color: Colors.white60)),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(time, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(duration, style: TextStyle(color: Colors.white70)),
                SizedBox(height: 4),

              ],
            )
          ],
        ),
      ),
    );
  }
}

