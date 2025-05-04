import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/Screens/localservice/servicebooking.dart';
import 'package:bookify/services/localservice.dart';
import 'package:flutter/material.dart';

class LocalServices extends StatefulWidget {
  @override
  _LocalServicesState createState() => _LocalServicesState();
}

class _LocalServicesState extends State<LocalServices> with SingleTickerProviderStateMixin {
  List<localServicemodel> companies = [];
  String selectedService = "Plumber"; // Default service
  TextEditingController locationController = TextEditingController();
  final Localserv _localserv = Localserv();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    updateCompanies();
  }

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  Future<void> updateCompanies() async {
  setState(() {
    isLoading = true;
  });
  try {
    List<localServicemodel> fetchedCompanies = await _localserv.fetchlocal();
    String locationQuery = locationController.text.trim().toLowerCase();
    print(locationQuery);

    setState(() {
      companies = fetchedCompanies
          .where((company) =>
              company.services.contains(selectedService) &&
              (locationQuery.isEmpty || company.loc.toLowerCase().contains(locationQuery)))
          .toList();
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching services: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text('Select a Company', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
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
          children: [
            buildServiceToggle(),
            SizedBox(height: 16),
            buildLocationField(),
            SizedBox(height: 16),
            Expanded(child: isLoading ? Center(child: CircularProgressIndicator()) : buildCompanyList()),
          ],
        ),
      ),
    );
  }

  Widget buildServiceToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          buildServiceButton("Plumber"),
          buildServiceButton("Electrician"),
          buildServiceButton("Cleaner"),
        ],
      ),
    );
  }

  Widget buildServiceButton(String service) {
    bool isSelected = selectedService == service;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedService = service;
            updateCompanies();
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.yellow : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              service,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLocationField() {
  return TextField(
    controller: locationController,
    style: TextStyle(color: Colors.white),
    onSubmitted: (_) => updateCompanies(), // Trigger search on Enter
    decoration: InputDecoration(
      hintText: 'Enter Your Location',
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      suffixIcon: IconButton(
        icon: Icon(Icons.search, color: Colors.white),
        onPressed: updateCompanies, // Trigger search on button press
      ),
    ),
  );
}


  Widget buildCompanyList() {
    return ListView.builder(
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final company = companies[index];
        return Card(
          color: Colors.white.withOpacity(0.05),
          margin: EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ListTile(
            title: Text(
              company.id,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                Row(
                  children: List.generate(5, (starIndex) {
                    return Icon(
                      Icons.star,
                      color: starIndex < company.rating ? Colors.yellow : Colors.grey,
                      size: 20,
                    );
                  }),
                ),
                SizedBox(width: 10),
                Text(
                  '\$${company.cost}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Servicebooking(
                      companyName: company.id,
                     availableTimes: company.time.map((time) => time.toString()).toList(),
                      rate: company.cost,
                    ),
                  ),
                );
              },
              child: Text('Book'),
            ),
          ),
        );
      },
    );
  }
}