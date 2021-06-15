import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class MovieURLWidget extends StatefulWidget {
  static String tag = '/MovieURLWidget';

  String? url;

  MovieURLWidget(this.url);

  @override
  MovieURLWidgetState createState() => MovieURLWidgetState();
}

class MovieURLWidgetState extends State<MovieURLWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (widget.url.validate().contains('youtube.com')) {
      widget.url = 'https://www.youtube.com/embed/' + widget.url.validate().splitAfter('watch?v=');
    } else if (widget.url.validate().contains('youtu.be/')) {
      widget.url = 'https://www.youtube.com/embed/' + widget.url.validate().splitAfter('youtu.be/');
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
