
import 'package:bookify/Screens/Colors.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPayment = 'JazzCash';

  @override
  Widget build(BuildContext context) {
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
                Text('Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 10),
                _infoRow('New York to Los Angeles'),
                _infoRow('Jun 20, 2024'),
               _infoRow('Passenger', secondstr: '1 Adult'),
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
                 Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
                 _infoRow('Total', secondstr: '\$225.00', bold: true),
              ],
             ),
            ),
            //Spacer(),
           
            SizedBox(height: 50),
           SizedBox(
            width: double.infinity, 
            height: 50, 
            child: ElevatedButton(
              onPressed: () {
                // Your action here
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:searchbutton, 
                shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), 
                ),
                elevation: 0, 
              ),
              child: Text(
                'Search Flights',
                style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
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
          Text(title, style: TextStyle(color: Colors.white, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          if (secondstr != null)
            Text(secondstr, style: TextStyle(color: Colors.white, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
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