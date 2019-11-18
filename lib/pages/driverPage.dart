import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:broncorideshare/utils/appState.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:broncorideshare/users/UserData.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class mainPage extends StatefulWidget {
  @override
  _mainPageState createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: googleMap());
  }
}

class googleMap extends StatefulWidget {
  @override
  _googleMapState createState() => _googleMapState();
}

class _googleMapState extends State<googleMap> {
  static var geolocator = Geolocator();
  static var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  static bool liveButton = true;
  StreamSubscription<Position> streamSubscription;

  /**
   * Query Request within 20 miles
   */
  Geoflutterfire geo = Geoflutterfire();
  Firestore _firestore = Firestore.instance;
  var collectionReference;
  GeoFirePoint center;
  String apiKey;
  dynamic startingDestinationAddress;
  dynamic pickUpDestinationAddress;
  dynamic finalDestinationAddress;

  /**
   * addGooglePlace searching
   */
  addGooglePlaceSearching(dynamic destinationAddress,TextEditingController controller) async{
    Firestore.instance.collection("apiKey").document('placeAPI').get().then((onValue){
      apiKey = onValue.data['key'];
    }).catchError((onError){
      print("error firestore: ${onError}");
    });
    if(apiKey != null) {
      Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: apiKey,
        language: 'en',
        components: [Component(Component.country, "us")],
        // ignore: missing_return
      ).then((onValue) {
        print('Search description ${onValue.description}');
        destinationAddress = onValue.description;

        controller.text = destinationAddress;
      }).catchError((onError) {
        print('Error on AutoComplete : ${onError}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /*appState is for DI and State Management throuhgout the app with the Class Provider*/
    final appState = Provider.of<AppState>(context);
    final userdata = Provider.of<UserData>(context);

    /*Debug purpose to check the current position of the user*/
    print("Current position ${appState.lastPosition.toString()}");

    /*Check the Stream if the initialPosition have been initialized of not
    *   if not => Display a circular progress indicator
    *   if yes => Display a Google Map with a current position displayed the first TextField Box and the mark at the current position*/
    return appState.initialPosition == null
        ? Container(
            alignment: Alignment.center,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueGrey,
              ),
            ),
          )
        : Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: appState.initialPosition, zoom: 17.0),
                onMapCreated: appState.onCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                compassEnabled: true,
                markers: appState.markers,
                onCameraMove: appState.onCameraMove,
                polylines: appState.polyLines,
              ),
              Positioned(
                top: 50.0,
                right: 15.0,
                left: 15.0,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 5.0),
                          blurRadius: 10,
                          spreadRadius: 3)
                    ],
                  ),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: appState.locationTextController,
                    onTap: ()async{
                      addGooglePlaceSearching(startingDestinationAddress, appState.locationTextController);
                    },
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20, top: 5),
                        width: 10,
                        height: 10,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.black,
                        ),
                      ),
                      hintText: "Starting destination",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 105.0,
                right: 15.0,
                left: 15.0,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 5.0),
                          blurRadius: 10,
                          spreadRadius: 3)
                    ],
                  ),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: appState.pickUpDestinationTextController,
                    onTap: ()async{
                      addGooglePlaceSearching(pickUpDestinationAddress, appState.pickUpDestinationTextController);
                    },
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      appState.sendRequest(value);
                    },
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20, top: 5),
                        width: 10,
                        height: 10,
                        child: Icon(
                          Icons.local_taxi,
                          color: Colors.black,
                        ),
                      ),
                      hintText: "Pick Up Location",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 160.0,
                right: 15.0,
                left: 15.0,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 5.0),
                          blurRadius: 10,
                          spreadRadius: 3)
                    ],
                  ),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: appState.finalDestinationTextController,
                    onTap: ()async{
                      addGooglePlaceSearching(finalDestinationAddress, appState.finalDestinationTextController);
                    },
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      if (appState.finalDestinationTextController != null) {
                        print(
                            'debug third textfield ${appState.finalDestinationTextController.text} and $value');
                        print(
                            'debug third textfield ${appState.pickUpDestinationTextController.text}');
                        appState
                            .sendRequestFromPickUpLocationToFinalDestination(
                                appState.pickUpDestinationTextController.text,
                                value);
                      }
                    },
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20, top: 5),
                        width: 10,
                        height: 10,
                        child: Icon(
                          Icons.local_taxi,
                          color: Colors.black,
                        ),
                      ),
                      hintText: "Final Destination",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 125,
                child: Column(
                  children: <Widget>[
                    FloatingActionButton(
                      child: Icon(Icons.search),
                      heroTag: 'buttonFind1',
                      backgroundColor: Colors.white,
                      splashColor: Colors.blue,
                      onPressed: () async{
                        Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                        center = geo.point(latitude: position.latitude, longitude: position.longitude);
                        print("position : ${center.latitude}  ${center.longitude}");
                        showModalBottomSheet(context: context, builder: (context){
                          return Container(
                            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                            height: MediaQuery.of(context).size.height,
                            child: StreamBuilder<List<DocumentSnapshot>>(
                              stream: geo.collection(collectionRef: Firestore.instance.collection("passengerPickUpData")).within(center: center, radius: 40, field: 'position',strictMode: true),
                              builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot){
                                if(snapshot.hasError)
                                  return Text("Error: ${snapshot.error}");
                                switch (snapshot.connectionState){
                                  case ConnectionState.waiting:
                                    return Text("Loading ...");
                                  default:
                                    return ListView(
                                      children: snapshot.data.where((test){
                                        if (test.data['rideStatus'] ==
                                            'pending' &&
                                            test.data['username'] !=
                                                userdata.firebaseuser.email)
                                          return true;
                                        else if (test.data['driverID'] ==
                                            userdata
                                                .firebaseuser.email &&
                                            test.data['rideStatus'] ==
                                                'accept')
                                          return true;
                                        else
                                          return false;
                                      }).map((DocumentSnapshot document){
                                        return Card(
                                          child: ExpansionTile(
                                            title: Text("${document['username']} (${document['rideStatus']})",style: TextStyle(color: Colors.black)),
                                            trailing: Icon(Icons.more_vert, color: Colors.black),
                                            children: <Widget>[
                                              FlatButton(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Column(
                                                      children: <Widget>[
                                                        Text(
                                                            'Address: ${document['address']}'),
                                                        Text(
                                                            'Date: ${document['date']}'),
                                                        Text(
                                                            'Time: ${document['time']}'),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child:
                                                          RaisedButton(
                                                            child: Text(
                                                                "See On Map"),
                                                            onPressed: () {
//
                                                              GeoPoint
                                                              passengerLatLng =
                                                              document[
                                                              'position']
                                                              [
                                                              'geopoint'];
                                                              print(
                                                                  '${passengerLatLng.latitude}  : ${passengerLatLng.longitude}');
                                                              appState.addMarker(
                                                                  LatLng(
                                                                      passengerLatLng
                                                                          .latitude,
                                                                      passengerLatLng
                                                                          .longitude),
                                                                  document[
                                                                  'address']);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child:
                                                          RaisedButton(
                                                            child: Text(
                                                                "Accept"),
                                                            onPressed: () {
                                                              String
                                                              _documentID =
                                                                  document
                                                                      .documentID;
                                                              TextEditingController
                                                              _textFieldController =
                                                              TextEditingController();
                                                              Firestore
                                                                  .instance
                                                                  .collection(
                                                                  'users')
                                                                  .document(
                                                                  '${document['username']}')
                                                                  .get()
                                                                  .then(
                                                                      (onValue) {
                                                                    showDialog(
                                                                        context:
                                                                        context,
                                                                        builder:
                                                                            (context) {
                                                                          if (document['rideStatus'] ==
                                                                              'accept') {
                                                                            return AlertDialog(
                                                                              title: Text("You already accepted the request!"),
                                                                              content: Text("Passenger Info: \n"
                                                                                  "Name: ${onValue.data['name']}\n"
                                                                                  "Email: ${onValue.data['email']}\n"
                                                                                  "Phone: ${onValue.data['phone']}"),
                                                                              actions: <Widget>[
                                                                                FlatButton(
                                                                                  child: Text("Close"),
                                                                                  onPressed: () => Navigator.pop(context),
                                                                                )
                                                                              ],
                                                                            );
                                                                          } else {
                                                                            return AlertDialog(
                                                                              title: Text('Note to passenger:'),
                                                                              content: TextField(
                                                                                controller: _textFieldController,
                                                                                decoration: InputDecoration(hintText: "Optional"),
                                                                              ),
                                                                              actions: <Widget>[
                                                                                new FlatButton(
                                                                                  child: new Text('Confirm'),
                                                                                  onPressed: () {
                                                                                    Firestore.instance.collection('passengerPickUpData').document(_documentID).updateData({
                                                                                      'driverID': '${userdata.firebaseuser.email}',
                                                                                      'rideStatus': 'accept',
                                                                                      'driverNote': _textFieldController.value.text,
                                                                                    });
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                )
                                                                              ],
                                                                            );
                                                                          }
                                                                        });
                                                                  });
                                                            },
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child:
                                                          RaisedButton(
                                                            child: Text(
                                                                'Get Direction'),
                                                            onPressed: () {
                                                              appState.pickUpDestinationTextController
                                                                  .text =
                                                              document[
                                                              'address'];
                                                              Navigator.pop(
                                                                  context);
                                                              appState.sendRequest(
                                                                  '${document['address']}');
                                                              appState.finalDestinationTextController
                                                                  .text =
                                                              "Cal Poly Pomona";
                                                              appState.sendRequestFromPickUpLocationToFinalDestination(
                                                                  document[
                                                                  'address'],
                                                                  appState
                                                                      .finalDestinationTextController
                                                                      .text);
//                                                              appState.mapController.moveCamera(CameraUpdate.zoomOut());
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    );
                                }

                              },
                            ),
                          );
                        });
//                        showModalBottomSheet(
//                            context: context,
//                            builder: (context) {
//                              return Container(
//                                constraints: BoxConstraints(
//                                    minHeight:
//                                    MediaQuery.of(context).size.height),
//                                height: MediaQuery.of(context).size.height,
//                                child: StreamBuilder<List<DocumentSnapshot>>(
////                                  stream: geo.collection(collectionRef: collectionReference)
////                                      .within(center: center, radius: radius, field: field),
//                                ),
//                              );
//                            });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.clear),
                      heroTag: 'clearRoute',
                      backgroundColor: Colors.white,
                      onPressed: () {
                        appState.clearRoute();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.navigation),
                      heroTag: 'buttonNavigation',
                      backgroundColor: Colors.white,
                      onPressed: () {
                        if (liveButton) {
                          streamSubscription = geolocator
                              .getPositionStream(locationOptions)
                              .listen((Position position) {
                            print(position == null
                                ? 'Unknown'
                                : position.latitude.toString() +
                                    ', ' +
                                    position.longitude.toString());
                            appState.mapController.animateCamera(
                                CameraUpdate.newLatLngZoom(
                                    LatLng(
                                        position.latitude, position.longitude),
                                    18));
                          });
                          liveButton = false;
                        } else {
                          streamSubscription.cancel();
                          liveButton = true;
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.find_in_page),
                      heroTag: 'buttonFind',
                      backgroundColor: Colors.white,
                      splashColor: Colors.blue,
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                constraints: BoxConstraints(
                                    minHeight:
                                        MediaQuery.of(context).size.height),
                                height: MediaQuery.of(context).size.height,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection('passengerPickUpData')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return Text('Loading...');
                                      default:
                                        return ListView(
                                          children: snapshot.data.documents
                                              .where((test) {
                                            if (test.data['rideStatus'] ==
                                                    'pending' &&
                                                test.data['username'] !=
                                                    userdata.firebaseuser.email)
                                              return true;
                                            else if (test.data['driverID'] ==
                                                    userdata
                                                        .firebaseuser.email &&
                                                test.data['rideStatus'] ==
                                                    'accept')
                                              return true;
                                            else
                                              return false;
                                          }).map((DocumentSnapshot document) {
                                            return Card(
                                              child: ExpansionTile(
                                                title: Text(
                                                  "${document['username']} (${document['rideStatus']})",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                trailing: Icon(
                                                  Icons.more_vert,
                                                  color: Colors.black,
                                                ),
                                                children: <Widget>[
                                                  FlatButton(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Column(
                                                          children: <Widget>[
                                                            Text(
                                                                'Address: ${document['address']}'),
                                                            Text(
                                                                'Date: ${document['date']}'),
                                                            Text(
                                                                'Time: ${document['time']}'),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child:
                                                                  RaisedButton(
                                                                child: Text(
                                                                    "See On Map"),
                                                                onPressed: () {
//
                                                                  GeoPoint
                                                                      passengerLatLng =
                                                                      document[
                                                                              'position']
                                                                          [
                                                                          'geopoint'];
                                                                  print(
                                                                      '${passengerLatLng.latitude}  : ${passengerLatLng.longitude}');
                                                                  appState.addMarker(
                                                                      LatLng(
                                                                          passengerLatLng
                                                                              .latitude,
                                                                          passengerLatLng
                                                                              .longitude),
                                                                      document[
                                                                          'address']);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  RaisedButton(
                                                                child: Text(
                                                                    "Accept"),
                                                                onPressed: () {
                                                                  String
                                                                      _documentID =
                                                                      document
                                                                          .documentID;
                                                                  TextEditingController
                                                                      _textFieldController =
                                                                      TextEditingController();
                                                                  Firestore
                                                                      .instance
                                                                      .collection(
                                                                          'users')
                                                                      .document(
                                                                          '${document['username']}')
                                                                      .get()
                                                                      .then(
                                                                          (onValue) {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          if (document['rideStatus'] ==
                                                                              'accept') {
                                                                            return AlertDialog(
                                                                              title: Text("You already accepted the request!"),
                                                                              content: Text("Passenger Info: \n"
                                                                                  "Name: ${onValue.data['name']}\n"
                                                                                  "Email: ${onValue.data['email']}\n"
                                                                                  "Phone: ${onValue.data['phone']}"),
                                                                              actions: <Widget>[
                                                                                FlatButton(
                                                                                  child: Text("Close"),
                                                                                  onPressed: () => Navigator.pop(context),
                                                                                )
                                                                              ],
                                                                            );
                                                                          } else {
                                                                            return AlertDialog(
                                                                              title: Text('Note to passenger:'),
                                                                              content: TextField(
                                                                                controller: _textFieldController,
                                                                                decoration: InputDecoration(hintText: "Optional"),
                                                                              ),
                                                                              actions: <Widget>[
                                                                                new FlatButton(
                                                                                  child: new Text('Confirm'),
                                                                                  onPressed: () {
                                                                                    Firestore.instance.collection('passengerPickUpData').document(_documentID).updateData({
                                                                                      'driverID': '${userdata.firebaseuser.email}',
                                                                                      'rideStatus': 'accept',
                                                                                      'driverNote': _textFieldController.value.text,
                                                                                    });
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                )
                                                                              ],
                                                                            );
                                                                          }
                                                                        });
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  RaisedButton(
                                                                child: Text(
                                                                    'Get Direction'),
                                                                onPressed: () {
                                                                  appState.pickUpDestinationTextController
                                                                          .text =
                                                                      document[
                                                                          'address'];
                                                                  Navigator.pop(
                                                                      context);
                                                                  appState.sendRequest(
                                                                      '${document['address']}');
                                                                  appState.finalDestinationTextController
                                                                          .text =
                                                                      "Cal Poly Pomona";
                                                                  appState.sendRequestFromPickUpLocationToFinalDestination(
                                                                      document[
                                                                          'address'],
                                                                      appState
                                                                          .finalDestinationTextController
                                                                          .text);
//                                                              appState.mapController.moveCamera(CameraUpdate.zoomOut());
                                                                },
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        );
                                    }
                                  },
                                ),
                              );
                            });
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
