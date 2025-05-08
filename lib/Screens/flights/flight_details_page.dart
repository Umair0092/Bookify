import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import '../../services/flights.dart';
import '../Home.dart';
import 'paymentsflights.dart';


class FlightBookingPage extends StatefulWidget {
  final Flight flight;

  const FlightBookingPage({Key? key, required this.flight}) : super(key: key);

  @override
  _FlightBookingPageState createState() => _FlightBookingPageState();
}

class _FlightBookingPageState extends State<FlightBookingPage> {
  late int _ticketCount;
  late int total_seats;

  final double _singleTicketCost = 150.0; // Default cost if flight.price is not set

  @override
  void initState() {
    super.initState();
    _ticketCount = 0;
    total_seats = widget.flight.availableSeats;
  }

  void _incrementTickets() {
    if (total_seats > _ticketCount) {
      setState(() {
        _ticketCount++;
      });
    } else {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Max of $_ticketCount tickets can be booked!",
                style: TextStyle(color: Colors.black)),
            margin: EdgeInsets.fromLTRB(20, 50, 20, 20),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFFFFD700).withOpacity(0.9),
          ),
        );
      });
    }
  }

  void _showDialog(Flight flight,int numTickets) {
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
                width: MediaQuery.of(context).size.width / 1.5,
                padding: EdgeInsets.symmetric(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFFFD700),
                ),
                child: Center(
                  child: Text("Cancel",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => PaymentPage(flight: flight,numberOfPassengers: numTickets,)));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Booking confirmed for $_ticketCount ticket(s)!",
                        style: TextStyle(color: Colors.black)),
                    margin: EdgeInsets.fromLTRB(20, 50, 20, 20),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Color(0xFFFFD700).withOpacity(0.9),
                  ),
                );
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 1.5,
                padding: EdgeInsets.symmetric(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFFFD700),
                ),
                child: Center(
                  child: Text("Confirm",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
              ),
            ),
          ],
        );
      },
    );
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
    double totalCost = widget.flight.price != 0.0
        ? widget.flight.price * _ticketCount
        : _singleTicketCost * _ticketCount; // Use flight price if available

    return Scaffold(
      appBar: AppBar(
        title: Text("Flight Booking",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                margin: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Color(0xFFFFD700),
                            style: BorderStyle.solid,
                            width: 2),
                      ),
                    ),
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(widget.flight.image),
                      onBackgroundImageError: (exception, stackTrace) =>
                          Icon(Icons.error),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            widget.flight.image2 ?? widget.flight.image),
                        onBackgroundImageError: (exception, stackTrace) =>
                            Icon(Icons.error),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            widget.flight.image3 ?? widget.flight.image),
                        onBackgroundImageError: (exception, stackTrace) =>
                            Icon(Icons.error),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            widget.flight.image ?? widget.flight.image2),
                        onBackgroundImageError: (exception, stackTrace) =>
                            Icon(Icons.error),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Flight Details
              Text(
                "Flight Details",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "Flight Number: ${widget.flight.flightNumber}",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                "Airline: ${widget.flight.airline}",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                "From: ${widget.flight.departureCity} (${widget.flight.departureTime.toLocal().toString().split(' ')[0]})",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                "To: ${widget.flight.destinationCity} (${widget.flight.arrivalTime.toLocal().toString().split(' ')[0]})",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 20),
              // Facilities Section
              Text(
                "Facilities",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              ...widget.flight.servicesOffered.map((service) => FacilityCard(
                icon: service.iconName.isNotEmpty
                    ? _getIconFromName(service.iconName)
                    : Icons.info,
                title: service.name,
                description: service.description,
              )),
              SizedBox(height: 20),
              // Ticket Quantity Selector
              Text(
                "Number of Tickets",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Available Tickets:",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    "${total_seats - _ticketCount}",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, color: Color(0xFFFFD700)),
                    onPressed: _decrementTickets,
                  ),
                  Text(
                    "$_ticketCount",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Color(0xFFFFD700)),
                    onPressed: _incrementTickets,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Cost Details",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cost per Ticket:",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    "\$${widget.flight.price.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Cost:",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    "\$${totalCost.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Book Now Button
              Center(
                child: ElevatedButton(
                  onPressed: (){
                    _showDialog(widget.flight,_ticketCount);
                  },
                  child: Text("Book Now",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
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

  IconData _getIconFromName(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'fastfood':
        return Icons.fastfood;
      case 'event_seat':
        return Icons.event_seat;
      default:
        return Icons.info;
    }
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
      color: Colors.grey[850],
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
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