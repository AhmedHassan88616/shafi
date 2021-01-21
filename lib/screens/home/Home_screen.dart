import 'package:flutter/material.dart';
import 'package:shafi_app/Config/config.dart';
import 'package:shafi_app/widgets/appDrawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          Text('شافي',style: TextStyle(fontSize: 20.0),),
          SizedBox(width: 5.0,),
          Image.asset(
            'images/s.png',
            height: 20.0,
            width: 20.0,
          ),
        ],),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("hello"),
            Text(ShafiApp.auth.currentUser.email),
          ],
        ),
      ),
    );
  }
}
