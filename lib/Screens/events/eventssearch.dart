
import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/Screens/payments/payment.dart';
import 'package:bookify/services/eventservices.dart';
import 'package:flutter/material.dart';

import 'event_details.dart';

class Eventssearch extends StatefulWidget {
  final String category;
  final String date;

  const Eventssearch({
    super.key,
    required this.category,
    required this.date,
  });
  //const Eventssearch({super.key});


  @override
  State<Eventssearch> createState() => _EventssearchState();
}

class _EventssearchState extends State<Eventssearch> {
   final TextStyle whiteTextStyle = TextStyle(color: Colors.white);
   late Future<List<Eventmodel>> futureevents;
  

   @override
  void initState() {
    super.initState();
    futureevents = EventService().fetchevents();
  }
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
                child: Text(widget.category, style: whiteTextStyle),//will get data by navigaotr .push
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(widget.date, style: whiteTextStyle,),
              ),
              SizedBox(height: 20),
             Expanded(
       
               child:FutureBuilder(future: futureevents,
                builder: (context,snapshot)
                {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No events available'));
                    }

                    final filtered = snapshot.data!.where((events) =>
                      events.category==widget.category.toLowerCase()&&
                      events.date == widget.date).toList();
                     if (filtered.isEmpty) {
                      
                      return Center(child: Text("No matching events for your search."));
                    }
                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder:(context,index)
                      {
                        final event=filtered[index];
                        return buildeventcard(artist: event.artist,eventname: event.eventname,eventid: event.id,
                         place: event.place, time: event.time, imagePath: "assets/flight.jpg", mycontext: context);
                      }
                    );
                },
                )
               ),
      
             
              
              ],
              
              )

              ),
              ),
              );
  }
}





Widget buildeventcard({
  required String artist,
  required String place,
  required String eventname,
  required String time,
  required String imagePath,
  required String eventid,
  required BuildContext mycontext,
}
)
{
 return GestureDetector(
   onTap: (){
     Navigator.push(mycontext, MaterialPageRoute(builder: (mycontext)=>EventBookingPage(eventid: eventid,)));
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
                width: 100,
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
                      eventname,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                    artist,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                    if (place.isNotEmpty)
                      Text(
                        place,
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
                  Navigator.push(mycontext, MaterialPageRoute(builder: (mycontext) => EventBookingPage(eventid: eventid,),),);
                },
                child: Text('Select'),
              ),
            )
          ],
        ),
      ),
 );
}