import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:road_safety/provider/location_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_geofence/geofence.dart';
import 'dart:async';

class GoogleMapsPageViewOnly extends StatefulWidget {
  @override
  _GoogleMapsPageViewOnlyState createState() => _GoogleMapsPageViewOnlyState();
}

class _GoogleMapsPageViewOnlyState extends State<GoogleMapsPageViewOnly> {
  List<Marker> allMarker = [];
  List<LatLng> addd = [LatLng(24.5433433, 74.13243534)];

  var distanceInMeters = 0.0;
  var speed = 10.34;
  var loc;
  GoogleMapController mapController;
  var clients = [];

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    final databaseReference = FirebaseFirestore.instance;
    Provider.of<LocationProvider>(context, listen: false).initialization();

    //initPlatformState();
    if (!mounted)
      return;
    else {
      new Timer.periodic(
          Duration(seconds: 1),
          (Timer t) => {
                setState(() {
                  speed = LocationProvider.speed;
                  distanceInMeters = LocationProvider.distanceInMeter;
                })
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Road Safety"),
          backgroundColor: Colors.blue,
        ),
        body: googleMapUI());
  }

  Widget googleMapUI() {
    return Consumer<LocationProvider>(builder: (consumerContext, model, child) {
      _handleTap(LatLng tappedPoint) {
        setState(() {
          // myMarker = [];
          FirebaseFirestore.instance.collection('locations').add({
            'position':
                new GeoPoint(tappedPoint.latitude, tappedPoint.longitude)
          });

          addd.add(tappedPoint);
          allMarker.add(Marker(
            markerId: MarkerId(tappedPoint.toString()),
            position: tappedPoint,
          ));

          for (int i = 0; i < addd.length; i++) {
            print("$i item is $addd[i]");
          }
        });
      }

      if (model.locationPosition != null) {
        return Column(
          children: [
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition:
                    CameraPosition(target: model.locationPosition, zoom: 18),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  setState(() {
                    mapController = controller;
                    getData();
                  });
                },
                markers: Set.from(allMarker),
              ),
            ),
            Text(
              "Info : ${double.parse((distanceInMeters).toStringAsFixed(2)) < 10 ? "Bumper Ahead" : "No bumper"}",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Speed : $speed',
              style: TextStyle(fontSize: 20),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Go Back!',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
          ],
        );
      }

      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }

  void getData() {
    FirebaseFirestore.instance
        .collection("locations")
        .get()
        .then((QuerySnapshot snapshot) {
      for (int i = 0; i < snapshot.docs.length; i++) {
        allMarker.add(Marker(
          markerId: MarkerId(snapshot.docs[i].id),
          position: LatLng(snapshot.docs[i].data()['position'].latitude,
              snapshot.docs[i].data()['position'].longitude),
        ));
      }
    });
  }
}
