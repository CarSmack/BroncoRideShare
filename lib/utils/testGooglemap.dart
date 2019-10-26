import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class testGoogleMap extends StatefulWidget {
  @override
  _testGoogleMapState createState() => _testGoogleMapState();
}

class _testGoogleMapState extends State<testGoogleMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Map1(),
    );
  }
}
class Map1 extends StatefulWidget {
  @override
  _Map1State createState() => _Map1State();
}

class _Map1State extends State<Map1> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.hybrid,
            initialCameraPosition:CameraPosition(
              target: LatLng(37.42796133580664, -122.085749655962),
              zoom: 14.4746,),



        )
      ],
    );
  }
}
