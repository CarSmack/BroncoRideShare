import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:broncorideshare/utils/googleMapDirectionRequest.dart';

class AppState with ChangeNotifier {
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  static LatLng _pickUpPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  GoogleMapController _mapController;
  GoogleMapDirectionRequest _googleMapsServices = GoogleMapDirectionRequest();
  TextEditingController locationTextController = TextEditingController();
  TextEditingController pickUpDestinationTextController =
      TextEditingController();
  TextEditingController finalDestinationTextController =
      TextEditingController();
  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  GoogleMapDirectionRequest get googleMapsServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyLines => _polyLines;

  //contructor to get the set the current location from geolocator
  AppState() {
    _getUserLocation();
  }
// ! TO GET THE USERS LOCATION
  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    _initialPosition = LatLng(position.latitude, position.longitude);
    locationTextController.text = placemark[0].name;
    notifyListeners();
  }

  //  To create route from polyLine parse from the JSON retrieved from Direction API
  void createRoute(String encondedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 10,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.blue));
    notifyListeners();
  }

  void clearRoute() {
    _polyLines.clear();
    _markers.clear();
    notifyListeners();
  }

  // Add Marker to the Map
  void addMarker(LatLng location, String address) {
    _markers.add(Marker(
        markerId: MarkerId(_lastPosition.toString()),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "go here"),
        icon: BitmapDescriptor.defaultMarker));
    notifyListeners();
  }

  void addMoreMarker(LatLng location, String address, String markerID) {
    _markers.add(Marker(
        markerId: MarkerId(markerID),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "go here"),
        icon: BitmapDescriptor.defaultMarker));
    notifyListeners();
  }

  // convert polyLine to LatLng
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // !DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  // send Request using Direction API to get the poly points from current location to Destionation
  void sendRequest(String intendedLocation) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);
    addMarker(destination, intendedLocation);
    String route = await _googleMapsServices.getRouteCoordinates(
        _initialPosition, destination);
    //Debug printing
    print("Route: $route");
    createRoute(route);
    notifyListeners();
  }

  void sendRequestFromPickUpLocationToFinalDestination(
      String pickUpLocation, String finalLocation) async {
    List<Placemark> placemarkForFinalLocation =
        await Geolocator().placemarkFromAddress(finalLocation);
    double finalLocationlatitude =
        placemarkForFinalLocation[0].position.latitude;
    double finalLocationlongitude =
        placemarkForFinalLocation[0].position.longitude;
    LatLng finalDestionation =
        LatLng(finalLocationlatitude, finalLocationlongitude);

    List<Placemark> placemarkForpickUplocation =
        await Geolocator().placemarkFromAddress(pickUpLocation);
    double pickupLocationlatitude =
        placemarkForpickUplocation[0].position.latitude;
    double pickupLocationlongitude =
        placemarkForpickUplocation[0].position.longitude;
    LatLng pickUpDestination =
        LatLng(pickupLocationlatitude, pickupLocationlongitude);

    addMoreMarker(
        finalDestionation, finalLocation, finalDestionation.toString());
    print(
        "${pickUpDestination.toString()} and ${finalDestionation.toString()}");
    String route = await _googleMapsServices.getRouteCoordinates(
        pickUpDestination, finalDestionation);
    //Debug printing
    _pickUpPosition = pickUpDestination;
    print("Route2: $route");
    createRouteFromPickUpLocationToFinalDestination(route);
    notifyListeners();
  }

  void createRouteFromPickUpLocationToFinalDestination(String encondedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(_pickUpPosition.toString()),
        width: 10,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.blue));
    notifyListeners();
  }

  // make camera move when user move
  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;

    notifyListeners();
  }

  // create Google Map controller
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }
}
