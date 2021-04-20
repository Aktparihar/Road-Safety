import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  Location _location;
  Location get location => _location;
  LatLng _locationPosition;
  LatLng get locationPosition => _locationPosition;
  bool locationServiceActive = true;

  var geolocator = Geolocator();
  static var speed = 44440.444440;
  static double distanceInMeter = 0.0;
  double caldist;
  List<double> dtLst = [];
  static LatLng loc;
  LocationProvider() {
    _location = new Location();
  }

  //Initialization Method
  initialization() async {
    await getUserLocation();
  }

  getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();

      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    location.onLocationChanged.listen((LocationData currentLocation) {
      _locationPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      //print(_locationPosition);
      loc = LatLng(currentLocation.latitude, currentLocation.longitude);
      notifyListeners();

      //var options = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

      StreamSubscription<Position> homeTabPostionStream;

      homeTabPostionStream = Geolocator.getPositionStream(distanceFilter: 4)
          .listen((Position event) {
        speed = event.speed;

        FirebaseFirestore.instance
            .collection("locations")
            .get()
            .then((QuerySnapshot snapshot) {
          for (int i = 0; i < snapshot.docs.length; i++) {
            caldist = Geolocator.distanceBetween(
              double.parse((loc.latitude).toStringAsFixed(7)),
              double.parse((loc.longitude).toStringAsFixed(7)),
              double.parse((snapshot.docs[i].data()['position'].latitude)
                  .toStringAsFixed(7)),
              double.parse((snapshot.docs[i].data()['position'].longitude)
                  .toStringAsFixed(7)),
            );
            if (caldist < 20) {
              dtLst.add(caldist);
            }
          }
        });
        // dtLst.sort();
        // if (dtLst.first < 5) {
        //   distanceInMeter = caldist;
        // }
      });
      print(dtLst);
      // print("hollo speed is ");
      double.parse((speed).toStringAsFixed(2));
      //print(speed);
      dtLst.sort();
      distanceInMeter = dtLst.first;
      //dtLst = [];
      print(loc.latitude);
      print(distanceInMeter);
      print(loc.longitude);
    });
  }
}
