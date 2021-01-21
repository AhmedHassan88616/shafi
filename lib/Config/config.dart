import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShafiApp {
  static const String appName = 'Shafi';

  static SharedPreferences sharedPreferences;
  static User user;
  static FirebaseAuth auth;
  static FacebookLogin facebookLogin = FacebookLogin();

  static final String userName = 'name';
  static final String userEmail = 'email';
  static final String userPhotoUrl = 'photoUrl';
  static final String userUID = 'uid';
  static final String userAvatarUrl = 'url';
}
