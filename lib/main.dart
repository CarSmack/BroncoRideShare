import 'package:broncorideshare/pages/authenPage.dart';
import 'package:broncorideshare/pages/mainPage.dart';
import 'package:broncorideshare/pages/introPage.dart';
import 'package:broncorideshare/utils/testGooglemap.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:broncorideshare/testing.dart';
import 'package:provider/provider.dart';
import 'package:broncorideshare/utils/app_state.dart';

//void main() => runApp(MyApp());

void main() {
  //this was add to ensure the data that we waited for are pushed into our app
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: AppState(),)
  ],
    child: MyApp(),));
}
var routes = <String, WidgetBuilder>{
  "/intro": (BuildContext context) => IntroScreen(),
};
class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bronco RideShare',
      theme: ThemeData(

        primaryColor: Colors.red,
        accentColor: Colors.yellowAccent,
      ),
      debugShowCheckedModeBanner: false,
//      home: WelcomeScreen(),
      home: mainPage(),
//        home: WelcomeScreen(),
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
    Timer(Duration(seconds: 2), ()=> Navigator.pushNamed(context, "/intro"));
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


//import 'dart:async';
//
//import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//
//void main() => runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Google Maps Demo',
//      home: MapSample(),
//    );
//  }
//}
//
//class MapSample extends StatefulWidget {
//  @override
//  State<MapSample> createState() => MapSampleState();
//}
//
//class MapSampleState extends State<MapSample> {
//  Completer<GoogleMapController> _controller = Completer();
//
//  static final CameraPosition _kGooglePlex = CameraPosition(
//    target: LatLng(37.42796133580664, -122.085749655962),
//    zoom: 14.4746,
//  );
//
//  static final CameraPosition _kLake = CameraPosition(
//      bearing: 192.8334901395799,
//      target: LatLng(37.43296265331129, -122.08832357078792),
//      tilt: 59.440717697143555,
//      zoom: 19.151926040649414);
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      body: GoogleMap(
//        mapType: MapType.hybrid,
//        initialCameraPosition: _kGooglePlex,
//        onMapCreated: (GoogleMapController controller) {
//          _controller.complete(controller);
//        },
//      ),
//      floatingActionButton: FloatingActionButton.extended(
//        onPressed: _goToTheLake,
//        label: Text('To the lake!'),
//        icon: Icon(Icons.directions_boat),
//      ),
//    );
//  }
//
//  Future<void> _goToTheLake() async {
//    final GoogleMapController controller = await _controller.future;
//    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//  }
//}
