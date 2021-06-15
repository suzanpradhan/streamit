import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  static String tag = '/WebViewScreen';
  final String url;

  WebViewScreen(this.url);

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('title'),
      body: AspectRatio(
        aspectRatio: 16 / 30,
        child: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
