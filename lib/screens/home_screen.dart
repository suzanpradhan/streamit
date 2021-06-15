import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:streamit_flutter/fragments/home_fragment.dart';
import 'package:streamit_flutter/fragments/more_fragment.dart';
import 'package:streamit_flutter/fragments/search_fragment.dart';
import 'package:streamit_flutter/fragments/watchlist_fragment.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/MovieDetailResponse.dart';
import 'package:streamit_flutter/network/rest_apis.dart';
import 'package:streamit_flutter/screens/movie_detail_screen.dart';
import 'package:streamit_flutter/screens/signin.dart';
import 'package:streamit_flutter/utils/constants.dart';
import 'package:streamit_flutter/utils/resources/colors.dart';
import 'package:streamit_flutter/utils/resources/images.dart';

class HomeScreen extends StatefulWidget {
  static String tag = '/HomeScreen';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  HomeFragment homeFragment = HomeFragment();
  SearchFragment searchFragment = SearchFragment();
  WatchlistFragment myFilesFragment = WatchlistFragment();
  MoreFragment moreFragment = MoreFragment();
  late List<Widget> viewContainer;

  @override
  void initState() {
    super.initState();
    viewContainer = [homeFragment, searchFragment, myFilesFragment, moreFragment];
    init();
  }

  Future<void> init() async {
    OneSignal.shared.setNotificationOpenedHandler((notification) async {
      if (getBoolAsync(isLoggedIn)) {
        if (notification.notification.additionalData != null) {
          if (notification.notification.additionalData!.containsKey('id')) {
            String? postId = notification.notification.additionalData!["id"];
            String? postType = notification.notification.additionalData!["post_type"];

            Future<MovieDetailResponse>? future;

            if (postType == 'movie') {
              future = movieDetail(postId.toInt().validate());
            } else if (postType == 'tv_show') {
              future = tvShowDetail(postId.toInt().validate());
            } else if (postType == 'episode') {
              future = episodeDetail(postId.toInt().validate());
            } else if (postType == 'video') {
              future = getVideosDetail(postId.toInt().validate());
            }

            if (postId.validate().isNotEmpty && future != null) {
              await future.then((value) {
                MovieDetailScreen(movie: value.data).launch(context);
              });
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (selectedIndex == 0) return true;
          setState(() {
            selectedIndex = 0;
          });
          return false;
        },
        child: Scaffold(
          body: viewContainer[selectedIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).splashColor,
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.1), offset: Offset.fromDirection(3, 1), spreadRadius: 3, blurRadius: 5),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              backgroundColor: Theme.of(context).splashColor,
              type: BottomNavigationBarType.fixed,
              onTap: (i) async {
                if ((i == 3 || i == 2) && !mIsLoggedIn) {
                  SignInScreen().launch(context);
                } else {
                  selectedIndex = i;
                  setState(() {});
                }
              },
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(ic_home, fit: BoxFit.fitHeight, color: Colors.white, height: 24, width: 24),
                  activeIcon: Image.asset(ic_home, color: colorPrimary, height: 24, width: 24),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(ic_search, fit: BoxFit.fitHeight, color: Colors.white, height: 24, width: 24),
                  activeIcon: Image.asset(ic_search, color: colorPrimary, height: 24, width: 24),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_outline_outlined, size: 24, color: Colors.white),
                  activeIcon: Icon(Icons.bookmark_outline_outlined, color: colorPrimary, size: 24),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined, size: 24, color: Colors.white),
                  activeIcon: Icon(Icons.settings_outlined, size: 24, color: colorPrimary),
                  label: '',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
