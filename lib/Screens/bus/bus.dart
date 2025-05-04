import 'package:flutter/material.dart';
import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/Screens/bus/bussearch.dart';

class Bus extends StatefulWidget {
  const Bus({super.key});

  @override
  State<Bus> createState() => _BusState();
}

class _BusState extends State<Bus> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = formatDate(selectedDate);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/bus.jpg"),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [BoxShadow(blurStyle: BlurStyle.normal)],
              ),
            ),
            const SizedBox(height: 20),
            const Text("From", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            _buildInputField(
              controller: _fromController,
              hintText: "Enter origin",
              icon: Icons.location_pin,
            ),
            const SizedBox(height: 20),
            const Text("To", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            _buildInputField(
              controller: _toController,
              hintText: "Enter destination",
              icon: Icons.location_pin,
            ),
            const SizedBox(height: 20),
            Opacity(
              opacity: 0.7,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(15),
                    right: Radius.circular(20),
                  ),
                ),
                child: TextField(
                  controller: _dateController,
                  readOnly: true,
                  style: const TextStyle(color: Colors.white),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2027),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                        _dateController.text = formatDate(pickedDate);
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "  Departure Date",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "   Choose a date",
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Bussearch(
                        from: _fromController.text,
                        to: _toController.text,
                        date: _dateController.text,
                      ),
                    ),
                  );
                  print(
                    _fromController.text
                  );
                  print(_dateController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: searchbutton,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Search Buses',
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return Opacity(
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
        child: Row(
          children: [
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
