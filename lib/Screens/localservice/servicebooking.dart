import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/services/tickets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Servicebooking extends StatefulWidget {
  final String companyName;
  final List<String> availableTimes;
  final int rate;
  final String serv;

  const Servicebooking({
    super.key,
    required this.companyName,
    required this.availableTimes,
    required this.rate,
    required this.serv,
  });

  @override
  _ServicebookingState createState() => _ServicebookingState();
}

class _ServicebookingState extends State<Servicebooking> {
  String ?selectedTime;
   DateTime? selectedDate;
  bool is_processing=false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _confirmBooking() async {
    setState(() {
       is_processing= true;
    });
    if (selectedTime == null || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both time and date')),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Please sign in to book a ticket.');
      }

      

      final ticket = Ticket(
        id: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('tickets')
            .doc()
            .id,
        userId: user.uid,
        ticketType: TicketType.service,
        cost: widget.rate.toDouble(),
        time: selectedTime ?? '',
        date: selectedDate!,
        locationFrom: "",
        locationTo: null,
        availableTickets: 0,
        title: widget.companyName ?? 'Unknown Duration',
        duration: null,
        facilities: null,
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
        services: [widget.serv],
        rating: null,
      );

      await Ticket.writeTicket(ticket);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        title: Text('Booking Confirmed', style: TextStyle(color: Colors.white)),
        content: Text(
          'You booked ${widget.companyName} on ${selectedDate!.toLocal().toString().split(" ")[0]} at $selectedTime',
          style: TextStyle(color: Colors.white),
        ),
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
  }catch (e) {
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
        is_processing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text('Booking', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.white),
          onPressed: () {
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
              'Selected service: ${widget.serv}',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Select Available Time:', style: TextStyle(color: Colors.white, fontSize: 18)),
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
                  items: widget.availableTimes.map((time) {
                    return DropdownMenuItem(
                      value: time,
                      child: Text(time, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTime = value!;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Select Booking Date:', style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 10),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  selectedDate != null
                      ? '${selectedDate!.toLocal()}'.split(' ')[0]
                      : 'Choose Date',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 30),
            if (selectedTime != null && selectedDate != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Per Hour Rate:', style: TextStyle(color: Colors.white, fontSize: 18)),
                  SizedBox(height: 8),
                  Text('\$${widget.rate.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.yellow, fontSize: 24, fontWeight: FontWeight.bold)),
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
                      onPressed: _confirmBooking,
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


