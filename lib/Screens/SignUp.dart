import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isTapped = false;
  bool _isTapped2 = false;
  bool _isloading = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<void> sign_up() async {
    if(_formKey.currentState!.validate()){
      setState(() {
        _isloading = true;
      });
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Sign-up successful!')));
        }
        setState(() {
          _isloading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => login()),
        );
      }
      on FirebaseAuthException catch (e)
      {
        String message;
        switch (e.code) {
          case 'email-already-in-use':
            message = 'This email is already registered.';
            break;
          case 'invalid-email':
            message = 'The email address is not valid.';
            break;
          case 'weak-password':
            message = 'The password is too weak.';
            break;
          default:
            message = 'An error occurred. Please try again.';
        }
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
          setState(() {
            _isloading = false;
          });
        }
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Image.asset("assets/logo.png", height: 250),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 50),
                  Expanded(
                    child: TextFormField(
                      textInputAction: TextInputAction.search,
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        //enabledBorder: InputBorder.none,
                        // focusedBorder: InputBorder.none,
                        //disabledBorder: InputBorder.none,
                        //errorBorder: InputBorder.none,
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: bgColor.withOpacity(
                          0.5,
                        ), // Set your desired background color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: ("Name"),

                        hintStyle: TextStyle(
                          fontSize: 17,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 50),
                  Expanded(
                    child: TextFormField(
                      textInputAction: TextInputAction.search,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        //enabledBorder: InputBorder.none,
                        prefixIcon: Icon(Icons.email),
                        // focusedBorder: InputBorder.none,
                        //disabledBorder: InputBorder.none,
                        //errorBorder: InputBorder.none,
                        filled: true,
                        fillColor: bgColor.withOpacity(
                          0.5,
                        ), // Set your desired background color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: ("Email Address"),

                        hintStyle: TextStyle(
                          fontSize: 17,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 50),
                  Expanded(
                    child: TextFormField(
                      textInputAction: TextInputAction.search,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        //enabledBorder: InputBorder.none,
                        prefixIcon: const Icon(Icons.lock),
                        // focusedBorder: InputBorder.none,
                        //disabledBorder: InputBorder.none,
                        //errorBorder: InputBorder.none,
                        filled: true,
                        fillColor: bgColor.withOpacity(
                          0.5,
                        ), // Set your desired background color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: ("Password"),

                        hintStyle: TextStyle(
                          fontSize: 17,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 140),
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      _isTapped = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _isTapped = false;
                    });

                    print("Forgot Password tapped!");
                  },
                  onTapCancel: () {
                    setState(() {
                      _isTapped = false;
                    });
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color:
                          _isTapped
                              ? Color.fromRGBO(255, 193, 7, 1)
                              : Colors.white70,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _isloading
                  ? const CircularProgressIndicator()
                  : Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: ElevatedButton(
                      onPressed: sign_up,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Color(0xFFFFD700),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18.0,color: Colors.black,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              SizedBox(height: 20),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already Have an Account?",
                      style: TextStyle(color: white.withOpacity(0.7)),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          _isTapped2 = true;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          _isTapped2 = false;
                        });
                        Navigator.pop(context);
                        print("Sign Up pressed");
                      },
                      onTapCancel: () {
                        setState(() {
                          _isTapped2 = false;
                        });
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          color:
                              _isTapped2
                                  ? Color.fromRGBO(255, 193, 7, 1)
                                  : Colors.white70,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
