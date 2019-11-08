import 'package:broncorideshare/users/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

class geoFlutterFire {
  static Firestore _firestore = Firestore.instance;
  static Geoflutterfire geo = Geoflutterfire();
  static var collectionReference = _firestore.collection('locations');
  var geoRef = geo.collection(collectionRef: collectionReference);


  void queryPassengerFromFirebase(GeoFirePoint currentLocation){
    var stream = geoRef.within(center: currentLocation, radius: 50, field: 'position', strictMode: true);
    stream.listen((onData){
      onData.length;
    });
  }
  /*
  * Get a LatLg of a location and push the data into the FireStore Database*/
  Future<void> addPickUpRequestToFirebase(String pickUpLocation, UserData userdata, String date, String time) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(pickUpLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    print('userdata firebaseuser from geoflutterfire ${userdata.firebaseuser.email}');
    print('latitude of pickuplocation ${latitude}');
    print('longitude of pickuplocation ${longitude}');
    _firestore.collection('passengerPickUpData').add(
        {'username': '${userdata.firebaseuser.email}',
          'position': geo.point(latitude: latitude, longitude: longitude).data,
          'date' : date,
          'time' : time,
        });
  }
}