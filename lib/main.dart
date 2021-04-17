import 'package:flutter/material.dart';
import 'package:road_safety/googleMapsPage.dart';
import 'package:provider/provider.dart';
import 'package:road_safety/provider/location_provider.dart';
import 'package:road_safety/mainPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
          child: GoogleMapsPage(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: HomePage(),
      ),
    );
  }
}
