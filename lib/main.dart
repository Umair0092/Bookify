import 'package:bookify/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      
      home: login(),
      
      //theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      //home:  PaymentPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(255, 193, 7, 1)),
        fontFamily: "Poppins"
      ),
      //theme: ThemeData.dark(),
      title: "Bookify",
      debugShowCheckedModeBanner: false,




    );
  }
}
