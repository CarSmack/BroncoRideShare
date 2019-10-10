import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class authenticate {
  final FirebaseAuth _auth = FirebaseAuth.instance;
   String email,password;

   authenticate(String email,String password)
  {
    this.email = email;
    this.password = password;
//    _handleAuth();
  }

//
//  Future<FirebaseUser> _handleAuth() async{
//    FirebaseUser user = await _auth.currentUser();
////    if ()
}