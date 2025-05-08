import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/eventservices.dart'; // Import Eventmodel
import 'events_payment.dart'; // Import PaymentPageEvent

class EventBookingPage extends StatefulWidget {
  final String eventid;

  const EventBookingPage({Key? key, required this.eventid}) : super(key: key);

  @override
  _EventBookingPageState createState() => _EventBookingPageState();
}

class _EventBookingPageState extends State<EventBookingPage> {
  int _ticketCount = 0;
  double _singleTicketCost = 0.0;
  int _availableTickets = 0;
  bool isLoading = true;
  Eventmodel? event;

  @override
  void initState() {
    super.initState();
    _fetcheventdetails();
  }

  Future<void> _fetcheventdetails() async {
    setState(() => isLoading = true);
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventid)
          .get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          event = Eventmodel.fromMap(data, widget.eventid);
          _singleTicketCost = event!.cost.toDouble();
          _availableTickets = event!.ticket;
          isLoading = false;
        });
      } else {
        throw Exception('Event document does not exist for ID: ${widget.eventid}');
      }
    } catch (e) {
      print('Error fetching event details: $e');
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load event details: $e'),
          margin: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.withOpacity(0.9),
        ),
      );
    }
  }

  void _incrementTickets() {
    if (_ticketCount < _availableTickets) {
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
  ImageProvider _getEventImage(String eventType) {
  switch (eventType.toLowerCase()) {
    case 'sports':
      return const AssetImage('assets/stadium.png');
    case 'concert':
      return const AssetImage('assets/Dj.png');
    default:
      return const AssetImage('assets/event.jpg');
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
                if (event == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Event details not loaded yet. Please try again.",
                        style: TextStyle(color: Colors.black),
                      ),
                      margin: EdgeInsets.fromLTRB(20, 50, 20, 20),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
                    ),
                  );
                  Navigator.of(context).pop(); // Close the dialog
                  return;
                }

                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PaymentPageEvent(
                      eventId: widget.eventid,
                      event: event!,
                      numberOfTickets: _ticketCount,
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Event Booking",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFFD700),
        foregroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : event == null
          ? const Center(
        child: Text(
          'Failed to load event details.',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Images Section (Circular Layout)
              Container(
                height: 250,
                margin: const EdgeInsets.symmetric(
                    horizontal: 70, vertical: 10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.blue,
                            style: BorderStyle.solid,
                            width: 2),
                      ),
                    ),
                                    CircleAvatar(
                    radius: 80,
                    backgroundImage: _getEventImage(event!.category), // returns ImageProvider
                  ),
                     Positioned(
                      top: 0,
                      left: 0,
                      child:  CircleAvatar(
                    radius: 30,
                    backgroundImage: _getEventImage(event!.category), // returns ImageProvider
                  ),
                    ),
                     Positioned(
                      top: 0,
                      right: 0,
                      child:  CircleAvatar(
                    radius: 30,
                    backgroundImage: _getEventImage(event!.category), // returns ImageProvider
                  ),
                    ),
                     Positioned(
                      bottom: 0,
                      left: 0,
                      child: CircleAvatar(
                    radius: 30,
                    backgroundImage: _getEventImage(event!.category), // returns ImageProvider
                  ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Event Details Section
              Center(
                child: Text(
                  event!.eventname,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'by ${event!.artist}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.category, color: Colors.white70, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    event!.category,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.white70, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    event!.place,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today, color: Colors.white70, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    '${event!.date} at ${event!.time}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Event Highlights Section
              const Text(
                "Event Highlights",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              ...event!.highlights.map((f) => HighlightCard(
                icon: Icons.check_circle_outline,
                title: f,
                description: '',
              )),
              const SizedBox(height: 20),
              // Ticket Quantity Selector
              const Text(
                "Number of Tickets",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Available Tickets:",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    "${_availableTickets - _ticketCount}",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.white),
                    onPressed: _decrementTickets,
                  ),
                  Text(
                    "$_ticketCount",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _incrementTickets,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Cost Information Section
              const Text(
                "Cost Details",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Cost per Ticket:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "\$${_singleTicketCost.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Cost:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "\$${totalCost.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Book Now Button
              Center(
                child: ElevatedButton(
                  onPressed: _showConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(
                    "Book Now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
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

class HighlightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const HighlightCard({
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
            Icon(
              _getIconFromName(title),
              size: 30,
              color: Colors.purple,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    getdesc(title),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
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
      case 'food & beverages':
        return Icons.local_dining;
      case 'vip experience':
        return Icons.stars_outlined;
      case 'live performance':
        return Icons.music_note_outlined;
      default:
        return Icons.info;
    }
  }

  String getdesc(String name) {
    switch (name.toLowerCase()) {
      case 'food & beverages':
        return "A variety of food stalls and drinks available.";
      case 'vip experience':
        return "Exclusive seating and special access for VIPs.";
      case 'live performance':
        return "Enjoy live music or thrilling sports action.";
      default:
        return "";
    }
  }
}