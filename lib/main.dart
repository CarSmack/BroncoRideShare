import 'package:broncorideshare/introPage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
void main() => runApp(MyApp());
var routes = <String, WidgetBuilder>{
  "/intro": (BuildContext context) => IntroScreen(),
};
class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bronco RideShare',
      theme: ThemeData(

        primaryColor: Colors.red,
        accentColor: Colors.yellowAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      routes: routes,
    );
  }
}
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), ()=> Navigator.pushNamed(context, "/intro"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.greenAccent),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Icon(
                          Icons.directions_car,
                          color: Colors.blueGrey,
                          size: 50.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:10.0),
                      ),
                      Text(
                        "Bronco RideShare", style: TextStyle(color: Colors.white
                      ,fontSize: 24.0,fontWeight:FontWeight.bold)
                      )

                    ],
                  ),
                ),

              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(padding: EdgeInsets.only(top:20.0),
                    ),
                    Text("Rideshare App \n For Cal Poly Pomona Students",
                      style: TextStyle(color:Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )

            ],

          )

        ],
      )

    );
  }
}
