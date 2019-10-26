import 'dart:async';
import 'dart:ffi';

import 'package:broncorideshare/pages/mainPage.dart';
import 'package:broncorideshare/pages/signUp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:broncorideshare/Widgets/FormCard.dart';
import 'package:firebase_auth/firebase_auth.dart';

//enum authenProblem{ERROR_USER_NOT_FOUND,ERROR_WRONG_PASSWORD};
class authenticationPage extends StatefulWidget {


  @override
  _authenticationPageState createState() => _authenticationPageState();
}

class _authenticationPageState extends State<authenticationPage> {
  bool _isSelected = false;
  String _email,_password;
  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }
  void _showCupertinoDialog(dynamic error) {
    var text1,text2;
    var authenerror = {
      'user_error': 'User not found',
      'userErrorMessage': 'Please input a correct email address',
      'password_error': 'Incorrect Password',
      'passwordErrorMessage': 'Please reenter your password again'

    };
    switch(error){
      case "ERROR_USER_NOT_FOUND":
        text1 = authenerror['user_error'];
        text2 = authenerror['userErrorMessage'];
        break;
      case "ERROR_WRONG_PASSWORD":
        text1 = authenerror['password_error'];
        text2 = authenerror['passwordErrorMessage'];
        break;

    }
    assert(text1 != null && text2 != null);
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(text1),
            content: Text(text2),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close')),
            ],
          );
        });
  }


  Widget radioButton(bool isSelected) => Container(
    width: 16.0,
    height: 16.0,
    padding: EdgeInsets.all(2.0),
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2.0, color: Colors.black)),
    child: isSelected
        ? Container(
      width: double.infinity,
      height: double.infinity,
      decoration:
      BoxDecoration(shape: BoxShape.circle, color: Colors.black),
    )
        : Container(),
  );

  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: ScreenUtil.getInstance().setWidth(120),
      height: 1.0,
      color: Colors.black26.withOpacity(.2),
    ),
  );
  final _formfieldKey_email = GlobalKey<FormFieldState>();
  final _formfieldKey_password = GlobalKey<FormFieldState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth =  FirebaseAuth.instance;
  FirebaseUser user;

//  Future<FirebaseUser> _handleSignIn(String email, String password) async {
//    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//    
//    final emailAuthentication = await _auth.signInWithEmailAndPassword(email: email, password: password);
//
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      accessToken: googleAuth.accessToken,
//      idToken: googleAuth.idToken,
//    );
//
//    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
//    print("signed in " + user.displayName);
//    return user;
//  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body:Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.only(top:20.0),
//                child: Image.asset("assets/image_01.png"),
//              ),
              Expanded(
                child:Container(),
              ),
              Image.asset("assets/image_02.png"),
            ],

          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(Icons.directions_car,
                      size: 50,),
                      Text("Bronco Rideshare",
                          style: TextStyle(
                              fontFamily: "Poppins-Bold",
                              fontSize: ScreenUtil.getInstance().setSp(46),
                              letterSpacing: .6,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(180),
                  ),
                  FormCard(_formfieldKey_email,_formfieldKey_password),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 12.0,
                          ),
                          GestureDetector(
                            onTap: _radio,
                            child: radioButton(_isSelected),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text("Remember me",
                              style: TextStyle(
                                  fontSize: 12, fontFamily: "Poppins-Medium"))
                        ],
                      ),
                      InkWell(
                        child: Container(
                          width: ScreenUtil.getInstance().setWidth(330),
                          height: ScreenUtil.getInstance().setHeight(100),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xFF17ead9),
                                Color(0xFF6078ea)
                              ]),
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
                                if (_formfieldKey_email.currentState.validate() && _formfieldKey_password.currentState.validate()){
                                  Future<AuthResult> result =  _auth.signInWithEmailAndPassword(email: _formfieldKey_email.currentState.value, password: _formfieldKey_password.currentState.value)
                                  .then((value) {
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Login Success'),behavior: SnackBarBehavior.floating,));
                                    user = value.user;
                                    Timer _time = new Timer(Duration(seconds: 3), (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> mainPage()));



                                    });


                                  })
                                      .catchError((onError) {
                                    _showCupertinoDialog(onError.code);
                                  });
                                }

                              },
                              child: Center(
                                child: Text("SIGNIN",
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
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(100),
                  ),
//
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "New User? ",
                        style: TextStyle(fontFamily: "Poppins-Medium"),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> signup()));
                        },
                        child: Text("SignUp",
                            style: TextStyle(
                                color: Color(0xFF5d74e3),
                                fontFamily: "Poppins-Bold")),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}

