import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/Screens/flights/flightsearch.dart';
import 'package:flutter/material.dart';

class Flightsui extends StatefulWidget {
  const Flightsui({super.key});

  @override
  State<Flightsui> createState() => _FlightsuiState();
}

class _FlightsuiState extends State<Flightsui> {
  DateTime selecteddate = DateTime.now();
  final TextEditingController _to = TextEditingController();
  final TextEditingController _from = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String formatDate(DateTime date) {

    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = formatDate(selecteddate);
  }

  @override
  void dispose() {
    _to.dispose();
    _from.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flight",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const SizedBox(height: 10),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/flight.jpg"),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(blurStyle: BlurStyle.normal)
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "From",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Opacity(
                opacity: 0.7,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(15),
                      right: Radius.circular(20),
                    ),
                  ),
                  child: TextFormField(
                    controller: _from,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on),
                      filled: true,
                      fillColor: bgColor.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Departure City",
                      hintStyle: const TextStyle(
                        fontSize: 17,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "To",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Opacity(
                opacity: 0.7,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(15),
                      right: Radius.circular(20),
                    ),
                  ),
                  child: TextFormField(
                    controller: _to,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on),
                      filled: true,
                      fillColor: bgColor.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Destination City",
                      hintStyle: const TextStyle(
                        fontSize: 17,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Opacity(
                opacity: 0.7,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(15),
                      right: Radius.circular(20),
                    ),
                  ),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: _dateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selecteddate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2027),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selecteddate = pickedDate;
                          _dateController.text = formatDate(pickedDate);
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: "Departure Date",
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: "Choose a date",
                      hintStyle: TextStyle(color: Colors.white70),
                      suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    print(_to.text);
                    print(_from.text);
                    print(_dateController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Flightsearch(
                          from: _from.text.isNotEmpty ? _from.text : null,
                          to: _to.text.isNotEmpty ? _to.text : null,
                          departureTime: selecteddate,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: searchbutton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Search Flights',
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
      ),
    );
  }
}