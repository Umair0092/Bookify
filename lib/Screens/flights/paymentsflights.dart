import 'package:bookify/Screens/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/flights.dart'; // Import Flight class
import '../../services/tickets.dart'; // Import Ticket class

class PaymentPage extends StatefulWidget {
  final Flight flight;
  final int numberOfPassengers;

  const PaymentPage({
    Key? key,
    required this.flight,
    required this.numberOfPassengers,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPayment = 'JazzCash';
  bool _isProcessing = false;

  // Function to book the ticket
  Future<void> _bookTicket() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Check if enough seats are available
      if (widget.flight.availableSeats < widget.numberOfPassengers) {
        throw Exception('Not enough seats available for booking.');
      }

      // Create a Ticket object for the flight booking
      final ticket = Ticket(
        id: FirebaseFirestore.instance.collection('tickets').doc().id, // Generate unique ID
        userId: FirebaseAuth.instance.currentUser!.uid,
        ticketType: TicketType.flight,
        cost: widget.flight.price * widget.numberOfPassengers,
        time: widget.flight.departureTime.toLocal().toString().split(' ')[1].substring(0, 5),
        date: widget.flight.departureTime,
        locationFrom: widget.flight.departureCity,
        locationTo: widget.flight.destinationCity,
        availableTickets: widget.numberOfPassengers, // Number of tickets booked
        flightNumber: widget.flight.flightNumber,
        airline: widget.flight.airline,
        arrivalTime: widget.flight.arrivalTime,
        servicesOffered: widget.flight.servicesOffered.map((service) => service.toJson()).toList(),
        images: [widget.flight.image, widget.flight.image2, widget.flight.image3],
        isActive: true,
        createdAt: DateTime.now(),
      );

      // Write the ticket to Firestore
      await Ticket.writeTicket(ticket);
      print("true");
      // Update the flight's available seats
      await FirebaseFirestore.instance
          .collection('flights')
          .doc(widget.flight.id)
          .update({
        'availableSeats': widget.flight.availableSeats - widget.numberOfPassengers,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Payment successful for ${widget.numberOfPassengers} passenger(s) via $_selectedPayment! Ticket booked.",
            style: const TextStyle(color: Colors.black),
          ),
          margin: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFFFD700).withOpacity(0.9),
        ),
      );

      // Navigate back to the first route
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      // Show error message
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
    // Calculate total cost using flight price and number of passengers
    final double totalCost = widget.flight.price * widget.numberOfPassengers;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Payment', style: TextStyle(color: Colors.white)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
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
                      const Text('Summary',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 10),
                      _infoRow(
                          '${widget.flight.departureCity} to ${widget.flight.destinationCity}'),
                      _infoRow(widget.flight.departureTime.toLocal()
                          .toString()
                          .split(' ')[0]),
                      _infoRow('Passengers',
                          secondstr:
                          '${widget.numberOfPassengers} Adult${widget.numberOfPassengers > 1 ? 's' : ''}'),
                      _infoRow('Flight',
                          secondstr:
                          '${widget.flight.flightNumber} (${widget.flight.airline})'),
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
                      const Text('Payment Method',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
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
                      _infoRow('Total',
                          secondstr: '\$${totalCost.toStringAsFixed(2)}',
                          bold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : () => _showCardDialog(),

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
    );
  }

  Widget _infoRow(String title, {String? secondstr, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          if (secondstr != null)
            Text(secondstr,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
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
  void _showCardDialog() {
  final _formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Enter Card Details',
          style: TextStyle(color: Colors.white),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => cardNumber = value,
                validator: (value) => value == null || value.length < 16
                    ? 'Enter valid card number'
                    : null,
              ),
              const SizedBox(height: 10),
               TextFormField(
  style: const TextStyle(color: Colors.white),
  decoration: const InputDecoration(
    labelText: 'Expiry Date (MM/YY)',
    labelStyle: TextStyle(color: Colors.white),
    border: OutlineInputBorder(),
  ),
  onChanged: (value) => expiryDate = value,
  validator: (value) {
    if (value == null || !RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      return 'Enter valid expiry date';
    }

    final parts = value.split('/');
    final int month = int.tryParse(parts[0]) ?? 0;
    final int year = int.tryParse(parts[1]) ?? -1;

    if (month < 1 || month > 12) {
      return 'Invalid month';
    }

    // Convert 2-digit year to 4-digit year (e.g., 25 => 2025)
    final currentYear = DateTime.now().year;
    final fullYear = 2000 + year;
    final now = DateTime.now();
    final expiry = DateTime(fullYear, month + 1); // Valid through the end of that month

    if (expiry.isBefore(now)) {
      return 'Expiry date is in the past';
    }

    return null;
  },
),
              const SizedBox(height: 10),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                onChanged: (value) => cvv = value,
                validator: (value) => value == null || value.length != 3
                    ? 'Enter valid CVV'
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: searchbutton),
            child: const Text('Confirm Payment'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.of(context).pop();
                _bookTicket(); // Proceed to booking
              }
            },
          ),
        ],
      );
    },
  );
}

}

