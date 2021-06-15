import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/models/DashboardResponse.dart';
import 'package:streamit_flutter/network/rest_apis.dart';
import 'package:streamit_flutter/screens/ViewAllMoviesScreen.dart';
import 'package:streamit_flutter/screens/movieDetailComponents/HomeSliderWidget.dart';
import 'package:streamit_flutter/screens/movieDetailComponents/ItemHorizontalList.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/constants.dart';
import 'package:streamit_flutter/utils/resources/images.dart';

class HomeCategoryFragment extends StatefulWidget {
  static String tag = '/SubHomeFragment';
  final String? type;

  HomeCategoryFragment({this.type});

  @override
  HomeCategoryFragmentState createState() => HomeCategoryFragmentState();
}

class HomeCategoryFragmentState extends State<HomeCategoryFragment> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> savePref(AsyncSnapshot<DashboardResponse> snap) async {
    await setValue(REGISTRATION_PAGE, snap.data!.register_page);
    await setValue(ACCOUNT_PAGE, snap.data!.account_page);
    await setValue(LOGIN_PAGE, snap.data!.login_page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        child: FutureBuilder<DashboardResponse>(
          future: getDashboardData({}, type: widget.type.validate(value: dashboardTypeHome)),
          builder: (_, snap) {
            if (snap.hasData) {
              if (snap.data!.banner.validate().isEmpty && snap.data!.sliders.validate().isEmpty) {
                return noDataWidget();
              }

              savePref(snap);

              return SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    20.height,
                    DashboardSliderWidget(snap.data!.banner.validate()),
                    Column(
                      children: snap.data!.sliders.validate().map((e) {
                        return Container(
                          margin: EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(e.title.validate(), style: boldTextStyle(color: Colors.white)).paddingLeft(16).expand(),
                                  Text('View all', style: secondaryTextStyle(color: Colors.white, size: 12)).paddingOnly(right: 16, left: 16, top: 8, bottom: 8).onTap(() {
                                    ViewAllMoviesScreen(snap.data!.sliders!.indexOf(e), widget.type).launch(context);
                                  }).visible(e.viewAll.validate()),
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              ).visible(e.data.validate().isNotEmpty),
                              16.height,
                              ItemHorizontalList(e.data.validate()),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            } else {
              return snapWidgetHelper(snap, loadingWidget: Image.asset(ic_loading_gif, fit: BoxFit.cover, height: 100, width: 100)).center();
            }
          },
        ),
      ),
    );
  }
}
