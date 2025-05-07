import 'package:bookify/Screens/Colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/tickets.dart'; // Ticket class

class Summary extends StatefulWidget {
  final Ticket ticket;

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                ticket.date.toLocal().toString().split(' ')[0],
                secondstr: ticket.time,
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
                  secondstr:
                      '${ticket.arrivalTime!.toLocal().toString().split(' ')[0]} ${ticket.arrivalTime!.toLocal().toString().split(' ')[1].substring(0, 5)}',
                ),
              if (ticket.ticketType == TicketType.event &&
                  ticket.highlights != null &&
                  ticket.highlights!.isNotEmpty)
                _infoRow('Highlights', secondstr: ticket.highlights!.join(', ')),
              _infoRow('Cost', secondstr: '\$${ticket.cost.toStringAsFixed(2)}', bold: true),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Booking'),
                        content: const Text('Are you sure you want to delete this booking?'),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.pop(ctx, false),
                          ),
                          TextButton(
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                            onPressed: () => Navigator.pop(ctx, true),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      try {
                        await deleteTicket( userId: ticket.userId, ticketId: ticket.id, ticketType: ticket.ticketType);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Booking deleted successfully')),
                        );
                        Navigator.pop(context, true);// Go back after deletion
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error deleting booking: $e')),
                        );
                      }
                    }
                  },
                  child: const Text('Delete Booking', style: TextStyle(color: Colors.white)),
                ),
              ),
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
              secondstr.length > 20 ? secondstr.substring(0, 20) + "..." : secondstr,
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
