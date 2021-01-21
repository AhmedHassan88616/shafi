import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shafi_app/Config/config.dart';
import 'package:shafi_app/DialogBox/errorDialog.dart';
import 'package:shafi_app/DialogBox/loadingDialog.dart';
import 'package:shafi_app/screens/home/Home_screen.dart';
import 'package:shafi_app/widgets/customTextField.dart';
import 'dart:developer';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTextEditingController =
      new TextEditingController();
  final TextEditingController _passwordTextEditingController =
      new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    data: Icons.email,
                    controller: _emailTextEditingController,
                    isObsecure: false,
                    hintText: 'البريد الالكتوني',
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: _passwordTextEditingController,
                    isObsecure: true,
                    hintText: 'كلمة المرور',
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    width: 350.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.blue),
                      ),
                      onPressed: () {
                        handleLogin();
                      },
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'تسجيل الدخول عبر الفيسبوك',
                            style: TextStyle(color: Colors.white),
                          ),
                          Image.asset(
                            'images/f.png',
                            height: 40.0,
                            width: 40.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    width: 350.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.blue),
                      ),
                      onPressed: () {
                        _emailTextEditingController.text.isNotEmpty &&
                                _passwordTextEditingController.text.isNotEmpty
                            ? _loginUser()
                            : showDialog(
                                context: context,
                                builder: (c) {
                                  return ErrorAlertDialog(
                                    message: 'Please write email and password',
                                  );
                                });
                      },
                      color: Colors.blue,
                      child: Text(
                        'تسجيل الدخول',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void _loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Authenticating, Please wait...",
          );
        });
    User firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
            email: _emailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: error.toString(),
          );
        },
      );
    });
    if (firebaseUser != null) {
      await ShafiApp.sharedPreferences
          .setString(ShafiApp.userUID, firebaseUser.uid);
      await ShafiApp.sharedPreferences
          .setString(ShafiApp.userName, firebaseUser.displayName);
      await ShafiApp.sharedPreferences
          .setString(ShafiApp.userEmail, firebaseUser.email);

      Navigator.pop(context);
      Route route = MaterialPageRoute(builder: (c) => HomeScreen());
      Navigator.pushReplacement(context, route);
    }
  }

  Future<void> handleLogin() async {
    final FacebookLoginResult result =
        await ShafiApp.facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        {
          showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(
                message: 'cancelledByUser',
              );
            },
          );
        }
        break;
      case FacebookLoginStatus.error:
        {
          showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(
                message: 'error',
              );
            },
          );
        }
        break;
      case FacebookLoginStatus.loggedIn:
        try {
          await loginWithfacebook(result);
          Route route = MaterialPageRoute(builder: (c) => HomeScreen());
          Navigator.pushReplacement(context, route);
        } catch (e) {
          showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(
                message: e.toString(),
              );
            },
          );
        }
        break;
    }
  }

  Future loginWithfacebook(FacebookLoginResult result) async {
    final FacebookAccessToken accessToken = result.accessToken;
    AuthCredential credential =
        FacebookAuthProvider.credential(accessToken.token);
    var a = await _auth.signInWithCredential(credential);
    ShafiApp.user = a.user;
  }
}
