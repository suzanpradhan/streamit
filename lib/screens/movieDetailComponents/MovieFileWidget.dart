import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/duration_formatter.dart';
import 'package:video_player/video_player.dart';

class MovieFileWidget extends StatefulWidget {
  static String tag = '/MovieFileWidget';
  final String url;

  MovieFileWidget(this.url);

  @override
  MovieFileWidgetState createState() => MovieFileWidgetState();
}

class MovieFileWidgetState extends State<MovieFileWidget> {
  VideoPlayerController? controller;

  bool showOverLay = false;
  bool isFullScreen = false;
  bool isBuffering = false;
  int currentPosition = 0;
  int duration = 0;
  bool isVideoCompleted = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.url);

    init();
  }

  Future<void> init() async {
    if (controller!.hasListeners) {
      controller!.removeListener(() {});
    }
    controller!.addListener(() {
      if (mounted && controller!.value.isInitialized) {
        currentPosition = controller!.value.duration.inMilliseconds == 0 ? 0 : controller!.value.position.inMilliseconds;
        duration = controller!.value.duration.inMilliseconds;
      }

      if (!controller!.value.isPlaying && !controller!.value.isBuffering) {
        isBuffering = controller!.value.isBuffering;

        if (controller!.value.duration == Duration(seconds: 0) || controller!.value.position == Duration(seconds: 0)) {
          return;
        }
      }

      if (controller!.value.isInitialized && !isVideoCompleted && controller!.value.duration.inMilliseconds == currentPosition) {
        isVideoCompleted = true;
      } else {
        isVideoCompleted = false;
      }

      this.setState(() {});
    });
    controller!.setLooping(false);

    controller!.initialize().then((_) {
      controller!.play();

      setState(() {});
    });
  }

  void handlePlayPauseVideo() {
    if (isVideoCompleted) {
      isVideoCompleted = false;

      init();
      //controller.play();
    } else {
      controller!.value.isPlaying ? controller!.pause() : controller!.play();
    }

    showOverLay = !showOverLay;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    controller?.removeListener(() {});
    controller?.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: controller!.value.isInitialized ? controller!.value.aspectRatio : 16 / 9,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          VideoPlayer(controller!),
          GestureDetector(
            onTap: () {
              showOverLay = !showOverLay;

              setState(() {});
            },
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 50),
            reverseDuration: Duration(milliseconds: 200),
            child: showOverLay
                ? Container(
                    color: Colors.black38,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                text(
                                  context,
                                  durationFormatter(currentPosition) + " / " + durationFormatter(duration),
                                  textColor: Theme.of(context).textTheme.headline6!.color,
                                ).paddingLeft(8),
                                IconButton(
                                  icon: Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                                  onPressed: () {
                                    !isFullScreen
                                        ? SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft])
                                        : SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
                                    isFullScreen = !isFullScreen;
                                    setState(() {});
                                  },
                                ).visible(!isBuffering)
                              ],
                            ),
                            VideoProgressIndicator(controller!, allowScrubbing: true),
                          ],
                        ),
                        Center(
                          child: IconButton(
                            icon: Icon(controller!.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 56.0),
                            onPressed: () {
                              handlePlayPauseVideo();
                            },
                          ),
                        ),
                      ],
                    ),
                  ).onTap(() {
                    handlePlayPauseVideo();
                  })
                : SizedBox.shrink(),
          ),
          Center(child: Loader()).visible(isBuffering)
        ],
      ),
    );
  }
}
