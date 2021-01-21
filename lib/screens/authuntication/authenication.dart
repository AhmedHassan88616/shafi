import 'package:flutter/material.dart';
import 'package:shafi_app/widgets/appDrawer.dart';
import 'login.dart';
import 'register.dart';

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

enum Signing { signUp, signIn }

class _AuthenticScreenState extends State<AuthenticScreen> {
  Signing signing = Signing.signIn;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Container(
                height: 200.0,
                width: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      height: 160.0,
                      width: double.infinity,
                      color: Colors.blue[700],
                      alignment: Alignment.bottomCenter,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            signing == Signing.signIn
                                ? 'تسجيل الدخول'
                                : 'انشاء حساب جديد',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        'images/Group 205.png',
                        height: 100.0,
                        width: 100.0,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Login(),
                    Register(),
                  ],
                ),
              ),
              TabBar(
                onTap: (index) {
                  if (index == 0) {
                    setState(() {
                      signing = Signing.signIn;
                    });
                  } else {
                    setState(() {
                      signing = Signing.signUp;
                    });
                  }
                },
                labelColor: Colors.blue,
                tabs: [
                  Tab(
                    text: 'تسجيل الدخول',
                  ),
                  Tab(
                    text: 'انشاء حساب جديد',
                  ),
                ],
                indicatorColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorWeight: 5.0,
              ),
              SizedBox(height: 20.0,),
            ],
          ),
        ),
      ),
    );
  }
}
