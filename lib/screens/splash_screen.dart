import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/network/rest_apis.dart';
import 'package:streamit_flutter/screens/home_screen.dart';
import 'package:streamit_flutter/screens/onboarding_screen.dart';
import 'package:streamit_flutter/utils/common.dart';
import 'package:streamit_flutter/utils/constants.dart';
import 'package:streamit_flutter/utils/resources/images.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  void navigationPage() async {
    await 3500.milliseconds.delay;

    mIsLoggedIn = getBoolAsync(isLoggedIn);

    if (getBoolAsync(isFirstTime, defaultValue: true)) {
      await setValue(isFirstTime, false);
      OnBoardingScreen().launch(context, isNewTask: true);
    } else if (mIsLoggedIn) {
      await getUserProfileDetails().then((res) async {
        getDetails(logRes: res).then((value) => HomeScreen().launch(context));
      }).catchError((e) async {
        log('Token Refreshing');

        Map req = {
          "username": await getString(USER_EMAIL),
          "password": await getString(PASSWORD),
        };

        await token(req).then((value) {
          HomeScreen().launch(context, isNewTask: true);
        }).catchError((e) {
          logout(context);
        });
      });
    } else {
      HomeScreen().launch(context, isNewTask: true);
    }
  }

  @override
  void initState() {
    super.initState();
    navigationPage();
    setStatusBarColor(Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        child: Center(
          child: Image.asset(ic_loading_gif, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
