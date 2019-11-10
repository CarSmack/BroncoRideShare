import 'package:broncorideshare/utils/geoFireFlutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:broncorideshare/utils/appState.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:broncorideshare/users/UserData.dart';
import 'package:broncorideshare/pages/driverPage.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
class Passenger extends StatefulWidget {
  @override
  _PassengerState createState() => _PassengerState();
}

class _PassengerState extends State<Passenger> {
  final passengerKey = GlobalKey<ScaffoldState>();
  geoFlutterFire geoFlutterfire = geoFlutterFire();
  String _date = "Not set";
  String _time = "Not set";



  
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    Firestore firestore = Firestore.instance;
    final userdata = Provider.of<UserData>(context);
    
    //----------------SAVE PASSENGER ADDRESS-----------------------------------------
    dynamic passengerAddressValue;


    //build start
    return appState.initialPosition == null
        ? Container(
      alignment: Alignment.center,
      child: Center(
        child: CircularProgressIndicator(backgroundColor: Colors.blueGrey,),
      ),
    )
     : Scaffold(
      key: passengerKey,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(
                target:
                    appState.initialPosition /*LatLng(34.063297, -117.818771)*/,
                zoom: 10.0),
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
//                controller: appState.locationController,
//                textInputAction: TextInputAction.go,
                onChanged: (String value) {
                  passengerAddressValue = value;
                },
//                onSubmitted: (value){
//
//                  saveDataToFirebase.addGeoPointToFirebase(value);
//                },
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
                  hintText: "Pick Up Address",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                ),
              ),
            ),
          ),
          Positioned(
            top: 250.0,
            right: 15.0,
            left: 10.0,
            child: FloatingActionButton.extended(
              heroTag: 'button1',
              onPressed: (){

                try {

                  geoFlutterfire.addPickUpRequestToFirebase(
                      passengerAddressValue,userdata,_date,_time);

                }
                catch(e)
                {
                  print('Error from geoflutterfire${e.toString()}');
                }
                  passengerKey.currentState.showSnackBar(SnackBar(content: Text("Your request has been sent!"), behavior: SnackBarBehavior.floating,));
              },
              label: Text('Find Driver'),
              icon: Icon(
                  FontAwesome5.getIconData("taxi", weight: IconWeight.Solid)),
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
                                                        ' ${document['date']}'),
                                                    Text(
                                                        ' ${document['time']}'),

                                                  ],
                                                ),

                                                FlatButton(
                                                  child: Text("Cancel"),
                                                  onPressed: () {},
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
          ),
          Positioned(
            top: 120.0,
            right: 15.0,
            left: 10.0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  elevation: 4.0,
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        theme: DatePickerTheme(
                          containerHeight: 210.0,
                        ),
                        showTitleActions: true,
                        minTime: DateTime(2000, 1, 1),
                        maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                          print('confirm $date');
                          _date = '${date.year} - ${date.month} - ${date.day}';
//                          setState(() {});
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    size: 18.0,
                                    color: Colors.teal,
                                  ),
                                  Text(
                                    "Please Choose Your Date",
                                    style: TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Text(
                          "  Change",
                          style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  elevation: 4.0,
                  onPressed: () {
                    DatePicker.showTimePicker(context,
                        theme: DatePickerTheme(
                          containerHeight: 210.0,
                        ),
                        showTitleActions: true, onConfirm: (time) {
                          print('confirm $time');
                          _time = '${time.hour} : ${time.minute} : ${time.second}';
//                          setState(() {});
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
//                    setState(() {});
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.access_time,
                                    size: 18.0,
                                    color: Colors.teal,
                                  ),
                                  Text(
                                    " Please Choose your Time",
                                    style: TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Text(
                          "  Change",
                          style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}
