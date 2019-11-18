import 'package:broncorideshare/pages/driverPage.dart';
import 'package:broncorideshare/pages/passengerPage.dart';
import 'package:flutter/material.dart';

class decisionPage extends StatefulWidget {
  @override
  _decisionPageState createState() => _decisionPageState();
}

class _decisionPageState extends State<decisionPage> {
  /*
  * boolean driver : To make sure that the user pick Driver or Passenger Page
   */
  bool driver;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.greenAccent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FlatButton(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Are you a ...",
                      textScaleFactor: 3.0,
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          driver = true;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => mainPage()));
                      },
                      color: Colors.orange,
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.airport_shuttle,
                            size: 50,
                          ),
                          Text(
                            "Driver",
                            textScaleFactor: 2.0,
                          )
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          driver = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Passenger()));
                      },
                      color: Colors.blueGrey,
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.person,
                            size: 50,
                          ),
                          Text(
                            "Passenger",
                            textScaleFactor: 2.0,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
