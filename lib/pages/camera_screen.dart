import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  List<Map> files = [];
  CameraController _cameraController;

  //list of device's cameras ( Front camera & Rear camera)
  List<CameraDescription> _cameras = new List<CameraDescription>();
  CameraDescription _cameraDescription; //Store The Selected camera.
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

      //Store The Selected camera.
      _cameraDescription = camera;
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
                      focusColor: Colors.greenAccent,
                      hoverColor: Colors.red,
                      onPressed: _cameraSwitchToggle),
                  new GestureDetector(
                    onTap: _onTakePictureButtonPressed,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: _cameraController != null &&
                                      _cameraController.value.isRecordingVideo
                                  ? Colors.redAccent
                                  : Colors.white,
                              width: 4),
                          shape: BoxShape.circle),
                    ),
                  ),
                  new IconButton(
                      icon: new Icon(Icons.flash_off),
                      iconSize: 36,
                      color: Colors.white,
                      onPressed: () {}),
                ],
              ),
              new Padding(
                padding: EdgeInsets.only(bottom: 16, top: 8),
                child: Text(
                  "برای عکس ضربه بزنید،برای فیلم نگه دارید.",
                  style: TextStyle(color: Colors.greenAccent),
                ),
              )
            ],
          ),
        ));
  }

  /// toggle camera to front or rear
  /// only if device has more than one camera
  void _cameraSwitchToggle() {
    if (_cameras.length >= 2) {
      initCameraController(
          camera:
              _cameraDescription == _cameras[0] ? _cameras[1] : _cameras[0]);
      //Note:
      //_cameraDescription is The Selected Camera
      //_cameras is list of available cameras in device
    } else {
      showSnackBar("شما قادر به تغییر دوربین نیستید.");
    }
  }

  void _onTakePictureButtonPressed() async {
    if (await Permission.storage.request().isGranted) {
      String filePath = await takePicture();
//      if (filePath != null) {
      setState(() {
        files.add({'type': 'image', 'path': filePath});
      });
      showSnackBar("تصویر در ادرس زیر ذخیره شد:/n $filePath");
//      }
    }
   else if (await Permission.storage.isPermanentlyDenied) {
//      showSnackBar("اجازه ی دسترسی به حافظه برای ذخیره ی تصویر لازم است");
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Row(
        children: <Widget>[
          new Text(
            "دسترسی به حافظه برای ذخیره ی تصاویر نیاز است.",
            style: TextStyle(fontFamily: "Vazir"),
          ),
          new FlatButton(
              onPressed: () async {
                if (await Permission.storage.isPermanentlyDenied) {
                  // The user opted to never again see the permission request dialog for this
                  // app. The only way to change the permission's status now is to let the
                  // user manually enable it in the system settings.
                  openAppSettings();
                }
              },
              child: Text("تنظیمات"))
        ],
      )));
      return;
    }
  }

  Future<String> takePicture() async {
    //get app's directory
    Directory extDir = await getExternalStorageDirectory();
//    //define dir
    String dirPath = '${extDir.path}/pictures';
//    create dir
    await new Directory(dirPath).create(recursive: true);
//    create path
    String filePath = '$dirPath/${timeStamp()}.jpg';

    try {
      await _cameraController.takePicture(filePath);
    } on CameraException catch (e) {
      showCameraException(e);
      return null;
    }
    return filePath;
  }

  String timeStamp() => new DateTime.now().millisecondsSinceEpoch.toString();
}
