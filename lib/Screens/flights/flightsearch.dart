import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/Screens/flights/buildcard.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/flights.dart';
import '../flights_cards.dart';
import 'flight_details_page.dart';

class Flightsearch extends StatefulWidget {
  final String? from;
  final String? to;
  final DateTime? departureTime;

  const Flightsearch({
    Key? key,
    this.from,
    this.to,
    this.departureTime,
  }) : super(key: key);

  @override
  State<Flightsearch> createState() => _FlightsearchState();
}

class _FlightsearchState extends State<Flightsearch> {
  final TextStyle whiteTextStyle = const TextStyle(color: Colors.white);
  late List<Flight> _flights;
  bool _isLoading = false;
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('MMMM d, yyyy');

  @override
  void initState() {
    super.initState();
    // Initialize controllers with widget parameters if provided
    _fromController.text = widget.from ?? '';
    _toController.text = widget.to ?? '';
    _selectedDate = widget.departureTime;
    _flights = [];
    // Fetch initial flight data
    _fetchFlights();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _fetchFlights() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _flights = await Fectchdata.fetchFlightData(
        from: _fromController.text.isNotEmpty ? _fromController.text : null,
        to: _toController.text.isNotEmpty ? _toController.text : null,
        departureTime: _selectedDate,
      );
    } catch (e) {
      debugPrint('Error fetching flights: $e');
      _flights = [];
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchFlights();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xFFFFD700),
        title: const Text(
          'Search Flights',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _fromController,
                      style: whiteTextStyle,
                      decoration: InputDecoration(
                        hintText: 'From',
                        hintStyle: whiteTextStyle,
                        filled: true,
                        fillColor: cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        _fetchFlights();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _toController,
                      style: whiteTextStyle,
                      decoration: InputDecoration(
                        hintText: 'To',
                        hintStyle: whiteTextStyle,
                        filled: true,
                        fillColor: cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        _fetchFlights();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _selectedDate == null
                        ? 'Select Departure Date'
                        : _dateFormat.format(_selectedDate!),
                    style: whiteTextStyle,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _flights.isEmpty
                    ? const Center(child: Text('No flights available'))
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _flights.length,
                  itemBuilder: (context, index) {
                    final flight = _flights[index];
                    return SizedBox(
                      height:
                      MediaQuery.of(context).size.height * 0.27,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: FlightCard(
                        flight: flight,
                        onBookNow: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FlightBookingPage(flight: flight),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}