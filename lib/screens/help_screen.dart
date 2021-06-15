import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/screens/faq_screen.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/resources/images.dart';

class HelpScreen extends StatefulWidget {
  static String tag = '/HelpScreen';

  @override
  HelpScreenState createState() => HelpScreenState();
}

class HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarLayout(context, 'Help'),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            subType(context, "Report Problem", () {}, ic_report),
            subType(context, "Help Center", () {}, ic_help),
            subType(context, "FAQ", () {
              FaqScreen().launch(context);
            }, ic_faq),
          ],
        ),
      ),
    );
  }
}
