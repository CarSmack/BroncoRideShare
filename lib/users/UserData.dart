import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class UserData with ChangeNotifier {

   FirebaseAuth _auth = FirebaseAuth.instance;
   Future<AuthResult> _authResult;
   FirebaseUser firebaseuser;
  FirebaseAuth get auth => _auth;
  AuthResult result;
  PlatformException _onError;
  dynamic get onError => _onError;

  Future<AuthResult> singinUser(String _email, String _password)async{
    if(_auth.currentUser() != null)
      _auth.signOut();
    Future<AuthResult> result =  _auth.signInWithEmailAndPassword(email: _email, password: _password);
//    .then((onValue){
//      firebaseuser = onValue.user;
//    })
//    .catchError((onError)  {
//      _onError =  onError;
//    });
//    notifyListeners();
    result.then((onValue){
      firebaseuser = onValue.user;
    });
    notifyListeners();
    return result;
  }
  void signIn(String _email, String _password){
    _authResult = _auth.signInWithEmailAndPassword(email: _email, password: _password);
    notifyListeners();
  }
  Future<AuthResult> getResult(){
    return _authResult;
  }
}