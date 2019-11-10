import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:broncorideshare/utils/appState.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:broncorideshare/users/UserData.dart';

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


  @override
  Widget build(BuildContext context) {
    /*appState is for DI and State Management throuhgout the app with the Class Provider*/
    final appState = Provider.of<AppState>(context);
    final userdata = Provider.of<UserData>(context);

    /*Debug purpose to check the current position of the user*/
    print("Current position ${appState.initialPosition.toString()}");

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
                    target: appState.initialPosition, zoom: 15.0),
                onMapCreated: appState.onCreated,
                myLocationEnabled: true,
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
                      hintText: "pick up",
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
                    controller: appState.destinationTextController,
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
                      hintText: "destination?",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 725,
                left: 345,
                child: FloatingActionButton(
                  child: Icon(Icons.find_in_page),
                  backgroundColor: Colors.white,
                  splashColor: Colors.blue,
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            constraints: BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height),
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
                                          .map((DocumentSnapshot document) {
                                        return Card(
                                          child: ExpansionTile(
                                            title: Text(document['username']),
                                            trailing: Icon(Icons.more_vert),
                                            children: <Widget>[
                                              FlatButton(
                                                child: Row(
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
                                                    FlatButton(
                                                      child: Text("See On Map"),
                                                      onPressed: () {
//
                                                        GeoPoint
                                                            passengerLatLng =
                                                            document['position']
                                                                ['geopoint'];
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
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text("Accept"),
                                                      onPressed: () {
////                                                        Firestore.instance.collection('passengerPickUpData')
//                                                        CollectionReference citiesRef = Firestore.instance.collection('passengerPickUpData');
//
//                                                        Query query = citiesRef.where('rideStatus',isEqualTo: 'pending');
//                                                        query.getDocuments().then((onValue){
//                                                          print('${onValue.documents[0].data['rideStatus']}');
//                                                        });
                                                        String _documentID =
                                                            document.documentID;
                                                        TextEditingController _textFieldController = TextEditingController();

                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Note to passenger:'),
                                                                content:
                                                                    TextField(
                                                                  controller:
                                                                      _textFieldController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                          hintText:
                                                                              "Optional"),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  new FlatButton(
                                                                    child: new Text(
                                                                        'Confirm'),
                                                                    onPressed:
                                                                        () {
                                                                      Firestore
                                                                          .instance
                                                                          .collection(
                                                                              'passengerPickUpData')
                                                                          .document(
                                                                              _documentID)
                                                                          .updateData({
                                                                        'driverID':
                                                                            '${userdata.firebaseuser.email}',
                                                                        'rideStatus':
                                                                            'accept',
                                                                        'driverNote': _textFieldController.value.text,
                                                                      });
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      },
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
              )
            ],
          );
  }
}
