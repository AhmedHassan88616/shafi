import 'package:flutter/material.dart';
import 'package:shafi_app/Config/config.dart';
import 'package:shafi_app/screens/authuntication/authenication.dart';
import 'package:shafi_app/screens/settings/setting_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [

          Container(
            padding: EdgeInsets.only(top: 1.0),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Color(0xFF3DBCA7), Color(0xFF007AE7)],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(

              children: [
                SizedBox(
                  height: 10.0,
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    ShafiApp.auth.signOut().then((value) async {
                      await ShafiApp.facebookLogin.logOut();
                      Route route =
                          MaterialPageRoute(builder: (_) => AuthenticScreen());
                      Navigator.pushReplacement(context, route);
                    });
                  },
                ),


                SizedBox(
                  height: 5.0,
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(
                    'Settings',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    ShafiApp.auth.signOut().then((value) async {
                      await ShafiApp.facebookLogin.logOut();
                      Route route =
                      MaterialPageRoute(builder: (_) => SettingScreen());
                      Navigator.push(context, route);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
