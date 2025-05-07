import 'package:bookify/Screens/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/tickets.dart'; // Import Ticket class
import '../../services/eventservices.dart'; // Import Eventmodel

class PaymentPageEvent extends StatefulWidget {
  final String eventId;
  final Eventmodel event;
  final int numberOfTickets;

  const PaymentPageEvent({
    super.key,
    required this.eventId,
    required this.event,
    required this.numberOfTickets,
  });

  @override
  _PaymentPageEventState createState() => _PaymentPageEventState();
}

class _PaymentPageEventState extends State<PaymentPageEvent> {
  String _selectedPayment = 'JazzCash';
  bool _isProcessing = false;

  Future<void> _bookTicket() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Please sign in to book a ticket.');
      }

      if (widget.event.ticket < widget.numberOfTickets) {
        throw Exception('Not enough tickets available for booking.');
      }

      // Parse date and time
      final dateParts = widget.event.date.split('/');
      final timeParts = widget.event.time.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1].replaceAll(RegExp(r'[APM]+'), ''));
      if (widget.event.time.contains('PM') && hour != 12) hour += 12;
      if (widget.event.time.contains('AM') && hour == 12) hour = 0;
      final ticketDate = DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
        hour,
        minute,
      );

      final ticket = Ticket(
        id: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('tickets')
            .doc()
            .id,
        userId: user.uid,
        ticketType: TicketType.event,
        cost: double.parse((widget.event.cost * widget.numberOfTickets).toString())  ,
        time: widget.event.time,
        date: ticketDate,
        locationFrom: widget.event.place,
        locationTo: null,
        availableTickets: widget.numberOfTickets,
        title: widget.event.eventname,
        artist: widget.event.artist,
        category: widget.event.category,
        highlights: widget.event.highlights.cast<String>(),
        duration: null,
        facilities: null,
        flightNumber: null,
        airline: null,
        arrivalTime: null,
        servicesOffered: null,
        images: null,
        isActive: null,
        createdAt: DateTime.now(),
        services: null,
        rating: null,
      );

      await Ticket.writeTicket(ticket);

      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
          .update({
        'ticket': widget.event.ticket - widget.numberOfTickets,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Payment successful for ${widget.numberOfTickets} ticket(s) via $_selectedPayment! Ticket booked.",
            style: const TextStyle(color: Colors.black),
          ),
          margin: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFFFD700).withOpacity(0.9),
        ),
      );

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Booking failed: $e",
            style: const TextStyle(color: Colors.black),
          ),
          margin: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.withOpacity(0.9),
        ),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double totalCost = double.parse((widget.event.cost * widget.numberOfTickets).toString());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Payment', style: TextStyle(color: Colors.white)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        _infoRow('Event: ${widget.event.eventname}'),
                        _infoRow('Artist: ${widget.event.artist}'),
                        _infoRow('Category: ${widget.event.category}'),
                        _infoRow('Location: ${widget.event.place}'),
                        _infoRow(widget.event.date),
                        _infoRow('Time: ${widget.event.time}'),
                        _infoRow(
                            'Tickets',
                            secondstr:
                            '${widget.numberOfTickets} Ticket${widget.numberOfTickets > 1 ? 's' : ''}'),
                        if (widget.event.highlights.isNotEmpty)
                          _infoRow('Highlights: ${widget.event.highlights.join(', ')}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Payment Method',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        _paymentOption('JazzCash'),
                        _paymentOption('EasyPaisa'),
                        _paymentOption('PayPal'),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _infoRow(
                          'Total',
                          secondstr: '\$${totalCost.toStringAsFixed(2)}',
                          bold: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _bookTicket,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: searchbutton,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Confirm Payment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isProcessing)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
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
            title.length>50?title.substring(0,50)+"...":title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (secondstr != null)
            Text(
              secondstr.length>20?secondstr.substring(0,15)+"...":secondstr,
              style: TextStyle(
                color: Colors.white,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }

  Widget _paymentOption(String option) {
    return RadioListTile<String>(
      value: option,
      groupValue: _selectedPayment,
      onChanged: (value) {
        setState(() {
          _selectedPayment = value!;
        });
      },
      title: Text(option, style: const TextStyle(color: Colors.white)),
      activeColor: Colors.teal,
      tileColor: Colors.grey[900],
      selectedTileColor: Colors.grey[850],
    );
  }
}