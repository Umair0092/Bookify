import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/Screens/localservice/servicebooking.dart';
import 'package:flutter/material.dart';

class LocalServices extends StatefulWidget {
  @override
  _LocalServicesState createState() => _LocalServicesState();
}

class _LocalServicesState extends State<LocalServices> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> companies = [];
  String selectedService = "Plumber"; // Default service
  TextEditingController locationController = TextEditingController();

  late AnimationController _controller;
  //late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    updateCompanies(); // <-- Important
  }

  @override
  void dispose() {
    _controller.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text('Select a Company', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
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
          children: [
            buildServiceToggle(),
            SizedBox(height: 16),
            buildLocationField(),
            SizedBox(height: 16),
            Expanded(child: buildCompanyList()),
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
      decoration: InputDecoration(
        hintText: 'Enter Your Location',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildCompanyList() {
    return  ListView.builder(
        itemCount: companies.length,
        itemBuilder: (context, index) {
          final company = companies[index];
          return Card(
            color: Colors.white.withOpacity(0.05),
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              title: Text(
                company["name"],
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                children: List.generate(5, (starIndex) {
                  return Icon(
                    Icons.star,
                    color: starIndex < company["rating"] ? Colors.yellow : Colors.grey,
                    size: 20,
                  );
                }),
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  // Handle booking action
                   Navigator.push(
                         context,
                         MaterialPageRoute(
                        builder: (context) => Servicebooking(
                          companyName: company["name"],
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

  void updateCompanies() {
    if (selectedService == "Plumber") {
      companies = [
        {"name": "FixIt Plumbers", "rating": 4},
        {"name": "PlumbQuick", "rating": 4},
      ];
    } else if (selectedService == "Electrician") {
      companies = [
        {"name": "ElectroFix Solutions", "rating": 5},
        {"name": "Bright Sparks Ltd", "rating": 4},
      ];
    } else if (selectedService == "Cleaner") {
      companies = [
        {"name": "SparkleClean Services", "rating": 5},
        {"name": "FreshStart Cleaning", "rating": 4},
      ];
    }
  }
}
