import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/SubscriptionDetailWidget.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/network/rest_apis.dart';
import 'package:streamit_flutter/screens/account_settings_screen.dart';
import 'package:streamit_flutter/screens/edit_profile_screen.dart';
import 'package:streamit_flutter/screens/help_screen.dart';
import 'package:streamit_flutter/screens/terms_conditions_screen.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/constants.dart';
import 'package:streamit_flutter/utils/resources/colors.dart';
import 'package:streamit_flutter/utils/resources/images.dart';
import 'package:streamit_flutter/utils/resources/size.dart';

class MoreFragment extends StatefulWidget {
  static String tag = '/MoreFragment';

  @override
  MoreFragmentState createState() => MoreFragmentState();
}

class MoreFragmentState extends State<MoreFragment> {
  String userName = "";
  String userEmail = "";
  bool isLoaderShow = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    userName = '${await getString(NAME)} ${await getString(LAST_NAME)}';
    userEmail = await getString(USER_EMAIL);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: toolBarTitle(context, 'More'),
        backgroundColor: Theme.of(context).cardColor,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Observer(
                  builder: (_) => Container(
                    color: Theme.of(context).cardColor,
                    padding: EdgeInsets.only(left: spacing_standard_new, top: spacing_standard_new, right: 12, bottom: spacing_standard_new),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: spacing_standard_new,
                          margin: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
                          child: commonCacheImageWidget(
                            appStore.userProfileImage.validate(),
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ).visible(
                            appStore.userProfileImage!.isNotEmpty,
                            defaultWidget: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                              alignment: Alignment.center,
                              child: Icon(Icons.person_outline_rounded, size: 50, color: Colors.black),
                            ),
                          ),
                        ),
                        20.width,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              text(context, '${appStore.userFirstName} ${appStore.userLastName}', fontSize: ts_extra_normal, fontFamily: font_bold, textColor: Theme.of(context).textTheme.headline6!.color),
                              text(context, userEmail, fontSize: ts_normal, fontFamily: font_medium, textColor: Theme.of(context).textTheme.subtitle2!.color)
                            ],
                          ),
                        ),
                        Image.asset(
                          ic_edit_profile,
                          width: 20,
                          height: 20,
                          color: colorPrimary,
                        ).paddingAll(spacing_control).onTap(() {
                          EditProfileScreen().launch(context);
                        })
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Divider(height: 0, thickness: 1),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(color: context.cardColor),
                      child: Text('Membership Plan', style: boldTextStyle(size: 22, color: Colors.white)),
                    ),
                    SubscriptionDetailWidget(),
                    Divider(height: 0),
                    SettingSection(
                      headingDecoration: BoxDecoration(color: context.cardColor),
                      title: Text('General Settings', style: boldTextStyle(size: 22, color: Colors.white)),
                      items: [
                        SettingItemWidget(
                          title: "Account Settings",
                          titleTextStyle: primaryTextStyle(color: Colors.white),
                          leading: Image.asset(ic_settings, color: Colors.white),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).textTheme.caption!.color),
                          onTap: () {
                            AccountSettingsScreen().launch(context);
                          },
                        ),
                        SettingItemWidget(
                          title: "Help",
                          titleTextStyle: primaryTextStyle(color: Colors.white),
                          leading: Image.asset(ic_help, color: Colors.white),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).textTheme.caption!.color),
                          onTap: () {
                            HelpScreen().launch(context);
                          },
                        ),
                      ],
                    ),
                    Divider(height: 0),
                    SettingSection(
                      title: Text('Terms', style: boldTextStyle(size: 22, color: Colors.white)),
                      headingDecoration: BoxDecoration(color: context.cardColor),
                      items: [
                        SettingItemWidget(
                          title: 'Terms & Conditions',
                          titleTextStyle: primaryTextStyle(color: Colors.white),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).textTheme.caption!.color),
                          onTap: () {
                            TermsConditionsScreen().launch(context);
                          },
                        ),
                        SettingItemWidget(
                          title: 'Privacy & Policy',
                          titleTextStyle: primaryTextStyle(color: Colors.white),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).textTheme.caption!.color),
                          onTap: () {
                            TermsConditionsScreen().launch(context);
                          },
                        ),
                        SettingItemWidget(
                          title: 'Logout',
                          titleTextStyle: primaryTextStyle(color: Colors.white),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).textTheme.caption!.color),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  content: Text("Do you want to logout?", style: primaryTextStyle(color: Colors.white)),
                                  actions: [
                                    Text("Cancel", style: primaryTextStyle(color: Colors.white60)).paddingAll(8).onTap(() {
                                      finish(context);
                                    }),
                                    Text("Ok", style: primaryTextStyle(color: colorPrimary)).paddingAll(8).onTap(() {
                                      logout(context);
                                    }),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ).paddingBottom(spacing_large)
              ],
            ),
          ),
          Observer(builder: (_) => Loader().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
