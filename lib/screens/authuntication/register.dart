import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shafi_app/Config/config.dart';
import 'package:shafi_app/DialogBox/errorDialog.dart';
import 'package:shafi_app/DialogBox/loadingDialog.dart';
import 'package:shafi_app/screens/home/Home_screen.dart';
import 'package:shafi_app/widgets/customTextField.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingController =
      new TextEditingController();
  final TextEditingController _emailTextEditingController =
      new TextEditingController();
  final TextEditingController _passwordTextEditingController =
      new TextEditingController();
  final TextEditingController _cPasswordTextEditingController =
      new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 8.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                        handleSignUp();
                      },
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'انشاء حساب جديد عبر الفيسبوك',
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
                  CustomTextField(
                    data: Icons.person,
                    controller: _nameTextEditingController,
                    isObsecure: false,
                    hintText: 'الاسم',
                  ),
                  CustomTextField(
                    data: Icons.email,
                    controller: _emailTextEditingController,
                    isObsecure: false,
                    hintText: 'البريد الالكتروني',
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: _passwordTextEditingController,
                    isObsecure: true,
                    hintText: 'كلمة المرور',
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: _cPasswordTextEditingController,
                    isObsecure: true,
                    hintText: 'تأكيد كلمة المرور',
                  ),
                  SizedBox(
                    width: 350.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.blue)),
                      onPressed: () {
                        _handleRegistration();
                      },
                      color: Colors.blue,
                      child: Text(
                        'انشاء حساب جديد',
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

  Future<void> _handleRegistration() async {
    _passwordTextEditingController.text == _cPasswordTextEditingController.text
        ? _emailTextEditingController.text.isNotEmpty &&
                _nameTextEditingController.text.isNotEmpty &&
                _passwordTextEditingController.text.isNotEmpty &&
                _cPasswordTextEditingController.text.isNotEmpty
            ? _registerUser()
            : displayDialogue("Please write the registration complete form..")
        : displayDialogue("Password do not match.");
  }

  void displayDialogue(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }



  FirebaseAuth _auth = FirebaseAuth.instance;

  void _registerUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(message: 'Registering, Please wait.....');
        });
    User firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
            email: _emailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((auth) {
      firebaseUser = auth.user;
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
          .setString(ShafiApp.userName, _nameTextEditingController.text.trim());
      await ShafiApp.sharedPreferences.setString(
          ShafiApp.userEmail, _emailTextEditingController.text.trim());
      Navigator.pop(context);
      Route route = MaterialPageRoute(builder: (c) => HomeScreen());
      Navigator.pushReplacement(context, route);
    }
  }

  Future<void> handleSignUp() async {
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
          await signUpWithfacebook(result);
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

  Future signUpWithfacebook(FacebookLoginResult result) async {
    final FacebookAccessToken accessToken = result.accessToken;
    AuthCredential credential =
        FacebookAuthProvider.credential(accessToken.token);
    var a = await _auth.signInWithCredential(credential);
    ShafiApp.user = a.user;
  }
}
