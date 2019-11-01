import 'package:broncorideshare/pages/passenger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:broncorideshare/pages/driver.dart';
class decision extends StatefulWidget {
  @override
  _decisionState createState() => _decisionState();
}

class _decisionState extends State<decision> {
  bool driver;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.greenAccent,
        body:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FlatButton(
                child: Column(
                  children: <Widget>[
                    Text("Are you a ...", textScaleFactor: 2.0,)
                  ],
                ),

              ),
              SizedBox(
                height: 50,
              ),

              FlatButton(
                onPressed: (){
                  setState(() {
                    driver = true;
                  });

//                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Great!"),));
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Driver()));
                },
                color: Colors.orange,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.bookmark),
                    Text("Driver")
                  ],
                ),
              ),
              FlatButton(
                onPressed: (){
                  setState(() {
                    driver =false;
                  });
//                  Scaffold.of(context).
//                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Great!"),behavior: SnackBarBehavior.floating,));
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Passenger()));
                },
                color: Colors.blueGrey,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.bookmark),
                    Text("Passenger")
                  ],
                ),
              )

            ],
          ),
        )

      );
  }
  }
