import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/Screens/login.dart';
import 'package:flutter/material.dart';





class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final TextEditingController _nameController = TextEditingController(text: "Muneeb");
  final TextEditingController _emailController = TextEditingController(text: "muneeb@gmail.com");
  final TextEditingController _dobController = TextEditingController(text: "24 February 1996");

  String _selectedGender = "Male";

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
       
        title: const Text(
          'Profile',
          style: TextStyle( fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>login()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/flight.jpg'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 16,
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                "Muneeb",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.location_on, size: 16, color: Colors.blue),
                  SizedBox(width: 4),
                  Text("lahore", style: TextStyle(color: Colors.blue)),
                ],
              ),
              const SizedBox(height: 24),
              _buildTextField("Name", _nameController, Icons.person),
              const SizedBox(height: 16),
              _buildTextField("Email", _emailController, Icons.email),
              const SizedBox(height: 16),
              _buildTextField("Date of Birth", _dobController, Icons.calendar_today),
              const SizedBox(height: 24),
              _buildGenderSelector(),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: searchbutton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    // Save action// will print snack bar 
                    const mysnak=SnackBar(content: Text("updtaed"),
                    backgroundColor: Colors.green,
                    elevation: 10,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(5),
                    
                    );
                    ScaffoldMessenger.of(context).showSnackBar(mysnak);
                  },
                  child: const Text(
                    "Changes Update",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: label,
            suffixIcon: Icon(icon),
            filled: true,
            fillColor: Colors.blueGrey,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Gender", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectGender("Male"),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(0, 0, 0, 0),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: _selectedGender == "Male" ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Male"),
                      const SizedBox(width: 8),
                      Icon(
                        _selectedGender == "Male"
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: _selectedGender == "Male" ? Colors.blue : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectGender("Female"),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color:const Color.fromARGB(0, 0, 0, 0),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: _selectedGender == "Female" ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Female"),
                      const SizedBox(width: 8),
                      Icon(
                        _selectedGender == "Female"
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: _selectedGender == "Female" ? Colors.blue : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
