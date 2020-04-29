import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ViewFileScreen extends StatefulWidget {
  final Map file; //selected image or video to preview

  ViewFileScreen(this.file);

  @override
  _ViewFileScreenState createState() => _ViewFileScreenState();
}

class _ViewFileScreenState extends State<ViewFileScreen> {
  VideoPlayerController _videoPlayerController;
  bool _isPlaying = false; //store current status of video playing

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.file['type'] == 'video') {
      //1- get video player instance
      //2- add listener
      //3- initialize controller
      //1-
      _videoPlayerController =
          new VideoPlayerController.file(new File(widget.file['path']));
      //2-
      _videoPlayerController.addListener(() async {
        //if video reached end , video is finished so should scroll to first of video:
        if (_videoPlayerController.value.position >=
            _videoPlayerController.value.duration) {
          await _videoPlayerController.seekTo(Duration(milliseconds: 0));
          await _videoPlayerController.pause();
        }

        //store is playing video
        bool isPlaying = _videoPlayerController.value.isPlaying;
        if (_isPlaying != isPlaying)
          setState(() {
            _isPlaying = isPlaying;
          });
      });
      //3-
      //pass underLine _ to callback function of then method below.
      //because it is returning null
      try {
        _videoPlayerController.initialize().then((_) {
          setState(() {});
          //when we call setState() , view will be re render
          //so _videoPlayerController.value.initialized will be true
        });
      } catch (e, s) {
        print(s);
      }
    }
  }

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

  _showVideo() {
    return _videoPlayerController != null &&
            _videoPlayerController.value.initialized
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(
                  _videoPlayerController,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () async {
                      if (_isPlaying)
                        _videoPlayerController.pause();
                      else
                        _videoPlayerController.play();
                    },
                    icon: _isPlaying
                        ? Icon(Icons.pause, size: 36,color: Colors.green)
                        : Icon(Icons.play_arrow, size: 36,color: Colors.green),
                  ),
                  IconButton(
                      onPressed: () async {
                        await _videoPlayerController.pause();
                        await _videoPlayerController
                            .seekTo(Duration(milliseconds: 0));
                      },
                      icon: Icon(Icons.stop, size: 36,color: Colors.green)),
                ],
              ),
            ],
          )
        : CircularProgressIndicator();
  }
}
