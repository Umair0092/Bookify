import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../payments/payment.dart';



class BusBookingPage extends StatefulWidget {
  final String busId;

  const BusBookingPage({super.key, required this.busId});
  @override
  _BusBookingPageState createState() => _BusBookingPageState();
}

class _BusBookingPageState extends State<BusBookingPage> {
   int _ticketCount = 1;
  double _singleTicketCost = 0.0;
  String title = "";
  double totalticket=0;
  String from="";
  String to="";
  String time="";
  List<dynamic> facilities = [];
@override
  void initState() {
    super.initState();
    _fetchBusDetails();
  }
Future<void> _fetchBusDetails() async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('bus').doc(widget.busId).get();
    if (doc.exists) {
      setState(() {
        title = doc['title'] ?? '';
        from=doc['FROM'] ?? '';
        to=doc['TO'] ?? '';
        totalticket=(doc['tickets'] as num?)?.toDouble() ?? 0.0;
       // print(totalticket);
        _singleTicketCost = (doc['ticketcost'] as num?)?.toDouble() ?? 0.0;
        facilities = doc['facilities'] ?? [];
        time=doc['time']??'';
      });
    }
  }
  void _incrementTickets() {
   if (_ticketCount <totalticket) {
      setState(() {
        _ticketCount++;
      });
    }
    
    
  }

  void _decrementTickets() {
    if (_ticketCount > 1) {
      setState(() {
        _ticketCount--;
      });
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalCost = _singleTicketCost * _ticketCount; // Calculate total cost

    return Scaffold(
      appBar: AppBar(
        title: Text("Bus Booking",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        backgroundColor:Color(0xFFFFD700),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bus Images Section (Circular Layout)
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
                        border: Border.all(color: Colors.blue, style: BorderStyle.solid, width: 2),
                      ),
                    ),
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage('https://plus.unsplash.com/premium_photo-1664302152991-d013ff125f3f?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage('https://plus.unsplash.com/premium_photo-1664302152991-d013ff125f3f?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage('https://plus.unsplash.com/premium_photo-1664302152991-d013ff125f3f?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage('https://plus.unsplash.com/premium_photo-1664302152991-d013ff125f3f?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Facilities Section
              Text(
                "Bus Details",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "Bus operator: $title",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              
              Text(
                "From: $from   ($time)",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                "To: $to",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              
              SizedBox(height: 10),
              Text("Facilities", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ...facilities.map((f) => FacilityCard(
                    icon: Icons.check_circle_outline,
                    title: f,
                    description: '',
                  )),
              SizedBox(height: 20),
              // Ticket Quantity Selector
              Text(
                "Number of Tickets",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5,),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Available Tickets:",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    "${totalticket - _ticketCount}",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: Icon(Icons.remove), onPressed: _decrementTickets),
                  Text("$_ticketCount", style: TextStyle(fontSize: 20)),
                  IconButton(icon: Icon(Icons.add), onPressed: _incrementTickets),
                ],
              ),
              SizedBox(height: 20),
              // Cost Information Section
              Text(
                "Cost Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Cost per Ticket:", style: TextStyle(fontSize: 18)),
                  Text("${_singleTicketCost.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 5),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Cost:", style: TextStyle(fontSize: 18)),
                  Text("${totalCost.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 20),
              // Book Now Button
              Center(
                child: ElevatedButton(
                  onPressed: _showConfirmationDialog,
                  child: Text("Book Now",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD700),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
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
            Icon(_getIconFromName(title), size: 30, color: Colors.green),
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
 IconData _getIconFromName(String iconName) {
    print(iconName);
    switch (iconName.toLowerCase()) {
      case 'wifi':
        //print("wifi");
        return Icons.wifi;
      case 'reclining seats':
        return Icons.event_seat;
      case 'air conditioning':
        //print("air");
        return Icons.ac_unit_sharp;
      default:
        return Icons.info;
    }
  }
