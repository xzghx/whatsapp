import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.12, 80.12),
    zoom: 15,
  );
  GoogleMapController _mapController;

  void _googleMapController(GoogleMapController controller) {
    //this callback function gives us a  GoogleMapController which
    //then we can use to control map from other parts of code
    _mapController = controller;
    //it's not needed to pass setState() because onMapCreated is someHowe a setState
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("map"),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: _googleMapController,
            ),
            RaisedButton(
              onPressed: () {
                _mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: LatLng(36.314, 52.093))));
              },
              child: Text("♥Go To Iran♥"),
            )
          ],
        ));
  }
}
