import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/resources/images.dart';

import 'ChangePasswordScreen.dart';

class AccountSettingsScreen extends StatefulWidget {
  static String tag = '/AccountSettingsScreen';

  @override
  AccountSettingsScreenState createState() => AccountSettingsScreenState();
}

class AccountSettingsScreenState extends State<AccountSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarLayout(context, 'Account Settings'),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            subType(context, "Change Password", () {
              ChangePasswordScreen().launch(context);
            }, ic_password),
            /*subType(context, "Video Quality", () {}, ic_video),
            subType(context, "Download Settings", () {}, ic_download),*/
          ],
        ),
      ),
    );
  }
}
