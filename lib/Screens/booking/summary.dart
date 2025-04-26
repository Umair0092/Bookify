import 'package:bookify/Screens/Colors.dart';
import 'package:flutter/material.dart';


class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('booking details', style: TextStyle(color: Colors.white)),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
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
      ),
    );
  }
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