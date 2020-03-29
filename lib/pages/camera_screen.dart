import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CameraPreviewWidget(),
      ],
    );
  }
}

Widget CameraPreviewWidget() {
  return Text("zahra");
}
