import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState(url);

  VideoApp(this.url);

  String url;


}

class _VideoAppState extends State<VideoApp> {

  _VideoAppState(this.urlVideo);

  String urlVideo;

  late VideoPlayerController _controller;



  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        urlVideo)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
    Center(
    child: _controller.value.isInitialized
      ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : Container(),
    ),
        _controller.value.isInitialized ? ElevatedButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          }, child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
          
        ): Container()
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}