import 'package:flutter/material.dart';
import 'package:road_safety/googleMapsPage.dart';
import 'package:road_safety/googleMapsPageViewOnly.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          centerTitle: true,
          title: Text('Road Safety'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/img.jpg'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    child: Text(
                      'View Only',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    splashColor: Colors.grey,
                    color: Colors.grey[700],
                    textColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GoogleMapsPageViewOnly()),
                      );
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      'Mark Only',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    color: Colors.grey[700],
                    textColor: Colors.white,
                    splashColor: Colors.grey,
                    padding:
                        EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GoogleMapsPage()),
                      );
                    },
                  ),
                ],
              ),
              RaisedButton(
                child: Text(
                  'Both Feature Map',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                color: Colors.grey[700],
                textColor: Colors.white,
                splashColor: Colors.grey,
                padding:
                    EdgeInsets.symmetric(vertical: 50.0, horizontal: 100.0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GoogleMapsPage()),
                  );
                },
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ));
  }
}
