import 'package:broncorideshare/pages/signUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:broncorideshare/utils/authenticate.dart';

import 'package:firebase_auth/firebase_auth.dart';

class FormCardSignup extends StatefulWidget {
  // dynamic was use rather than final to set a parameter for Formcart to grab Formfieldstate to implement validate() whenever call the Class
  dynamic keyPassword = GlobalKey<FormFieldState>();
  dynamic keyEmail = GlobalKey<FormFieldState>();
  dynamic keyAddress = GlobalKey<FormFieldState>();

  dynamic keyPhone = GlobalKey<FormFieldState>();
   String _email, _password,_address,_phoneNum ;
  //Constructor-----------
  FormCardSignup(this.keyEmail,this.keyPassword,this.keyAddress,this.keyPhone);
  //this is made when Formcard does not need to return formfieldstate






  @override
  _FormCardSignupState createState() => _FormCardSignupState();
}


class _FormCardSignupState extends State<FormCardSignup> {

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      height: ScreenUtil.getInstance().setHeight(600),
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
            Center(
              child: Text("Please fill in the following information :",
              style: TextStyle(
                  fontFamily: "Poppins-Medium",
                  fontSize: ScreenUtil.getInstance().setSp(26))),
            ),
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
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text("Home Address",
                style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(26))),
            TextFormField(
              key: widget.keyAddress,

              keyboardType: TextInputType.multiline,

              onSaved: (String value) {

                widget._address= value;

              },
              decoration: InputDecoration(
                  hintText: "3801 W Temple Ave, Pomona, CA 91768",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text("Phone number",
                style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(26))),
            TextFormField(
              key: widget.keyPhone,
              keyboardType: TextInputType.phone,

              onSaved: (String value) {

                widget._phoneNum= value;

              },
              decoration: InputDecoration(
                  hintText: "213-123-3123",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),

          ],
        ),
      ),
    );
  }
}
