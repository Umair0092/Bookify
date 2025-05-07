import 'package:bookify/Screens/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/tickets.dart'; // Import Ticket class

class PaymentPage extends StatefulWidget {
  final String busId;
  final String departureCity;
  final String destinationCity;
  final DateTime departureTime;
  final double price;
  final int availableSeats;
  final String time;
  final String? duration;
  final List<String>? facilities;
  final int numberOfPassengers;

  const PaymentPage({
    super.key,
    required this.busId,
    required this.departureCity,
    required this.destinationCity,
    required this.departureTime,
    required this.price,
    required this.availableSeats,
    this.duration,
    this.facilities,
    required this.numberOfPassengers, required this.time,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
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

      if (widget.availableSeats < widget.numberOfPassengers) {
        throw Exception('Not enough seats available for booking.');
      }

      final ticket = Ticket(
        id: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('tickets')
            .doc()
            .id,
        userId: user.uid,
        ticketType: TicketType.bus,
        cost: widget.price * widget.numberOfPassengers,
        time: widget.time,
        date: widget.departureTime,
        locationFrom: widget.departureCity,
        locationTo: widget.destinationCity,
        availableTickets: widget.numberOfPassengers,
        title: widget.duration ?? 'Unknown Duration',
        duration: widget.duration,
        facilities: widget.facilities,
        flightNumber: null,
        airline: null,
        arrivalTime: null,
        servicesOffered: null,
        images: null,
        isActive: null,
        createdAt: DateTime.now(), // Set current time as createdAt
        artist: null,
        category: null,
        highlights: null,
        services: null,
        rating: null,
      );

      await Ticket.writeTicket(ticket);

      await FirebaseFirestore.instance
          .collection('bus')
          .doc(widget.busId)
          .update({
        'tickets': widget.availableSeats - widget.numberOfPassengers,
      });

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
    final double totalCost = widget.price * widget.numberOfPassengers;

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
                      const Text(
                        'Summary',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      _infoRow('${widget.departureCity} to ${widget.destinationCity}'),
                      _infoRow(widget.departureTime.toLocal().toString().split(' ')[0]),
                      _infoRow(
                          'Passengers',
                          secondstr:
                          '${widget.numberOfPassengers} Adult${widget.numberOfPassengers > 1 ? 's' : ''}'),
                      if (widget.duration != null)
                        _infoRow('Duration', secondstr: widget.duration),
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
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (secondstr != null)
            Text(
              secondstr,
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
                validator: (value) =>
                    value == null || !RegExp(r'^\d{2}/\d{2}$').hasMatch(value)
                        ? 'Enter valid expiry date'
                        : null,
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