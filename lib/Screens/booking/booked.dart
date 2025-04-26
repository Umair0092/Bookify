import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/Screens/booking/summary.dart';

import 'package:flutter/material.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  bool isBookedSelected = true; // initially Booked is selected

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
            child: AnimatedSwitcher(
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
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildToggleButton(text: "Booked", selected: isBookedSelected, onTap: () {
            setState(() {
              isBookedSelected = true;
            });
          }),
          buildToggleButton(text: "History", selected: !isBookedSelected, onTap: () {
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        buildcard(
          artist: "Drake",
          tour: "World Tour",
          time: "22 January 2022",
          imagePath: "assets/flight.jpg",
          mycontext: context,
        ),
        buildcard(
          artist: "Ariana Grande",
          tour: "Sweetener Tour",
          time: "18 March 2022",
          imagePath: "assets/flight.jpg",
          mycontext: context,
        ),
      ],
    );
  }

  // History List
  Widget buildHistoryList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        buildcard(
          artist: "The Weeknd",
          tour: "After Hours",
          time: "12 December 2021",
          imagePath: "assets/flight.jpg",
          mycontext: context,
        ),
        buildcard(
          artist: "Billie Eilish",
          tour: "Happier Than Ever",
          time: "05 November 2021",
          imagePath: "assets/flight.jpg",
          mycontext: context,
        ),
      ],
    );
  }
}


Widget buildcard({
  required String artist,
  required String tour,
  required String time,
  required String imagePath,
  required BuildContext mycontext,
}
)
{
 return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artist,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (tour.isNotEmpty)
                    Text(
                      tour,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  SizedBox(height: 8),
                  Text(
                    time,
                    style: TextStyle(color: Colors.white),
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
                Navigator.push(mycontext, MaterialPageRoute(builder: (mycontext) =>Summary(),),);
              },
              child: Text('Select'),
            ),
          )
        ],
      ),
    );
}



