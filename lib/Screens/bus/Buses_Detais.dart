import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Bus_payment.dart';

class BusBookingPage extends StatefulWidget {
  final String busId;

  const BusBookingPage({Key? key, required this.busId}) : super(key: key);

  @override
  _BusBookingPageState createState() => _BusBookingPageState();
}

class _BusBookingPageState extends State<BusBookingPage> {
  int _ticketCount = 1;
  double _singleTicketCost = 0.0;
  String title = "";
  int availableSeats = 0;
  String from = "";
  String to = "";
  DateTime departureTime = DateTime.now();
  String? duration;
  List<String> facilities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBusDetails();
  }

  Future<void> _fetchBusDetails() async {
    setState(() => isLoading = true);
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('bus')
          .doc(widget.busId)
          .get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          title = data['title'] as String? ?? '';
          from = data['FROM'] as String? ?? '';
          to = data['TO'] as String? ?? '';
          // Parse date and time to create departureTime
          String dateStr = data['date'] as String? ?? '15/5/2025'; // Default to current date if missing
          String timeStr = data['time'] as String? ?? '8:50AM'; // Default to a time if missing
          departureTime = _parseDateTime(dateStr, timeStr);
          _singleTicketCost = (data['ticketcost'] as num?)?.toDouble() ?? 0.0;
          availableSeats = (data['tickets'] as num?)?.toInt() ?? 0;
          duration = data['duration'] as String?;
          facilities = (data['facilities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
              [];
          isLoading = false;
        });
      } else {
        throw Exception('Bus document does not exist for ID: ${widget.busId}');
      }
    } catch (e) {
      print('Error fetching bus details: $e');
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load bus details: $e'),
          margin: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.withOpacity(0.9),
        ),
      );
    }
  }

  // Helper method to parse date and time into DateTime
  DateTime _parseDateTime(String dateStr, String timeStr) {
    try {
      // Parse date (e.g., "15/5/2025" to "2025-05-15")
      List<String> dateParts = dateStr.split('/');
      if (dateParts.length != 3) {
        throw FormatException('Invalid date format: $dateStr');
      }
      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      // Parse time (e.g., "8:50AM" to hours and minutes)
      String period = timeStr.contains('AM') || timeStr.contains('PM')
          ? timeStr.split(' ')[1]
          : '';
      String timePart = timeStr.split(' ')[0];
      List<String> timeParts = timePart.split(':');
      if (timeParts.length != 2) {
        throw FormatException('Invalid time format: $timeStr');
      }
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      // Adjust hour for AM/PM
      if (period.toUpperCase() == 'PM' && hour != 12) hour += 12;
      if (period.toUpperCase() == 'AM' && hour == 12) hour = 0;

      return DateTime(year, month, day, hour, minute);
    } catch (e) {
      print('Error parsing date/time: $e');
      return DateTime.now(); // Fallback to current time if parsing fails
    }
  }

  void _incrementTickets() {
    if (_ticketCount < availableSeats) {
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
          title: const Text("Confirm Booking"),
          content: Text("Are you sure you want to book $_ticketCount ticket(s)?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 1.5,
                padding: const EdgeInsets.symmetric(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFFFD700),
                ),
                child: const Center(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(
                      busId: widget.busId,
                      departureCity: from,
                      destinationCity: to,
                      departureTime: departureTime,
                      price: _singleTicketCost,
                      availableSeats: availableSeats,
                      duration: duration,
                      facilities: facilities,
                      numberOfPassengers: _ticketCount,
                    ),
                  ),
                );
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 1.5,
                padding: const EdgeInsets.symmetric(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFFFD700),
                ),
                child: const Center(
                  child: Text(
                    "Confirm",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalCost = _singleTicketCost * _ticketCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bus Booking",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFFD700),
        foregroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
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
                            color: Colors.blue, style: BorderStyle.solid, width: 2),
                      ),
                    ),
                    const CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(
                          'https://plus.unsplash.com/premium_photo-1664302152991-d013ff125f3f?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            'https://plus.unsplash.com/premium_photo-1664302152991-d013ff125f3f?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            'https://plus.unsplash.com/premium_photo-1664302152991-d013ff125f3f?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            'https://plus.unsplash.com/premium_photo-1664302152991-d013ff125f3f?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    "$from -> $to",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Departure: ${departureTime.toLocal().toString().split(' ')[0]} ${departureTime.toLocal().toString().split(' ')[1].substring(0, 5)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Facilities",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ...facilities.map((f) => FacilityCard(
                icon: Icons.check_circle_outline,
                title: f,
                description: '',
              )),
              const SizedBox(height: 20),
              const Text(
                "Number of Tickets",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: const Icon(Icons.remove), onPressed: _decrementTickets),
                  Text("$_ticketCount", style: const TextStyle(fontSize: 20)),
                  IconButton(
                      icon: const Icon(Icons.add), onPressed: _incrementTickets),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Cost Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Cost per Ticket:", style: TextStyle(fontSize: 18)),
                  Text(
                    "\$${_singleTicketCost.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Cost:", style: TextStyle(fontSize: 18)),
                  Text(
                    "\$${totalCost.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _showConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text(
                    "Book Now",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
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

  const FacilityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(_getIconFromName(title), size: 30, color: Colors.green),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'reclining seats':
        return Icons.event_seat;
      case 'air conditioning':
        return Icons.ac_unit_sharp;
      default:
        return Icons.info;
    }
  }
}