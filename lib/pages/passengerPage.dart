import 'package:broncorideshare/utils/geoFireFlutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:broncorideshare/utils/appState.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:broncorideshare/users/UserData.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

class Passenger extends StatefulWidget {
  @override
  _PassengerState createState() => _PassengerState();
}

class _PassengerState extends State<Passenger> {
  final passengerKey = GlobalKey<ScaffoldState>();
  geoFlutterFire geoFlutterfire = geoFlutterFire();
  String _date = "Please Choose Your Date";
  String _time = "Please Choose Your Time";
  String driverNameForEachButton;
  String apiKey;

  //Store passenger pick up address
  dynamic passengerAddressValue;
  final pickUpTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //State Management for Map and User
    final appState = Provider.of<AppState>(context);
    final userdata = Provider.of<UserData>(context);

    //build start
    return appState.initialPosition == null
        ? Container(
            color: Colors.black,
            alignment: Alignment.center,

            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Please Make Sure You Enable Your Location for Google Map Services:\n"
                        "For iOS : \nGo to Setting -> Privacy -> Location Services -> broncorideshare -> Enable \"While Using the App\" or \"Always\"\n"
                        "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal,

                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            key: passengerKey,
            body: Stack(
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: appState
                          .initialPosition /*LatLng(34.063297, -117.818771)*/,
                      zoom: 10.0),
                  onMapCreated: appState.onCreated,
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  compassEnabled: true,
                  markers: appState.markers,
                  onCameraMove: appState.onCameraMove,
                  polylines: appState.polyLines,
                  myLocationButtonEnabled: true,
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
                      controller: pickUpTextController,
                      onTap: () async {
                        Firestore.instance.collection('apiKey').document('placeAPI').get().then((onValue){
                          apiKey = onValue.data['key'];
                        }).catchError((onError){
                          print('error firestore: ${onError}');
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
                            passengerAddressValue = onValue.description;

                            pickUpTextController.text = passengerAddressValue;
                          }).catchError((onError) {
                            print('Error on AutoComplete : ${onError}');
                          });
                        }
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton.extended(
                      heroTag: 'button1',
                      onPressed: () {
                        if (_date == null ||
                            _time == null ||
                            passengerAddressValue == null) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text("Invalid Input!"),
                                  content: Text(
                                      "Please make sure to input Pick up Address, Date ,and Time correctly."),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Close')),
                                  ],
                                );
                              });
                        } else {
                          try {
                            geoFlutterfire.addPickUpRequestToFirebase(
                                passengerAddressValue, userdata, _date, _time);
                          } catch (e) {
                            print('Error from geoflutterfire${e.toString()}');
                          }
                          passengerKey.currentState.showSnackBar(SnackBar(
                            content: Text("Your request has been sent!"),
                            behavior: SnackBarBehavior.floating,
                          ));
                        }
                      },
                      label: Text('Find Driver'),
                      icon: Icon(FontAwesome5.getIconData("taxi",
                          weight: IconWeight.Solid)),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height - 175,
                  left: MediaQuery.of(context).size.width - 66,
                  child: FloatingActionButton(
                    heroTag: 'button2',
                    child: Icon(Icons.find_in_page),
                    backgroundColor: Colors.white,
                    onPressed: () {
                      int numOfRequest = 1;
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
                                          if (test.data['username'] ==
                                              userdata.firebaseuser.email)
                                            return true;
                                          else
                                            return false;
                                        }).map((DocumentSnapshot document) {
                                          return Card(
                                            child: ExpansionTile(
                                              title: Text(
                                                'Request #${numOfRequest++}  (${document['rideStatus']})',
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
                                                              ' ${document['address']}'),
                                                          Text(
                                                              ' ${document['date']}'),
                                                          Text(
                                                              ' ${document['time']}'),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: RaisedButton(
                                                              child: Text(
                                                                  "Cancel"),
                                                              onPressed: () {
                                                                try {
                                                                  Firestore
                                                                      .instance
                                                                      .collection(
                                                                          'passengerPickUpData')
                                                                      .document(
                                                                          '${document.documentID}')
                                                                      .delete();
                                                                  numOfRequest =
                                                                      1;
                                                                } catch (e) {
                                                                  print(
                                                                      "error: $e");
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: RaisedButton(
                                                              child: Text(
                                                                  "Driver Info"),
                                                              onPressed: () {
                                                                if (document[
                                                                        'rideStatus'] ==
                                                                    'pending') {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('Your request is still pending ....'),
                                                                          actions: <
                                                                              Widget>[
                                                                            new FlatButton(
                                                                              child: new Text('Close'),
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                            )
                                                                          ],
                                                                        );
                                                                      });
                                                                } else {
                                                                  Firestore
                                                                      .instance
                                                                      .collection(
                                                                          'users')
                                                                      .document(
                                                                          '${document['driverID']}')
                                                                      .get()
                                                                      .then(
                                                                          (onValue) {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text('Driver Information'),
                                                                            content: Text("Driver Name: ${onValue.data['name']} \n\n"
                                                                                "Phone Number: ${onValue.data['phone']} \n\n"
                                                                                "Email: ${onValue.data['email']}\n\n"),
                                                                            actions: <Widget>[
                                                                              new FlatButton(
                                                                                child: new Text('Close'),
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                              )
                                                                            ],
                                                                          );
                                                                        });
                                                                  }).catchError(
                                                                          (onError) {
                                                                    print(
                                                                        "it is an error $onError");
                                                                  });
                                                                }
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
                              maxTime: DateTime(2022, 12, 31),
                              onConfirm: (date) {
                            print('confirm $date');
                            _date =
                                '${date.month} - ${date.day} - ${date.year}';
                            setState(() {});
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
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
                                          "$_date",
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
                            _time = '${time.hour} : ${time.minute}';
                            setState(() {});
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                          setState(() {});
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
                                          "$_time",
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
