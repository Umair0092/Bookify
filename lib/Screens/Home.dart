import 'package:bookify/Screens/booking/booked.dart';
import 'package:bookify/Screens/homepage.dart';
import 'package:bookify/Screens/profilepage.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final List<Widget> _pages = [
    const Homepage(),
    BookingHistoryPage(),
    const Profilepage(),
    
    //const LikesScreen(),
  ];
  int selectedindex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Color(0xFFFFD700),
        color: Colors.black,
        activeColor: Colors.black,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.message, title: 'bookings'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: selectedindex,
        onTap: (int i) {
          setState(() {
            
            selectedindex=i;
          });
        },
      ),
      body: _pages[selectedindex],
    );
  }
}


