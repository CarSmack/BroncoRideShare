import 'package:broncorideshare/Widgets/FormCardSignUp.dart';
import 'package:broncorideshare/utils/authenticate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
class signup extends StatefulWidget {
  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {

  // FirebaseAuth//
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final keyPassword = GlobalKey<FormFieldState>();
  final keyEmail = GlobalKey<FormFieldState>();
  final keyAddress = GlobalKey<FormFieldState>();
  final keyPhone = GlobalKey<FormFieldState>();
  //This will return FirebaseUser
  Future<FirebaseUser> _handleRegister(emails, passwords) async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: emails,
      password: passwords,
    ))
        .user;
    return user;
  }
// ----End of Firebase Authentication------


  //Firestore
  Firestore firestore = Firestore.instance;
  void addUserInfo(String email,String password, String address, String phoneNum)
  {
    Map<String,dynamic> data = {
      'email': email,
      'password': password,
      'address': address,
      'phone':  phoneNum,
      'driver': true,

  };
    firestore.collection('users').document('${data['email']}').setData(data);

  }
  _launchURL() async {
    const url = 'https://outlook.live.com/owa/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



  // ---------End of firestore--------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Sign Up'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SizedBox(height: ScreenUtil.getInstance().setHeight(60)),
            FormCardSignup(keyEmail, keyPassword, keyAddress, keyPhone),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                InkWell(
                  child: Container(
                    width: ScreenUtil.getInstance().setWidth(330),
                    height: ScreenUtil.getInstance().setHeight(100),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
                        borderRadius: BorderRadius.circular(6.0),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFF6078ea).withOpacity(.3),
                              offset: Offset(0.0, 8.0),
                              blurRadius: 8.0)
                        ]),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          keyEmail.currentState.validate();
                          keyPassword.currentState.validate();
                          FirebaseUser user = await _handleRegister(
                              keyEmail.currentState.value.toString().trim(),
                              keyPassword.currentState.value.toString().trim());
                          assert(user != null);
                          user.sendEmailVerification();
                          addUserInfo(keyEmail.currentState.value, keyPassword.currentState.value, keyAddress.currentState.value, keyPhone.currentState.value);
                          _launchURL();
                        },
                        child: Center(
                          child: Text("Sign Up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins-Bold",
                                  fontSize: 18,
                                  letterSpacing: 1.0)),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        )));
  }
}
