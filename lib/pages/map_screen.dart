import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController _mapController;
  MapType _currentMapType;
  Set<Marker> _markers = <Marker>{};

  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.12, 80.12),
    zoom: 8,
  );

  void _googleMapController(GoogleMapController controller) {
    //this callback function gives us a  GoogleMapController which
    //then we can use to control map from other parts of code
    _mapController = controller;
    //it's not needed to pass setState() because onMapCreated is someHowe a setState
  }

  void _onMapTypeButtonPressed() {
    /*Way 1*/
    if (_currentMapType == MapType.normal) {
      setState(() {
        _currentMapType = MapType.satellite;
      });
    } else
      setState(() {
        _currentMapType = MapType.normal;
      });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("map"),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            GoogleMap(
              markers: _markers,
              mapType: _currentMapType,
              initialCameraPosition: _initialPosition,
              onMapCreated: _googleMapController,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onTap: _myAddMarker,
            ),
            RaisedButton(
              onPressed: () {
                _mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: LatLng(36.314, 52.093), zoom: 6)));
              },
              child: Text("♥Go To Iran♥"),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: <Widget>[
                  Text(
                    "موقعیت : ${_initialPosition.target.longitude} , ${_initialPosition.target.latitude}",
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 16, bottom: 10),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: _onMapTypeButtonPressed,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.map),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FloatingActionButton(
                        onPressed: null,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.add_location),
                      ),
                      FloatingActionButton(
                        onPressed: null,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.remove),
                      ),
                    ],
                  ),
                )),
          ],
        ));
  }

  void _myAddMarker(LatLng point) {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId("marker8"),
          infoWindow: InfoWindow(
            title: 'My position is $point',
          ),
          draggable: true,
          position: point,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow,
          )));
    });
  }
}
