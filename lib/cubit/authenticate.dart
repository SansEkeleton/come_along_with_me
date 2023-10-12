


import 'package:come_along_with_me/Pages/home_page.dart';
import 'package:come_along_with_me/Pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {

    if (_auth.currentUser != null) {
      return HomePage(uid: '',);
    } else {
      return LoginPage(uid: '',);
    }
  }
}