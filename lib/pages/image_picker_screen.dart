import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ImagePickerScreen extends StatefulWidget {
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  Future<File> _imageFile;
  bool _isVideo = false;

  VideoPlayerController _videoPlayerController;

  VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _listener = () {
      setState(() {});
    };
  }

  @override
  void dispose() {
    if (_videoPlayerController != null) _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('انتخاب تصویر'),
        ),
        body: Center(
          child: _isVideo ? _previewVideo() : _previewImage(),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(Icons.image),
              onPressed: () {
                _isVideo = false;
                _onImageButtonPressed(ImageSource.gallery);
              },
            ),
            FloatingActionButton(
              child: Icon(Icons.camera_alt),
              onPressed: () {
                _isVideo = false;
                _onImageButtonPressed(ImageSource.camera);
              },
            ),
            FloatingActionButton(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.video_library),
              onPressed: () {
                _isVideo = true;
                _onImageButtonPressed(ImageSource.gallery);
              },
            ),
            FloatingActionButton(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.video_call),
              onPressed: () {
                _isVideo = true;
                _onImageButtonPressed(ImageSource.camera);
              },
            ),
          ],
        ));
  }

  void _onImageButtonPressed(ImageSource imageSource) {
    //remove listener of previous video controller
    if (_videoPlayerController != null) {
      _videoPlayerController.setVolume(0);
      _videoPlayerController.removeListener(_listener);
    }

    if (_isVideo) {
      ImagePicker.pickVideo(source: imageSource).then((File videoFile) {
        if (videoFile != null) {
          _videoPlayerController = new VideoPlayerController.file(videoFile)
            ..initialize()
            ..addListener(_listener)
            ..setLooping(true)
            ..setVolume(2)
            ..play();
        }
      });
    } else
      _imageFile = ImagePicker.pickImage(source: imageSource);

    //there a re some changes inside controllers
    //so it is reflected in mounted and we can call setState() based on mounted
    if (mounted) setState(() {});
  }

  Widget _previewImage() {
    return FutureBuilder<File>(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
            return new Image.file(snapshot.data);
          } else if (snapshot.error != null) {
            return Text(
              'لود تصویر با خطا مواجه شد.',
              textAlign: TextAlign.center,
            );
          } else {
            return Text(
              'هنوز تصویری انتخاب نشده.',
              textAlign: TextAlign.center,
            );
          }
        });
  }

  Widget _previewVideo() {
    if (_videoPlayerController == null)
      return Text('هنوز ویدیویی انتخاب نشده.');
    else if (_videoPlayerController.value.initialized)
      return AspectRatio(
        aspectRatio: 1,
        child: VideoPlayer(_videoPlayerController),
      );
    else
      return Text('لود ویدیو بت خطا مواجه شد.');
  }
}
