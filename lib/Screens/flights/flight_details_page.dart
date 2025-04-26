import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../Home.dart';
import '../payments/payment.dart';

class FlightBookingPage extends StatefulWidget {
  @override
  _FlightBookingPageState createState() => _FlightBookingPageState();
}

class _FlightBookingPageState extends State<FlightBookingPage> {
  int _ticketCount = 1;
  int total_seats=5;

  final double _singleTicketCost = 150.0; // Cost of a single ticket in dollars
  @override
  void initState() {
    // TODO: implement initState

  }
  void _incrementTickets() {
    if(total_seats>_ticketCount){
    setState(() {
    _ticketCount++;
    });
    }
    else{
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Max of $_ticketCount tickets! can be Booked",style: TextStyle(color: Colors.black),) ,margin: EdgeInsets.fromLTRB(20, 50, 20,20 ),behavior: SnackBarBehavior. floating,backgroundColor: Color(0xFFFFD700).withOpacity(0.9),),
        );
      });

    }
  }

  void Show_Dialog(){
    showDialog(context: context, builder: (BuildContext context){
       return AlertDialog(
        title: Text("Confirm Booking"),
        content: Text("Are you sure you want to book $_ticketCount ticket(s)?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width/1.5,
              padding: EdgeInsets.symmetric(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFFFD700),
              ),
              child: Center(child: Text("Cancel ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PaymentPage())); // Close the dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Booking confirmed for $_ticketCount ticket(s)!",style: TextStyle(color: Colors.black),) ,margin: EdgeInsets.fromLTRB(20, 50, 20,20 ),behavior: SnackBarBehavior. floating,backgroundColor: Color(0xFFFFD700).withOpacity(0.9),),
              );
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width/1.5,
              padding: EdgeInsets.symmetric(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFFFD700),
              ),
              child: Center(child: Text("Confirm ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),)),
            ),
          ),
        ],
      );

    });

  }

  void _decrementTickets() {
    if (_ticketCount > 1) {
      setState(() {
         _ticketCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    double totalCost = _singleTicketCost * _ticketCount; // Calculate total cost

    return Scaffold(
      appBar: AppBar(
        title: Text("Flight Booking",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        foregroundColor: Colors.black,
        backgroundColor: Color(0xFFFFD700),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plane Images Section (Circular Layout)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 70,vertical: 10),
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color:  Color(0xFFFFD700), style: BorderStyle.solid, width: 2),

                      ),
                    ),
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(                            "https://plus.unsplash.com/premium_photo-1742945845688-7c11c2f6d33d?q=80&w=1518&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(                            "https://plus.unsplash.com/premium_photo-1742945845688-7c11c2f6d33d?q=80&w=1518&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(                            "https://plus.unsplash.com/premium_photo-1742945845688-7c11c2f6d33d?q=80&w=1518&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(                            "https://plus.unsplash.com/premium_photo-1742945845688-7c11c2f6d33d?q=80&w=1518&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Facilities Section
              Text(
                "Facilities",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              FacilityCard(
                icon: Icons.wifi,
                title: "Free Wi-Fi",
                description: "Stay connected with high-speed internet on board.",
              ),
              FacilityCard(
                icon: Icons.fastfood,
                title: "In-Flight Meals",
                description: "Enjoy a variety of meals and snacks during your flight.",
              ),
              FacilityCard(
                icon: Icons.event_seat,
                title: "Comfortable Seating",
                description: "Spacious seats with extra legroom for your comfort.",
              ),
              SizedBox(height: 20),
              // Ticket Quantity Selector
              Text(
                "Number of Tickets",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Available Ticket:",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "${(total_seats-_ticketCount)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove,color: Color(0xFFFFD700),),
                    onPressed: _decrementTickets,
                  ),
                  Text(
                    "$_ticketCount",
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    icon: Icon(Icons.add,color: Color(0xFFFFD700),),
                    onPressed: _incrementTickets,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Cost Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cost per Ticket:",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "\$${_singleTicketCost.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Cost:",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "\$${totalCost.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Book Now Button
              Center(
                child: ElevatedButton(
                  onPressed:
                    Show_Dialog
                  ,
                  child: Text("Book Now",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                    backgroundColor: Color(0xFFFFD700),
                  ),
                ),
              ),
              SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}

class FacilityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  FacilityCard({required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Color(0xFFFFD700)),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}