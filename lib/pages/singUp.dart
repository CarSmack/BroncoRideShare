import 'package:flutter/material.dart';
import 'package:broncorideshare/Widgets/FormCard.dart';

class signup extends StatefulWidget {
  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FormCard.deFault(),
    );
  }
}

