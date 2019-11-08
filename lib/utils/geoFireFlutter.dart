import 'package:broncorideshare/users/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class geoFlutterFire {
  static Firestore _firestore = Firestore.instance;
  static Geoflutterfire geo = Geoflutterfire();
  static var collectionReference = _firestore.collection('locations');
  var geoRef = geo.collection(collectionRef: collectionReference);
  FirebaseAuth _auth = FirebaseAuth.instance;


  void queryPassengerFromFirebase(GeoFirePoint currentLocation){
    var stream = geoRef.within(center: currentLocation, radius: 50, field: 'position', strictMode: true);
    stream.listen((onData){
      onData.length;
    });
  }

  Future<void> addGeoPointToFirebase(String pickUpLocation) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(pickUpLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    UserData userdata = UserData();
    _firestore.collection('passengerPickUpData').add({'username': 'passenger:${userdata.firebaseuser.email}', 'position': geo.point(latitude: latitude, longitude: longitude).data});
  }
}