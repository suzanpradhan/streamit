import 'package:flutter/material.dart';
import 'package:streamit_flutter/fragments/sub_home_fragment.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/constants.dart';
import 'package:streamit_flutter/utils/resources/colors.dart';
import 'package:streamit_flutter/utils/resources/size.dart';

class HomeFragment extends StatefulWidget {
  static String tag = '/HomeFragment';

  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends State<HomeFragment> {
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          centerTitle: false,
          title: streamItTitle(context),
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 45),
            child: Align(
              alignment: Alignment.topLeft,
              child: TabBar(
                isScrollable: true,
                indicatorPadding: EdgeInsets.only(left: 30, right: 30),
                indicatorWeight: 3.0,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(fontFamily: font_medium, fontSize: ts_normal),
                indicatorColor: colorPrimary,
                onTap: (i) {
                  index = i;
                  setState(() {});
                },
                unselectedLabelColor: Theme.of(context).textTheme.headline6!.color,
                labelColor: colorPrimary,
                labelPadding: EdgeInsets.only(left: spacing_large, right: spacing_large),
                tabs: [
                  Tab(child: Text('Home')),
                  Tab(child: Text('Movies')),
                  Tab(child: Text('TV Shows')),
                  Tab(child: Text('Videos')),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            HomeCategoryFragment(type: dashboardTypeHome),
            HomeCategoryFragment(type: dashboardTypeMovie),
            HomeCategoryFragment(type: dashboardTypeTVShow),
            HomeCategoryFragment(type: dashboardTypeVideo),
          ],
        ),
      ),
    );
  }
}
