import 'package:bookify/Screens/Colors.dart';
import 'package:bookify/Screens/Home.dart';
import 'package:bookify/Screens/SignUp.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';


//import 'package:flutter_signin_button/button_view.dart';
import '../services/Auth.dart';
import '../services/login_info.dart';
import 'package:sign_button/sign_button.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isTapped = false;
  bool _isTapped2 = false;
  bool _isloading=false;
  final FirebaseAuth _auth=FirebaseAuth.instance;

  Future<void> _login() async{
    if(_formKey.currentState!.validate()){
      setState(() {
        _isloading = true;
      });
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
        }
        setState(() {
          _isloading = false;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>home()));
      }on FirebaseAuthException catch(e){
        String message;
        debugPrint('Login error: $e');
        switch (e.code) {
          case 'user-not-found':
            message = 'No user found with this email.';
            break;
          case 'wrong-password':
            message = 'Incorrect password.';
            break;
          case 'invalid-email':
            message = 'The email address is not valid.';
            break;
          case 'user-disabled':
            message = 'This user account has been disabled.';
            break;
          default:
            message = 'An error occurred. Please try again.';
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
        setState(() {
          _isloading = false;
        });
    }
      }
  }

  Future<void> _Passwordreset()async{
    final TextEditingController _resetEmailController = TextEditingController();
    bool _dialogLoading = false;
    await showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(builder: (context,setState){
          return AlertDialog(
            title: const Text('Reset Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _resetEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                if (_dialogLoading) ...[
                  const SizedBox(height: 16.0),
                  const CircularProgressIndicator(),
                ],
              ],

            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width/1.5,
                  padding: EdgeInsets.symmetric(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFFFD700),
                  ),
                  child: Center(child: Text("Cancel ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),)),
                ),
              ),
              TextButton(
                onPressed: () async{
                  if(_resetEmailController.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter your email address.")));
                    return;
                  };
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(_resetEmailController.text.trim())) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter a valid email address.')),
                    );
                    return;
                  }
                  setState(() {
                    _dialogLoading = true;
                  });
                  try{
                    await FirebaseAuth.instance.sendPasswordResetEmail(email: _resetEmailController.text.trim());
                    if(mounted){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password reset email sent! Check your inbox.")));
                    }
                    Navigator.pop(context);
                  } on FirebaseAuthException catch (e){
                    String message;
                    switch (e.code) {
                      case 'user-not-found':
                        message = 'No user found with this email.';
                        break;
                      case 'invalid-email':
                        message = 'The email address is not valid.';
                        break;
                      default:
                        message = 'An error occurred. Please try again.';
                    }
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                  }finally {
                    if (mounted) {
                      setState(() {
                        _dialogLoading = false;
                      });
                    }
                  }

                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width/1.5,
                  padding: EdgeInsets.symmetric(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFFFD700),
                  ),
                  child: Center(child: Text("Confirm ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),)),
                ),
              ),
            ],
          );
        });
      }
    );

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
                margin:EdgeInsets.fromLTRB(0, 100, 0, 0),
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
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

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
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
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 140),
                child: GestureDetector(
                  onTap: _Passwordreset,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color:
                          _isTapped
                              ? Color(0xFFFFD700)
                              : Colors.white70,
                      fontSize: 16,
                      decoration:
                          TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              _isloading
                  ? const CircularProgressIndicator()
                  : Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 1.5,
                child: ElevatedButton(
                 onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Color(0xFFFFD700),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Log in',
                    style: TextStyle(fontSize: 18.0,color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't Have Account?",style: TextStyle(color: Colors.white.withOpacity(0.7)),),
                    SizedBox(width: 5,),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup()));
                        print("Sign Up pressed");
                      },
                      onTapCancel: () {
                        setState(() {
                          _isTapped2 = false;
                        });
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color:
                          _isTapped2
                              ? Color(0xFFFFD700)
                              : Colors.white70,
                          fontSize: 16,
                          decoration:
                          TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              SignInButton(
                  buttonType: ButtonType.google,
                  imagePosition: ImagePosition.right,
                  //[buttonSize] You can also use this in combination with [width]. Increases the font and icon size of the button.
                  buttonSize: ButtonSize.large,
                  btnTextColor: Colors.purple,
                  btnColor: Colors.white,
                  width: 240,
                  //[width] Use if you change the text value.
                  //btnText: 'Pinterest',
                  onPressed: () async{
                    await signInWithGoogle();
                    final User? currentUser=await _auth.currentUser;
                    LocalDataSaver.saveLoginData(true);
                    LocalDataSaver.saveImg(currentUser!.photoURL.toString());
                    LocalDataSaver.saveMail(currentUser.email.toString());
                    LocalDataSaver.saveName(currentUser.displayName.toString());
                    LocalDataSaver.saveSyncValue(false);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => home()),
                          (Route<dynamic> route) => false,
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
