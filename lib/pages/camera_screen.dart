import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  CameraController _cameraController;

  //list of device's cameras ( Front camera & Rear camera)
  List<CameraDescription> _cameras = new List<CameraDescription>();

  @override
  void initState() {
    super.initState();
    //at first get available cameras
    //then init controller camera
    initCameras();
  }

  void initCameras() async {
    _cameras = await availableCameras();
    initCameraController(camera: _cameras.first);
  }

  void initCameraController({CameraDescription camera}) async {
    /*
    * init
    * setListener ( to get errors)
    * initialize
    * */

    setState(() {
      // To display the current output from the camera,
      // create a CameraController.
      _cameraController = new CameraController(
          // Get a specific camera from the list of available cameras.
          camera,
          // Define the resolution to use.
          ResolutionPreset.high);
    });

    _cameraController.addListener(() {
      //Handle Errors
      if (_cameraController.value.hasError) {
        showSnackBar(
            'Camera Controller Error :${_cameraController.value.errorDescription}');
      }
    });

    try {
      await _cameraController.initialize();
    } on CameraException catch (e) {
      showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void showCameraException(CameraException e) {
    print('Error code : ${e.code}\n Error Message : ${e.description}');
    showSnackBar('Error Message : ${e.description}');
  }

  void showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(
      message,
      style: TextStyle(
        fontFamily: 'Vazir',
        fontSize: 16,
      ),
      textDirection: TextDirection.rtl,
    )));
  }
  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          _cameraPreviewWidget(),
          _cameraBottomWidgets(),
        ],
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return new Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.tealAccent,
        ),
      );
    } else {
      return new Transform.scale(
        //to fill all screen divide to _cameraController.value.aspectRatio
        scale: 1 / _cameraController.value.aspectRatio,
        child: new Center(
          child: new AspectRatio(
            aspectRatio: _cameraController.value.aspectRatio,
            child: new CameraPreview(_cameraController),
          ),
        ),
      );
    }
  }

  Widget _cameraBottomWidgets() {
    return new Align(
        alignment: Alignment.bottomCenter,
        child: new Padding(
          padding: EdgeInsets.only(
            bottom: 20,
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new IconButton(
                      icon: new Icon(Icons.switch_camera),
                      iconSize: 36,
                      color: Colors.white,
                      onPressed: () {}),
                  new IconButton(
                      icon: new Icon(Icons.add_circle),
                      iconSize: 65,
                      color: Colors.white,
                      onPressed: () {}),
                  new IconButton(
                      icon: new Icon(Icons.flash_off),
                      iconSize: 36,
                      color: Colors.white,
                      onPressed: () {}),
                ],
              )
            ],
          ),
        ));
  }
}
