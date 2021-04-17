import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:road_safety/provider/location_provider.dart';
import 'package:provider/provider.dart';

class GoogleMapsPage extends StatefulWidget {
  final String mapDescription;
  GoogleMapsPage({Key key, this.mapDescription}) : super(key: key);

  @override
  _GoogleMapsPageState createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  List<Marker> myMarker = [];
  List<LatLng> addd = [LatLng(24.5433433, 74.13243534)];

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialization();
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
          addd.add(tappedPoint);
          myMarker.add(Marker(
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
                onMapCreated: (GoogleMapController controller) {},
                markers: Set.from(myMarker),
                onTap: _handleTap,
              ),
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
}
