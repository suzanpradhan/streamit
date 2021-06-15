import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/screens/home_screen.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/dots_indicator/dots_indicator.dart';
import 'package:streamit_flutter/utils/resources/images.dart';
import 'package:streamit_flutter/utils/resources/size.dart';
import 'package:streamit_flutter/utils/resources/strings.dart';

class OnBoardingScreen extends StatefulWidget {
  static String tag = '/OnBoardingScreen';

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndexPage = 0;
  PageController controller = new PageController();

  @override
  Widget build(BuildContext context) {
    Widget pageView = PageView(
      controller: controller,
      children: <Widget>[
        WalkThrough(title: walk_titles[0], subtitle: walk_sub_titles[0]),
        WalkThrough(title: walk_titles[1], subtitle: walk_sub_titles[1]),
        WalkThrough(title: walk_titles[2], subtitle: walk_sub_titles[2]),
      ],
      onPageChanged: (value) {
        setState(() => currentIndexPage = value);
      },
    );

    Widget startButton = SizedBox(
      width: double.infinity,
      child: button(context, "Get Started", onTap: () {
        HomeScreen().launch(context, isNewTask: true);
      }),
    );

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          commonCacheImageWidget(ic_walk_background, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
          Container(
            height: double.infinity,
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
          ),
          SafeArea(child: Align(alignment: Alignment.topLeft, child: streamItTitle(context)).paddingAll(spacing_standard_new)),
          Container(height: double.infinity, child: pageView.paddingTop(spacing_standard)),
          Container(
            alignment: Alignment.topLeft,
            height: double.infinity,
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.6),
            child: DotsIndicator(dotsCount: 3, position: currentIndexPage, decorator: dotsDecorator(context)).paddingAll(spacing_standard_new),
          ),
          startButton.paddingAll(spacing_standard_new)
        ],
      ),
    );
  }
}

class WalkThrough extends StatelessWidget {
  final String? title;
  final String? subtitle;

  WalkThrough({Key? key, this.title, this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title!, style: boldTextStyle(size: 22, color: Colors.white)),
          16.height,
          Text(subtitle!, style: secondaryTextStyle(size: 16, color: Colors.white), maxLines: 2),
        ],
      ),
    );
  }
}
