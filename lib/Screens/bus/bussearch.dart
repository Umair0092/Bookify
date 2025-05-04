import 'package:bookify/services/busservice.dart';
import 'package:flutter/material.dart';
import 'package:bookify/Screens/Colors.dart';
import 'Buses_Detais.dart';

class Bussearch extends StatefulWidget {
  final String from;
  final String to;
  final String date;

  const Bussearch({
    required this.from,
    required this.to,
    required this.date,
    super.key,
  });

  

  @override
  State<Bussearch> createState() => _BussearchState();
}

class _BussearchState extends State<Bussearch> {
  
  final TextStyle whiteTextStyle = TextStyle(color: Colors.white);
  late Future<List<Busmodel>> futureBuses;

  @override
  void initState() {
    super.initState();
    futureBuses = BusService().fetchBuses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          'Search Buses',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Static From/To display
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
                      child: Text(widget.from, style: whiteTextStyle),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
                      child: Text(widget.to, style: whiteTextStyle),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
                child: Text(widget.date, style: whiteTextStyle),
              ),
              SizedBox(height: 20),

              // List of Buses
              Expanded(
                child: FutureBuilder<List<Busmodel>>(
                  future: futureBuses,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No buses available'));
                    }
                    final filtered = snapshot.data!.where((bus) =>
                      bus.from.toLowerCase() == widget.from.toLowerCase() &&
                      bus.to.toLowerCase() == widget.to.toLowerCase() &&
                      bus.date == widget.date).toList();
                    

                    if (filtered.isEmpty) {
                      
                      return Center(child: Text("No matching buses for your search."));
                    }
                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final bus = filtered[index];
                        return buildBusCard(
                          context: context,
                          busId: bus.id,
                          title: bus.title,
                          time: bus.time,
                          route: "${bus.from}->${bus.to}",
                          duration: bus.duration,
                          date: bus.date,
                        );
                      },
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

Widget buildBusCard({
  required BuildContext context,
  required String busId,
  required String title,
  required String time,
  required String route,
  required String duration,
  required String date,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BusBookingPage(busId: busId),
        ),
      );
    },
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bus details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(route, style: TextStyle(color: Colors.white70)),
              Text(date, style: TextStyle(color: Colors.white60)),
            ],
          ),
          // Time & Duration
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(time, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(duration, style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    ),
  );
}
