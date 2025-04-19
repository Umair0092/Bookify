import 'package:bookify/views/Colors.dart';
import 'package:flutter/material.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool _isTapped = false;
  bool _isTapped2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Image.asset("images/logo.png", height: 250),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 50),
              Expanded(
                child: TextField(
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    //enabledBorder: InputBorder.none,

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
                  onSubmitted: (value) {},
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
                child: TextField(
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    //enabledBorder: InputBorder.none,

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
                  onSubmitted: (value) {},
                ),
              ),
              SizedBox(width: 50),
            ],
          ),
          SizedBox(height: 20,),
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
                  decoration:
                      TextDecoration.underline,
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
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

              print("Sign up Button Pressed");
            },
            onTapCancel: () {
              setState(() {
                _isTapped2 = false;
              });
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width/1.5,
              padding: EdgeInsets.symmetric(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _isTapped2
                    ? Color.fromRGBO(255, 193, 7, 0.8)
                    : Color.fromRGBO(255, 193, 7, 1),
              ),
              child: Center(child: Text("Sign Up",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),)),
            ),
          )
        ],
      ),
    );
  }
}
