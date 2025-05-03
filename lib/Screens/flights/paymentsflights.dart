import 'package:bookify/Screens/Colors.dart';
import 'package:flutter/material.dart';

import '../../services/flights.dart';
 // Import Flight class

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

  @override
  Widget build(BuildContext context) {
    // Calculate total cost using flight price and number of passengers
    final double totalCost = widget.flight.price * widget.numberOfPassengers;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Payment', style: TextStyle(color: Colors.white)),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('Summary',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 10),
                  _infoRow(
                      '${widget.flight.departureCity} to ${widget.flight.destinationCity}'),
                  _infoRow(widget.flight.departureTime.toLocal()
                      .toString()
                      .split(' ')[0]),
                  _infoRow('Passengers',
                      secondstr: '${widget.numberOfPassengers} Adult${widget.numberOfPassengers > 1 ? 's' : ''}'),
                  _infoRow('Flight',
                      secondstr: '${widget.flight.flightNumber} (${widget.flight.airline})'),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('Payment Method',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 10),
                  _paymentOption('JazzCash'),
                  _paymentOption('EasyPaisa'),
                  _paymentOption('PayPal'),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF1E1E1E),
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
            SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Payment successful for ${widget.numberOfPassengers} passenger(s) via $_selectedPayment!",
                          style: TextStyle(color: Colors.black)),
                      margin: EdgeInsets.fromLTRB(20, 50, 20, 20),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Color(0xFFFFD700).withOpacity(0.9),
                    ),
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: searchbutton,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
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
      title: Text(option, style: TextStyle(color: Colors.white)),
      activeColor: Colors.teal,
      tileColor: Colors.grey[900],
      selectedTileColor: Colors.grey[850],
    );
  }
}