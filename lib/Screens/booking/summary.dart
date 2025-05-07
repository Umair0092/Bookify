import 'package:bookify/Screens/Colors.dart';
import 'package:flutter/material.dart';
import '../../services/tickets.dart'; // Import Ticket class

class Summary extends StatefulWidget {
  final Ticket ticket; // Add Ticket parameter

  const Summary({super.key, required this.ticket});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text('Booking Details', style: TextStyle(color: Colors.white)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                'Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              if (ticket.ticketType == TicketType.bus)
                _infoRow('${ticket.locationFrom} to ${ticket.locationTo ?? 'Unknown'}'),
              if (ticket.ticketType == TicketType.event)
                _infoRow('Event: ${ticket.title ?? 'Unknown Event'}'),
              if (ticket.ticketType == TicketType.event)
                _infoRow('Artist', secondstr: ticket.artist ?? 'Unknown'),
              if (ticket.ticketType == TicketType.event)
                _infoRow('Category', secondstr: ticket.category ?? 'Unknown'),
              if (ticket.ticketType == TicketType.event || ticket.ticketType == TicketType.bus)
                _infoRow('Location', secondstr: ticket.locationFrom ?? 'Unknown'),
              _infoRow(
                ticket.date.toLocal().toString().split(' ')[0], // Date only
                secondstr: ticket.time, // Time
              ),
              _infoRow(
                'Tickets',
                secondstr: '${ticket.availableTickets} Ticket${ticket.availableTickets > 1 ? 's' : ''}',
              ),
              if (ticket.ticketType == TicketType.flight) ...[
                _infoRow('Airline', secondstr: ticket.airline ?? 'Unknown'),
                _infoRow('Flight Number', secondstr: ticket.flightNumber ?? 'Unknown'),
              ],
              if (ticket.ticketType == TicketType.flight && ticket.arrivalTime != null)
                _infoRow(
                  'Arrival',
                  secondstr: '${ticket.arrivalTime!.toLocal().toString().split(' ')[0]} ${ticket.arrivalTime!.toLocal().toString().split(' ')[1].substring(0, 5)}',
                ),
              if (ticket.ticketType == TicketType.event && ticket.highlights != null && ticket.highlights!.isNotEmpty)
                _infoRow('Highlights', secondstr: ticket.highlights!.join(', ')),
              _infoRow('Cost', secondstr: '\$${ticket.cost.toStringAsFixed(2)}', bold: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, {String? secondstr, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (secondstr != null)
            Text(
              secondstr.length>20?secondstr.substring(0,20)+"...":secondstr,
              style: TextStyle(
                color: Colors.white,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }
}