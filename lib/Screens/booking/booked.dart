import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/Screens/booking/summary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/tickets.dart'; // Import Ticket class

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  bool isBookedSelected = true; // Initially Booked is selected
  List<Ticket> bookedTickets = [];
  List<Ticket> historyTickets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  Future<void> _fetchTickets() async {
    setState(() => isLoading = true);
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User must be signed in to fetch tickets');
      }

      final tickets = await Ticket.fetchTickets();
      final now = DateTime.now();
      setState(() {
        bookedTickets = [];
        historyTickets = [];

        for (var ticket in tickets) {
          try {
            // Parse ticket time (e.g., "HH:MM" or "HH:MMAM/PM")
            String timeStr = ticket.time;
            int hour = 0;
            int minute = 0;
            if (timeStr.contains('AM') || timeStr.contains('PM')) {
              final period = timeStr.contains('AM') ? 'AM' : 'PM';
              timeStr = timeStr.replaceAll(period, '').trim();
              final timeParts = timeStr.split(':');
              if (timeParts.length != 2) {
                throw FormatException('Invalid time format: ${ticket.time}');
              }
              hour = int.parse(timeParts[0]);
              minute = int.parse(timeParts[1]);
              if (period == 'PM' && hour != 12) hour += 12;
              if (period == 'AM' && hour == 12) hour = 0;
            } else {
              final timeParts = timeStr.split(':');
              if (timeParts.length != 2) {
                throw FormatException('Invalid time format: ${ticket.time}');
              }
              hour = int.parse(timeParts[0]);
              minute = int.parse(timeParts[1]);
            }

            // Combine date and time
            final ticketDate = ticket.date;
            final ticketDateTime = DateTime(
              ticketDate.year,
              ticketDate.month,
              ticketDate.day,
              hour,
              minute,
            );

            // Compare with current time
            if (ticketDateTime.isBefore(now)) {
              historyTickets.add(ticket);
            } else {
              bookedTickets.add(ticket);
            }
          } catch (e) {
            print('Error parsing ticket date/time for ticket ${ticket.id}: $e');
            // Fallback: Assume ticket is in history if parsing fails
            historyTickets.add(ticket);
          }
        }

        isLoading = false;
      });
    } catch (e) {
      print('Error fetching tickets: $e');
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load tickets: $e'),
          margin: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.withOpacity(0.9),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor, // Background blue
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          'Bookings History',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          buildToggleSwitch(),
          const SizedBox(height: 20),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isBookedSelected
                  ? buildBookedList(context)
                  : buildHistoryList(context),
            ),
          ),
        ],
      ),
    );
  }

  // Smooth Toggle Buttons
  Widget buildToggleSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildToggleButton(
              text: "Booked",
              selected: isBookedSelected,
              onTap: () {
                setState(() {
                  isBookedSelected = true;
                });
              }),
          buildToggleButton(
              text: "History",
              selected: !isBookedSelected,
              onTap: () {
                setState(() {
                  isBookedSelected = false;
                });
              }),
        ],
      ),
    );
  }

  // Reusable Toggle Button
  Widget buildToggleButton({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.blue : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Booked List
  Widget buildBookedList(BuildContext context) {
    if (bookedTickets.isEmpty) {
      return const Center(
        child: Text(
          'No upcoming bookings.',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookedTickets.length,
      itemBuilder: (context, index) {
        final ticket = bookedTickets[index];
        return buildcard(
          title: _getTicketTitle(ticket),
          subtitle: _getTicketSubtitle(ticket),
          time: '${ticket.date.toLocal().toString().split(' ')[0]} ${ticket.time}',
          imagePath: ticket.images?.isNotEmpty == true
              ? ticket.images!.first
              : (ticket.ticketType == TicketType.bus
              ? 'assets/bus.jpg'
              : 'assets/flight.jpg'),
          mycontext: context,
          ticket: ticket,
        );
      },
    );
  }

  // History List
  Widget buildHistoryList(BuildContext context) {
    if (historyTickets.isEmpty) {
      return const Center(
        child: Text(
          'No past bookings.',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: historyTickets.length,
      itemBuilder: (context, index) {
        final ticket = historyTickets[index];
        return buildcard(
          title: _getTicketTitle(ticket),
          subtitle: _getTicketSubtitle(ticket),
          time: '${ticket.date.toLocal().toString().split(' ')[0]} ${ticket.time}',
          imagePath: ticket.images?.isNotEmpty == true
              ? ticket.images!.first
              : (ticket.ticketType == TicketType.bus
              ? 'assets/bus.jpg'
              : 'assets/flight.jpg'),
          mycontext: context,
          ticket: ticket,
        );
      },
    );
  }

  // Helper method to get ticket title based on type
  String _getTicketTitle(Ticket ticket) {
    if (ticket.ticketType == TicketType.bus) {
      return ticket.title ?? 'Bus Trip';
    } else if (ticket.ticketType == TicketType.flight) {
      return ticket.airline ?? 'Unknown Airline';
    } else if (ticket.ticketType == TicketType.event) {
      return ticket.artist ?? 'Unknown Event';
    } else {
      return 'Service';
    }
  }

  // Helper method to get ticket subtitle based on type
  String _getTicketSubtitle(Ticket ticket) {
    if (ticket.ticketType == TicketType.bus) {
      return '${ticket.locationFrom} to ${ticket.locationTo}';
    } else if (ticket.ticketType == TicketType.flight) {
      return ticket.flightNumber ?? 'Unknown Flight';
    } else if (ticket.ticketType == TicketType.event) {
      return ticket.category ?? 'Unknown Category';
    } else {
      return ticket.services?.join(', ') ?? 'Unknown Service';
    }
  }
}

// Updated buildcard to accept dynamic title and subtitle
Widget buildcard({
  required String title,
  required String subtitle,
  required String time,
  required String imagePath,
  required BuildContext mycontext,
  required Ticket ticket,
}) {
  return Card(
    color: Colors.grey[900],
    margin: const EdgeInsets.only(bottom: 16.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
          child: Image.network(
            imagePath,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 120,
              height: 120,
              color: Colors.grey,
              child: Image.asset(
               "assets/bus.jpg"
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: const TextStyle(color: Colors.white),
                ),
                if (ticket.ticketType == TicketType.bus && ticket.duration != null)
                  Text(
                    'Duration: ${ticket.duration}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
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
              Navigator.push(
                mycontext,
                MaterialPageRoute(
                  builder: (mycontext) => Summary(ticket: ticket),
                ),
              );
            },
            child: const Text('Select'),
          ),
        ),
      ],
    ),
  );
}