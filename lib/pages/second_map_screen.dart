import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapLocationScreen extends StatefulWidget {
  @override
  _MapLocationScreenState createState() => _MapLocationScreenState();
}

class _MapLocationScreenState extends State<MapLocationScreen> {
  CameraPosition _position;
  GoogleMapController _mapController;

  LocationData _startLocation;
  LocationData _currentLocation;
  Location _location = new Location();
  PermissionStatus _permission = PermissionStatus.DENIED;
  String error;

  @override
  void initState() {
    super.initState();
    //1- find Start location
    //2- find location changes
    initPlatformState();
    _location.onLocationChanged().listen((LocationData currentLocation) {
      // Use current location
      _currentLocation = currentLocation;
      //animate camera when user moves
      if (_mapController != null) {
        _mapController.animateCamera(CameraUpdate.newCameraPosition(
            new CameraPosition(
                target: LatLng(
                    currentLocation.latitude, currentLocation.longitude))));
      }
    });
  }

  initPlatformState() async {
    LocationData location;
    try {
      _permission = await _location.hasPermission();
      location = await _location.getLocation();
      error = null;
    } //Exception will happen if permission not granted
    on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') error = "permission denied";
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK')
        error =
            "permission denied.please ask user to enable it from the app setting";

      location = null;
    }

    setState(() {
      _startLocation = location;
      _position = new CameraPosition(
          target: LatLng(location.latitude, location.longitude), zoom: 5);
    });
  }

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;

    void _onMapCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }

    void _onCameraMoved(CameraPosition position) {
      setState(() {
        _position = position;
      });
    }

    List<Widget> bodyWidgets = new List();
    bodyWidgets.add(new SizedBox(
        width: device.width,
        height: 300,
        child: _position != null
            ? new GoogleMap(
                initialCameraPosition: _position,
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                onCameraMove: _onCameraMoved,
              )
            : SizedBox()));
    bodyWidgets.add(Center(
        child: _startLocation != null
            ? Text("مکان شروع کاربر : $_startLocation \n")
            : Text("خطا : $error \n")));
    bodyWidgets.add(Center(
        child: _startLocation != null
            ? Text("مکان فعلی کاربر : $_currentLocation \n")
            : Text("خطا : $error \n")));
    bodyWidgets.add(Center(
        child: Text(_permission != PermissionStatus.DENIED
            ? "دسترسی به مکان دارد"
            : "مجوز دسترسی به مکان داده نشد.")));
    bodyWidgets.add(Center(child: Text("camera position : $_position")));
    bodyWidgets.add(RaisedButton(
      child: Text("Go Iran"),
      onPressed: () {
        setState(() {
          _mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(34.314, 52.0193), zoom: 5)));
        });
      },
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text("مکان شما"),
      ),
      body: Column(
        children: bodyWidgets,
      ),
    );
  }
}
