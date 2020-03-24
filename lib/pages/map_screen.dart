import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(36.314,52.093),
    zoom:5,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title:Text("map") ,),
        body: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
//        _controller.complete(controller);
          },
        ),

    );
  }
}
