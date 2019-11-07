import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:broncorideshare/utils/appState.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
//          onCameraMoveStarted: () {
//            appState.mapController.moveCamera(CameraUpdate.newLatLngZoom(appState.lastPosition, 10.0));
//          },
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
                top:725,
                left:345,
                child: FloatingActionButton(
                  child: Icon(Icons.find_in_page),
                  backgroundColor: Colors.white,
                  splashColor: Colors.blue,
                  onPressed: (){
                    showModalBottomSheet(
                        context: context,
                      builder: (context){
                          return Container(
                            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(150.0, 20.0, 150.0, 20.0),
                                  child: Container(
                                    height: 8.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.all(const Radius.circular(8.0)),
                                    ),
                                  ),
                                  
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Image.network('https://fsmedia.imgix.net/07/05/10/11/b2e4/4575/937c/7b9a134d6ae4/5pikachu-1gif.gif?rect=0%2C0%2C1000%2C500&auto=compress&dpr=2&w=650&fm=jpg'),
                                ),
                                Text("Pikachu"),
                                Divider(),
                                Text("Demo sheet")
                              ],
                              
                            ),
                            
                          );
                      }
                    );

                  },
                ),
              )
//              Positioned(
//                top: 120,
//                right: 15.0,
//                left: 15.0,
//                child: StreamBuilder<QuerySnapshot>(
//                  stream:
//                      Firestore.instance.collection('finddriver').snapshots(),
//                  builder: (BuildContext context,
//                      AsyncSnapshot<QuerySnapshot> snapshot) {
//                    if (snapshot.hasError)
//                      return Text('Error: ${snapshot.error}');
//                    switch (snapshot.connectionState) {
//                      case ConnectionState.waiting:
//                        return Text('Loading...');
//                      default:
//                        return ListView(
//                          children: snapshot.data.documents
//                              .map((DocumentSnapshot document) {
//                            return Card(
//                              child: ExpansionTile(
//                                title: Text('${document['pickupAddress']}'),
//                                trailing: Icon(Icons.more_vert),
////                      onLongPress: () => print(" long press"),
////                      onTap: () => print("tap"),
//                                children: <Widget>[
//                                  FlatButton(
//                                    child: Row(
//                                      mainAxisAlignment:
//                                          MainAxisAlignment.spaceBetween,
//                                      children: <Widget>[
//                                        Text(document.documentID.substring(10)),
//                                        FloatingActionButton(
//                                          heroTag: "button1",
//                                          child: Text("Accept"),
//                                          onPressed: () {
////                                   Map<String,dynamic> passengerData;
////                                   Map<String,dynamic> temp;
////
////
////                                    Future<DocumentSnapshot> data = Firestore
////                                        .instance.collection('users')
////                                        .document(
////                                        '${document.documentID.substring(10)}').get();
////                                    data.then((onValue) {
////                                      onValue.data.forEach((k,v){
////                                        if( k == 'address' || k == 'phone')
////                                          temp = { '$k' : v};
////                                          passengerData.addAll(temp);
//////                                      print('$k -> $v');
////                                      });
////                                    });
//////                                    passengerData.forEach((k,v){
//////                                      print('$k -> $v');
//////                                    });
////                                print('length: ${passengerData.length}');
//                                          },
//                                        )
//                                      ],
//                                    ), onPressed: () {},
//                                  ),
//                                ],
//
//                                //subtitle: new Text(document['author']),
//                              ),
//                            );
//                          }).toList(),
//                        );
//                    }
//                  },
//                ),
//              )
            ],
          );
  }
}
