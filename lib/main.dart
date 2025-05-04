import 'package:bookify/Screens/Home.dart';
import 'package:bookify/Screens/events/events.dart';
import 'package:bookify/Screens/localservice/localservices.dart';
import 'package:bookify/Screens/login.dart';
import 'package:bookify/Screens/profilepage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      
      home: home(),
       locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
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

