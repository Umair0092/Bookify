import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/Screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/Auth.dart';
import '../services/login_info.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _dobController;
  late final TextEditingController _locationController;
  String _selectedGender = "Male";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    final currentUser = _auth.currentUser;
    _nameController = TextEditingController(text: currentUser?.displayName ?? '');
    _emailController = TextEditingController(text: currentUser?.email ?? '');
    _dobController = TextEditingController(text: "24 February 1996");
    _locationController = TextEditingController(text: "Lahore");

    if (currentUser != null) {
      // Fetch user data from Firestore
      final docSnapshot = await _firestore.collection('users').doc(currentUser.uid).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        _nameController.text= data?['name'] ?? "Muneeb";
        _dobController.text = data?['dob'] ?? "24 February 1996";
        _selectedGender = data?['gender'] ?? "Male";
        _locationController.text = data?['location'] ?? "Lahore";
      }
    }
    setState(() {}); // Update UI after fetching data
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  Future<void> _updateProfile() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No user is signed in."),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Update Firebase Authentication profile
      await currentUser.updateDisplayName(_nameController.text.trim());

      // Update Firestore
      await _firestore.collection('users').doc(currentUser.uid).set({
        'name':_nameController.text.trim(),
        'dob': _dobController.text.trim(),
        'gender': _selectedGender,
        'location': _locationController.text.trim(),
      }, SetOptions(merge: true));

      // Update local storage
      await LocalDataSaver.saveName(_nameController.text.trim());
      await LocalDataSaver.saveMail(_emailController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully"),
            backgroundColor: Colors.green,
            elevation: 10,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(5),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'requires-recent-login':
          message = 'Please re-authenticate to update your profile.';
          break;
        default:
          message = 'An error occurred. Please try again.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("An unexpected error occurred."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    signOut(); // From Auth.dart
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: _logout,
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
              Text(
                _nameController.text.isEmpty ? "User" : _nameController.text,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    _locationController.text.isEmpty ? "Unknown" : _locationController.text,
                    style: const TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildTextField("Name", _nameController, Icons.person),
              const SizedBox(height: 16),
              _buildTextField("Email", _emailController, Icons.email, enabled: false),
              const SizedBox(height: 16),
              _buildTextField("Date of Birth", _dobController, Icons.calendar_today),
              const SizedBox(height: 16),
              _buildTextField("Location", _locationController, Icons.location_on),
              const SizedBox(height: 24),
              _buildGenderSelector(),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: searchbutton,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _updateProfile,
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

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
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
                    color: const Color.fromARGB(0, 0, 0, 0),
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