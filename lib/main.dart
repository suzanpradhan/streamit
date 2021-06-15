import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:streamit_flutter/screens/home_screen.dart';
import 'package:streamit_flutter/screens/splash_screen.dart';
import 'package:streamit_flutter/store/AppStore.dart';
import 'package:streamit_flutter/utils/app_theme.dart';
import 'package:streamit_flutter/utils/constants.dart';

AppStore appStore = AppStore();
int mAPIQueueCount = 0;
bool mIsLoggedIn = false;
int? mUserId;
int adShowCount = 0;

bool isMiniPlayer = false;
String miniPlayerUrl = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();

  mUserId = getIntAsync(USER_ID);
  appStore.setUserProfile(getStringAsync(USER_PROFILE));
  appStore.setFirstName(getStringAsync(NAME));
  appStore.setLastName(getStringAsync(LAST_NAME));

  if (isMobile) {
    MobileAds.instance.initialize();

    await OneSignal.shared.setAppId(mOneSignalAPPKey);
    OneSignal.shared.consentGranted(true);
    OneSignal.shared.promptUserForPushNotificationPermission();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setOrientationPortrait();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      home: SafeArea(child: SplashScreen()),
      routes: <String, WidgetBuilder>{
        HomeScreen.tag: (BuildContext context) => HomeScreen(),
      },
      builder: scrollBehaviour(),
    );
  }
}

void updateGlobalColors(BuildContext context) {
  textPrimaryColorGlobal = Colors.black;
  textSecondaryColorGlobal = Theme.of(context).textTheme.headline6!.color!.withOpacity(0.7);
}
