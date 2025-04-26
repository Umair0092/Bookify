
import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/Screens/payments/payment.dart';
import 'package:flutter/material.dart';

import 'event_details.dart';

class Eventssearch extends StatefulWidget {
  const Eventssearch({super.key});

  @override
  State<Eventssearch> createState() => _EventssearchState();
}

class _EventssearchState extends State<Eventssearch> {
   final TextStyle whiteTextStyle = TextStyle(color: Colors.white);
  final List<Map<String, String>> events = [
    {
      'artist': 'Coldplay',
      'tour': 'Music of Spriieres Tour',
      'time': '7:00 PM',
      'image': 'assets/bus.jpg',
    },
    {
      'artist': 'Ed Sheeran',
      'tour': '',
      'time': '6:00 PM',
      'image': 'assets/flight.jpg',
    },
    {
      'artist': 'Billie Eilish',
      'tour': '',
      'time': '9:00 PM',
      'image': 'assets/flight.jpg',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
                  'Search Events',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      //backgroundColor: backgroundColor,
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('Location', style: whiteTextStyle),//will get data by navigaotr .push
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
       
        child: ListView.builder(
          // padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return buildeventcard(
              artist: event['artist']!,
              tour: event['tour']!,
              time: event['time']!,
              imagePath: event['image']!,
              mycontext: context,
            );
          },
        ),),
      
             
              
              ],
              
              )

              ),
              ),
              );
  }
}





Widget buildeventcard({
  required String artist,
  required String tour,
  required String time,
  required String imagePath,
  required BuildContext mycontext,
}
)
{
 return GestureDetector(
   onTap: (){
     Navigator.push(mycontext, MaterialPageRoute(builder: (mycontext)=>EventBookingPage()));
   },
   child: Card(
        color: Colors.grey[900],
        margin: const EdgeInsets.only(bottom: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
              child: Image.asset(
                imagePath,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artist,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (tour.isNotEmpty)
                      Text(
                        tour,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    SizedBox(height: 8),
                    Text(
                      time,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(mycontext, MaterialPageRoute(builder: (mycontext) => PaymentPage(),),);
                },
                child: Text('Select'),
              ),
            )
          ],
        ),
      ),
 );
}