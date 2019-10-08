import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class register {
  final FirebaseAuth _auth = FirebaseAuth.instance;
   String email,password;

   register(String email,String password)
  {
    this.email = email;
    this.password = password;
    _handleRegister();
  }


  Future<FirebaseUser> _handleRegister() async{
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: this.email,
      password: this.password,
    ))
        .user;
  }

}