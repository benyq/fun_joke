import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class JokeVideoPlayer extends StatelessWidget {
  final String? videoUrl;
  final File? videoFile;

  const JokeVideoPlayer({super.key, this.videoUrl, this.videoFile}):
        assert(videoUrl == null || videoFile == null, 'videoUrl and videoFile cannot be set at the same time.');

  @override
  Widget build(BuildContext context) {
    return RealVideoPlayer(
      videoUrl: videoUrl,
      videoFile: videoFile,
    );
  }
}

class RealVideoPlayer extends StatefulWidget {
  final String? videoUrl;
  final File? videoFile;

  const RealVideoPlayer({super.key, this.videoUrl, this.videoFile}):
        assert(videoUrl == null || videoFile == null, 'videoUrl and videoFile cannot be set at the same time.');

  @override
  State<RealVideoPlayer> createState() => _RealVideoPlayerState();
}

class _RealVideoPlayerState extends State<RealVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.videoFile != null) {
      _controller = VideoPlayerController.file(widget.videoFile!);
    }else if (widget.videoUrl != null) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? GestureDetector(
              onTap: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
          : GestureDetector(
              onTap: () {
                _controller.initialize().then((_) {
                  // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                  setState(() {
                    _controller.play();
                  });
                });
              },
              child: Container(
                width: 100.w,
                height: 50.h,
                color: Colors.blue,
              )),
    );
  }
}
