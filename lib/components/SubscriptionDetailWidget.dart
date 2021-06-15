import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/network/network_utils.dart';
import 'package:streamit_flutter/network/rest_apis.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/common.dart';
import 'package:streamit_flutter/utils/constants.dart';
import 'package:streamit_flutter/utils/resources/colors.dart';
import 'package:streamit_flutter/utils/resources/images.dart';
import 'package:streamit_flutter/utils/resources/size.dart';

class SubscriptionDetailWidget extends StatefulWidget {
  @override
  _SubscriptionDetailWidgetState createState() => _SubscriptionDetailWidgetState();
}

class _SubscriptionDetailWidgetState extends State<SubscriptionDetailWidget> {
  Map req = {
    "username": getStringAsync(USERNAME),
    "password": getStringAsync(PASSWORD),
  };

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return getStringAsync(SUBSCRIPTION_PLAN_STATUS).validate() == userPlanStatus
        ? Container(
            width: context.width(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 3)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(getStringAsync(SUBSCRIPTION_PLAN_NAME).validate(), style: primaryTextStyle(color: white, size: ts_xlarge.toInt())).paddingOnly(top: 8, left: 16, right: 16, bottom: 4),
                if (getStringAsync(SUBSCRIPTION_PLAN_NAME).validate() != planName)
                  Text("Valid Till : " + getStringAsync(SUBSCRIPTION_PLAN_EXP_DATE).validate().getFormattedDate()!, style: primaryTextStyle(color: white)).paddingOnly(top: 4, left: 16, right: 16),
                AppButton(
                  child: Text("Upgrade plan", style: boldTextStyle(color: white)),
                  color: colorPrimary,
                  onTap: () async {
                    if (getStringAsync(ACCOUNT_PAGE).isNotEmpty) {
                      await checkPlatformSpecific(context).then((value) async {
                        appStore.setLoading(true);
                        await refreshToken();
                        await getUserProfileDetails().then((value) {
                          setState(() {});
                        });
                      });
                      appStore.setLoading(false);
                    } else {
                      toast(redirectionUrlNotFound);
                    }
                  },
                  width: double.infinity,
                ).paddingOnly(left: 8, right: 8, top: 8, bottom: 8)
              ],
            ),
          ).paddingOnly(left: spacing_standard_new, right: spacing_standard_new, top: 6, bottom: 6)
        : subType(context, "Subscribe now", () async {
            if (getStringAsync(ACCOUNT_PAGE).isNotEmpty) {
              await checkPlatformSpecific(context).then((value) async {
                appStore.setLoading(true);
                await refreshToken();
                await getUserProfileDetails().then((value) {
                  setState(() {});
                });
              });
              appStore.setLoading(false);
            } else {
              toast(redirectionUrlNotFound);
            }
          }, ic_subscribe);
  }
}
