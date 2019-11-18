import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class GoogleMapDirectionRequest {
  static String apiKey ;
  GoogleMapDirectionRequest()
  {
    Firestore.instance.collection('apiKey').document('placeAPI').get().then((onValue){
      apiKey = onValue.data['key'];
    });
  }
  
  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
    print(url);
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    print(
        "${l1.latitude} , ${l1.longitude} &&& ${l2.latitude} , ${l2.longitude}");

    return values["routes"][0]["overview_polyline"]["points"];
  }
}
