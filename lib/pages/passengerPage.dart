import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:broncorideshare/utils/appState.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:broncorideshare/users/UserData.dart';
import 'package:broncorideshare/pages/driverPage.dart';
class Passenger extends StatefulWidget {
  @override
  _PassengerState createState() => _PassengerState();
}

class _PassengerState extends State<Passenger> {
  final passengerKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    Firestore firestore = Firestore.instance;
    final userdata = Provider.of<UserData>(context);

    //SEND A REQUEST TO A DRIVER
    void sendRequestToDriver() {
      print('${userdata.firebaseuser.toString()}');
    }

    //---------------------------------------------
    

    //------------SEARCH FOR A DRIVER STATUS IN DATABASE------
    void searchForDriverInDatabase() async {
      Future<QuerySnapshot> snapshot =
          firestore.collection('users').getDocuments();
      snapshot.then((onValue) {
        List<DocumentSnapshot> documentdata = onValue.documents;
        for (int i = 0; i < documentdata.length; i++) {
          print('documentiD : ${documentdata[i].data['driver']}');
          if (documentdata[i].data['driver'] == true) sendRequestToDriver();
        }
      });
    }

    
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
//                onSubmitted: (value){
//                   passengerValue = savePassengerAddress(value);
//                   print('passengerValue ${passengerValue}');
//
//
//                },
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
            top: 120.0,
            right: 15.0,
            left: 10.0,
            child: FloatingActionButton.extended(
              heroTag: 'button1',
              onPressed: () {
                Map<String, dynamic> pickupaddress = {'pickupAdress': passengerAddressValue};

                firestore
                    .collection('finddriver')
                    .document('passenger:${userdata.firebaseuser.email}')
                    .setData(pickupaddress);
                  passengerKey.currentState.showSnackBar(SnackBar(content: Text("Your request has been sent!"), behavior: SnackBarBehavior.floating,));
              },
              label: Text('Find Driver'),
              icon: Icon(
                  FontAwesome5.getIconData("taxi", weight: IconWeight.Solid)),
            ),
          ),
          Positioned(
            top: 200,
            right: 15,
            left: 10,
            child: FloatingActionButton.extended(
              heroTag: 'button2',
              label: Text('Go to Main page'),
              onPressed: () {
//                Navigator.push(context, MaterialPageRoute(builder: (context)=> mainPage()))
              print('here');
              Navigator.push(context, MaterialPageRoute(builder: (context) => mainPage()));
              },
            ),
          )
        ],
      ),
    );
  }
}

//    This is left for future implementation
//    void seethedocumentdata(){
//      Future<QuerySnapshot> data  = firestore.collection('finddriver').getDocuments();
//      List<DocumentSnapshot> temp;
//      data.then((onValue){
//        temp = onValue.documents;
//      });
//      for(int i =0; i < temp.length;i++)
//        {
//          print('Document ID : ${temp[i].data['address']}');
//        }
//    }