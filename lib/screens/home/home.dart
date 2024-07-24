import 'package:auth/model/brew.dart';
import 'package:auth/model/userId.dart';
import 'package:auth/screens/home/brew_list.dart';
import 'package:auth/screens/home/settings_form.dart';
import 'package:auth/services/auth.dart';
import 'package:auth/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: SettingsForm(),
            );
          });
    }

    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

    return StreamProvider<List<Brew>>.value(
      value: DatabaseService(uid: uid).brews,
      initialData: [],
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text("Coffee List",
              style: TextStyle(color: Colors.white)), // Change title text color
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.transparent, // Set button color to transparent
                    elevation: 0, // Remove button shadow
                  ),
                  icon:
                      Icon(Icons.person, color: Colors.white), // Set icon color
                  label: Text('Logout',
                      style: TextStyle(color: Colors.white)), // Set text color
                  onPressed: () async {
                    await _auth.signOut();
                  },
                ),
                SizedBox(height: 4), // Adjust spacing between icon and label
              ],
            ),
            SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.transparent, // Set button color to transparent
                    elevation: 0, // Remove button shadow
                  ),
                  icon: Icon(Icons.settings,
                      color: Colors.white), // Set icon color
                  label: Text('Settings',
                      style: TextStyle(color: Colors.white)), // Set text color
                  onPressed: () {
                    _showSettingsPanel();
                  },
                ),
                SizedBox(height: 4), // Adjust spacing between icon and label
              ],
            )
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/coffee_bg.png'),
                    fit: BoxFit.cover)),
            child: BrewList()),
      ),
    );
  }
}
