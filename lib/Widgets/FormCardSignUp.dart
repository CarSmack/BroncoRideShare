import 'package:broncorideshare/pages/singUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:broncorideshare/utils/register.dart';

import 'package:firebase_auth/firebase_auth.dart';

class FormCardSignup extends StatefulWidget {
  // dynamic was use rather than final to set a parameter for Formcart to grab Formfieldstate to implement validate() whenever call the Class
  dynamic keyPassword = GlobalKey<FormFieldState>();
  dynamic keyEmail = GlobalKey<FormFieldState>();
   String _email, _password ;
  //Constructor-----------
  FormCardSignup(this.keyEmail,this.keyPassword);
  //this is made when Formcard does not need to return formfieldstate






  @override
  _FormCardSignupState createState() => _FormCardSignupState();
}


class _FormCardSignupState extends State<FormCardSignup> {

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      height: ScreenUtil.getInstance().setHeight(500),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0),
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -10.0),
                blurRadius: 10.0),
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Login",
                style: TextStyle(
                    fontSize: ScreenUtil.getInstance().setSp(45),
                    fontFamily: "Poppins-Bold",
                    letterSpacing: .6)),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text("Email",
                style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(26))),
            TextFormField(
              key: widget.keyEmail,
              validator: (String value) {
                return value.contains('@cpp.edu')
                    ? null
                    : 'Please use cpp email for Login';
              },
              onSaved: (String value) {
//                email = value;
                  widget._email = value;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: "Billy@cpp.edu",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text("Password",
                style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(26))),
            TextFormField(
              key: widget.keyPassword,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              validator: (String value) {
                return value.length > 6
                    ? null
                    : 'Password should be more than 6 character';
              },
              onSaved: (String value) {

                 widget._password = value;
//                    widget.setPass(value);

              },
              decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
//            SizedBox(
//              height: ScreenUtil.getInstance().setHeight(35),
//            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.end,
//              children: <Widget>[
//                Text(
//                  "Forgot Password?",
//                  style: TextStyle(
//                      color: Colors.blue,
//                      fontFamily: "Poppins-Medium",
//                      fontSize: ScreenUtil.getInstance().setSp(28)),
//                )
//              ],
//            )
          ],
        ),
      ),
    );
  }
}
