import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shafi_app/screens/authuntication/authenication.dart';
import 'package:shafi_app/screens/home/Home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Config/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ShafiApp.auth = FirebaseAuth.instance;
  SharedPreferences.setMockInitialValues({});
  ShafiApp.sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    displayScreen();
    super.initState();
  }

  void displayScreen() {
    Timer(Duration(seconds: 3), () async {
      if (await ShafiApp.auth.currentUser != null) {
        Route route = MaterialPageRoute(builder: (_) => HomeScreen());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Color(0xFF3DBCA7), Color(0xFF007AE7)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/Group 205.png',
                height: 240.0,
                width: 240.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
