import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Driver extends StatefulWidget {
  @override
  _DriverState createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  @override
  Widget build(BuildContext context) {
//    Firestore firestore = Firestore.instance;

    return Material(
      child: StreamBuilder<QuerySnapshot>(
        stream:
            Firestore.instance.collection('passengerPickUpData').snapshots(),

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              return ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return Card(
                    child: ExpansionTile(
                      title: Text(document['username']),
                      trailing: Icon(Icons.more_vert),
//                      onLongPress: () => print(" long press"),
//                      onTap: () => print("tap"),
                      children: <Widget>[
                        FlatButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(document.documentID.substring(10)),
                              FloatingActionButton(
                                child: Text("Accept"),
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
  }
}
