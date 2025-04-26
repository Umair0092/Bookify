import 'package:bookify/Screens/Colors.dart';
import 'package:flutter/material.dart';

import 'Buses_Detais.dart';

//import 'package:book/ui/colors.dart';



class Bussearch extends StatefulWidget {
  const Bussearch({super.key});

  @override
  State<Bussearch> createState() => _BussearchState();
}

class _BussearchState extends State<Bussearch> {
 final TextStyle whiteTextStyle = TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
                  'Search Buses',
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
                   buildFlightCard(
                     
                      title: 'NEW York',
                      time: '9:00 AM',
                      route: 'Washington',
                      duration: '6h20 min',
                      date: 'April 24, 2024',
                     context: context
                    ),
                  buildFlightCard(
                      
                      title: 'Delta',
                      time: '1:00 PM',
                      route: 'Boston',
                      duration: '6h20 min',
                     date:'April 24, 2024',
                      context: context
                    ),
                    buildFlightCard(
                    
                      title: 'United',
                      time: '4:30 PM',
                      route: 'New York',
                      duration: '6h20 min',
                      date: 'April 24, 2024',
                        context: context
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



Widget buildFlightCard({
  
    required String title,
    required String time,
    required String route,
    required String duration,
    required String date,
    required  context,
  }) {
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>BusBookingPage()));
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

                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(route, style: TextStyle(color: Colors.white70)),
                    Text(date, style: TextStyle(color: Colors.white60)),
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