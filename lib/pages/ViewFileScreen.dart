import 'dart:io';

import 'package:flutter/material.dart';

class ViewFileScreen extends StatefulWidget {
  final Map file;

  ViewFileScreen(this.file);

  @override
  _ViewFileScreenState createState() => _ViewFileScreenState();
}

class _ViewFileScreenState extends State<ViewFileScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
          child: widget.file['type'] == 'image' ? _showImage() : _showVideo(),
        ),
      ),
    );
  }

  _showImage() {
    return Image.file(
      File(widget.file['path']),
      fit: BoxFit.cover,
    );
  }

  _showVideo() {}
}
