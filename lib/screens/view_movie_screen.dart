import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/duration_formatter.dart';
import 'package:streamit_flutter/utils/resources/colors.dart';
import 'package:streamit_flutter/utils/resources/size.dart';
import 'package:video_player/video_player.dart';

class MovieScreen extends StatefulWidget {
  static String tag = '/MovieScreen';

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends State<MovieScreen> with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  bool isLoaded = false;
  bool showOverLay = false;
  bool isFullScreen = false;
  int _currentPosition = 0;
  int _duration = 0;
  bool isBuffering = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // These are the callbacks
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      setState(() {
        _controller.pause();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller = VideoPlayerController.network('https://iqonic.design/wp-themes/proshop-book/wp-content/uploads/2020/08/sample-mp4-file.mp4');
    _attachListenerToController();
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {
          isLoaded = true;
        }));
    _controller.play();
  }

  _attachListenerToController() {
    _controller.addListener(
      () {
        isBuffering = _controller.value.isBuffering;
        if (_controller.value.duration == Duration(seconds: 0) || _controller.value.position == Duration(seconds: 0)) {
          return;
        }
        if (mounted) {
          setState(() {
            _currentPosition = _controller.value.duration.inMilliseconds == 0 ? 0 : _controller.value.position.inMilliseconds;
            _duration = _controller.value.duration.inMilliseconds;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    WidgetsBinding.instance!.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var moviePoster = AspectRatio(
      aspectRatio: isLoaded ? _controller.value.aspectRatio : 16 / 9,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          VideoPlayer(_controller),
          Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    showOverLay = !showOverLay;
                    print("showoverlay:" + showOverLay.toString());
                  });
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
                                    text(context, durationFormatter(_currentPosition) + " / " + durationFormatter(_duration), textColor: Theme.of(context).textTheme.headline6!.color).paddingLeft(spacing_standard),
                                    IconButton(
                                      icon: Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                                      onPressed: () {
                                        setState(() {
                                          !isFullScreen
                                              ? SystemChrome.setPreferredOrientations([
                                                  DeviceOrientation.landscapeRight,
                                                  DeviceOrientation.landscapeLeft,
                                                ])
                                              : SystemChrome.setPreferredOrientations([
                                                  DeviceOrientation.portraitUp,
                                                  DeviceOrientation.portraitDown,
                                                ]);
                                          isFullScreen = !isFullScreen;
                                        });
                                      },
                                    ).visible(!isBuffering)
                                  ],
                                ),
                                VideoProgressIndicator(_controller, allowScrubbing: true),
                              ],
                            ),
                            Center(
                              child: IconButton(
                                icon: Icon(
                                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 56.0,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _controller.value.isPlaying ? _controller.pause() : _controller.play();
                                    showOverLay = _controller.value.isPlaying ? false : true;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ).onTap(() {
                        setState(() {
                          showOverLay = !showOverLay;
                          print("showoverlay:" + showOverLay.toString());
                        });
                      })
                    : SizedBox.shrink(),
              ),
            ],
          ),
          Center(
            child: loadingWidgetMaker(),
          ).visible(isBuffering)
        ],
      ),
    );
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(child: moviePoster),
          SafeArea(
            child: Container(
              height: 50,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: colorPrimary,
                    ),
                    onPressed: () {
                      if (isFullScreen) {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown,
                        ]);
                        isFullScreen = !isFullScreen;
                      } else {
                        finish(context);
                      }
                    },
                  ),
                  toolBarTitle(context, "Jumanji: The Next Level")
                ],
              ),
            ),
          ).visible(showOverLay),
        ],
      ),
    );
  }
}
