import 'package:bookify/Screens/Colors.dart';
import 'package:flutter/material.dart';

class Servicebooking extends StatefulWidget {
  final String companyName;

  Servicebooking({super.key, required this.companyName});

  @override
  _ServicebookingState createState() => _ServicebookingState();
}

class _ServicebookingState extends State<Servicebooking> {
  List<String> availableTimes = [
    "10:00 AM",
    "12:00 PM",
    "2:00 PM",
    "4:00 PM",
  ];

  String? selectedTime;
  double perHourRate = 50; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text('Booking', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,color: Colors.white)),
        leading: IconButton(icon: Icon(Icons.arrow_back_outlined,color: Colors.white,),
        onPressed: () 
        {
          Navigator.pop(context);
        },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Company: ${widget.companyName}',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Select Available Time:',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: backgroundColor,
                  value: selectedTime,
                  hint: Text('Choose Time', style: TextStyle(color: Colors.white)),
                  items: availableTimes.map((time) {
                    return DropdownMenuItem(
                      value: time,
                      child: Text(time, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTime = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 30),
            if (selectedTime != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Per Hour Rate:',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${perHourRate.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.yellow, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        // Handle booking confirmation
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: backgroundColor,
                            title: Text('Booking Confirmed', style: TextStyle(color: Colors.white)),
                            content: Text('You booked ${widget.companyName} at $selectedTime', style: TextStyle(color: Colors.white)),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context); 
                                },
                                child: Text('OK', style: TextStyle(color: Colors.yellow)),
                              )
                            ],
                          ),
                        );
                      },
                      child: Text('Confirm'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
