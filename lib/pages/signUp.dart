import 'package:broncorideshare/Widgets/FormCardSignUp.dart';
import 'package:broncorideshare/utils/authenticate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class signup extends StatefulWidget {

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final keyPassword = GlobalKey<FormFieldState>();
  final keyEmail = GlobalKey<FormFieldState>();

  //This will return FirebaseUser
  Future<FirebaseUser> _handleRegister(emails,passwords) async{
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: emails,
      password: passwords,
    ))
        .user;
    return user;
  }




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
                FormCardSignup(keyEmail,keyPassword),
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
                            onTap: () async{
                              keyEmail.currentState.validate();
                              keyPassword.currentState.validate();
                                  FirebaseUser user = await _handleRegister(keyEmail.currentState.value.toString().trim(), keyPassword.currentState.value.toString().trim());
//                                  FirebaseUser user1 = await _auth.currentUser();
//                                  print('user123:    ${user1.toString()}');
                                    assert(user != null);
                                   user.sendEmailVerification();

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
            )
        )
    );
  }
}