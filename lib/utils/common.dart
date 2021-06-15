import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/models/CommentModel.dart';
import 'package:streamit_flutter/models/LoginResponse.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/network/rest_apis.dart';
import 'package:streamit_flutter/screens/UrlLauncherScreen.dart';
import 'package:streamit_flutter/screens/movieDetailComponents/MovieURLWidget.dart';
import 'package:streamit_flutter/utils/constants.dart';
import 'package:streamit_flutter/utils/resources/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

Future<void> launchURL(String url, {bool forceWebView = true, Map<String, String>? header}) async {
  await launch(url, enableJavaScript: true, forceWebView: forceWebView, headers: header ?? {}, enableDomStorage: false, forceSafariVC: false);
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

String buildLikeCountText(int like) {
  if (like > 1) {
    return '$like likes';
  } else {
    return '$like like';
  }
}

String buildCommentCountText(int comment) {
  if (comment > 1) {
    return '$comment comments';
  } else {
    return '$comment comment';
  }
}

extension SExt on String {
  int getYear() {
    return DateTime.parse(this).year;
  }

  String? getFormattedDate({String format = defaultDateFormat}) {
    try {
      return DateFormat(format).format(DateTime.parse(this));
    } on FormatException catch (e) {
      return e.source;
    }
  }
}

String getPostType(PostType postType) {
  if (postType == PostType.MOVIE) {
    return 'Movie';
  } else if (postType == PostType.TV_SHOW) {
    return 'TV Show';
  } else if (postType == PostType.EPISODE) {
    return 'Episode';
  }
  return '';
}

Future<void> getDetails({required LoginResponse logRes}) async {
  await setValue(USER_ID, logRes.user_id);
  await setValue(NAME, logRes.first_name);
  await setValue(LAST_NAME, logRes.last_name);
  await setValue(USER_PROFILE, logRes.profile_image);
  await setValue(USER_EMAIL, logRes.user_email);
  await setValue(USERNAME, logRes.username);

  mUserId = await getInt(USER_ID);

  await Future.forEach(logRes.plan!.subscriptions.validate(), (dynamic data) async {
    await setValue(SUBSCRIPTION_PLAN_STATUS, data.status);

    if (data.status == userPlanStatus) {
      await setValue(SUBSCRIPTION_PLAN_ID, data.subscription_plan_id);
      await setValue(SUBSCRIPTION_PLAN_START_DATE, data.start_date);
      await setValue(SUBSCRIPTION_PLAN_EXP_DATE, data.expiration_date);
      await setValue(SUBSCRIPTION_PLAN_STATUS, data.status);
      await setValue(SUBSCRIPTION_PLAN_TRIAL_STATUS, data.trail_status);
      await setValue(SUBSCRIPTION_PLAN_NAME, data.subscription_plan_name);
      await setValue(SUBSCRIPTION_PLAN_AMOUNT, data.billing_amount);
      await setValue(SUBSCRIPTION_PLAN_TRIAL_END_DATE, data.trial_end);
    }
  });
}

Future<void> callNativeWebView(Map params) async {
  const platform = const MethodChannel('webviewChannel');

  if (isMobile) {
    await platform.invokeMethod('webview', params);
  }
}

Future<void> checkPlatformSpecific(BuildContext context) async {
  if (getStringAsync(ACCOUNT_PAGE).isNotEmpty) {
    await UrlLauncherScreen('${getStringAsync(ACCOUNT_PAGE)}').launch(context);
  } else {
    toast(redirectionUrlNotFound);
  }
}

Future<void> openInfoBottomSheet({required BuildContext context, Widget? data, String? btnText, Function? onTap, List<RestrictSubscriptionPlan>? restrictSubscriptionPlan}) async {
  double height = 0.5;
  return showModalBottomSheet(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    builder: (_) => FractionallySizedBox(
      heightFactor: height,
      child: DraggableScrollableSheet(
        initialChildSize: 1.0,
        minChildSize: 0.95,
        builder: (_, controller) {
          return Stack(
            children: [
              Container(
                height: context.height() * height,
                padding: EdgeInsets.all(16),
                color: Colors.white,
                width: context.width(),
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      data!,
                      16.height,
                      restrictSubscriptionPlan!.isNotEmpty ? Text("You can subscribe any of these plan(s)", style: primaryTextStyle(size: 18, color: colorPrimary), textAlign: TextAlign.center) : SizedBox(),
                      8.height,
                      UL(children: restrictSubscriptionPlan.map((e) => Text(e.label.validate(), style: primaryTextStyle())).toList(), symbolType: SymbolType.Numbered),
                      24.height,
                    ],
                  ).center(),
                ),
              ).cornerRadiusWithClipRRectOnly(topRight: 32, topLeft: 32).paddingBottom(24),
              Positioned(
                bottom: 0,
                width: context.width(),
                child: Container(
                  color: white,
                  child: ElevatedButton(
                    child: Text(btnText!, style: boldTextStyle(color: white), textAlign: TextAlign.center),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colorPrimary)),
                    onPressed: onTap as void Function()?,
                  ).paddingOnly(left: 64, right: 64),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

Future<void> movieTrialDialog(BuildContext context, String? url) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.9),
    barrierDismissible: false,
    builder: (_) {
      return Stack(
        children: [
          Positioned(
            right: 8,
            top: 16,
            child: GestureDetector(
              onTap: () {
                finish(context);
              },
              child: Icon(Icons.close),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: MovieURLWidget(url),
          ).paddingSymmetric(vertical: 50, horizontal: 8),
        ],
      );
    },
  );
}

Future<bool> getUserPlanData(List<RestrictSubscriptionPlan>? restPlan) async {
  for (var i in restPlan!) {
    if (getStringAsync(SUBSCRIPTION_PLAN_NAME).toLowerCase() == i.label!.toLowerCase() && getStringAsync(SUBSCRIPTION_PLAN_STATUS) == userPlanStatus) {
      return true;
    }
  }
  return false;
}

Future<CommentModel> buildComment({int? parentId, required String content, required int? postId}) async {
  if (content.isNotEmpty) {
    CommentModel comment = CommentModel();

    comment.post = postId;
    comment.parent = parentId ?? 0;
    comment.author = getIntAsync(USER_ID).toInt();
    comment.author_name = getStringAsync(USERNAME);
    comment.date = DateTime.now().toString();
    comment.date_gmt = DateTime.now().toString();
    comment.commentData = content;
    comment.author_url = '';
    comment.link = '';

    return await addComment(comment.toJson()).then((value) {
      toast(commentAdded);
      return value;
    }).catchError((error) {
      toast(error.toString());
    });
  } else {
    throw (writeSomething);
  }
}

Future<void> multiCommentSheet({BuildContext? context, int? id, List<CommentModel>? list, TextEditingController? controller, required int postId, int? parentId, Function(CommentModel)? onCommentSubmit}) async {
  return showModalBottomSheet(
    context: context!,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
    ),
    builder: (_) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                Column(
                  children: list!.map((e) {
                    return e.parent == id
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                child: Text(e.author_name![0].validate(), style: boldTextStyle(color: colorPrimary, size: 20)).center(),
                              ),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(e.author_name.validate(), style: boldTextStyle(color: Colors.white54)),
                                          TextIcon(
                                            prefix: Icon(Icons.calendar_today_outlined, size: 14, color: textSecondaryColorGlobal),
                                            edgeInsets: EdgeInsets.zero,
                                            text: DateFormat('yyyy-MM-dd').format(DateTime.parse(e.date.validate())),
                                            textStyle: secondaryTextStyle(),
                                          )
                                        ],
                                      ).expand(),
                                      Container(
                                        child: TextButton(
                                          onPressed: () {
                                            e.isAddReply = !e.isAddReply;
                                            setState(() {});
                                          },
                                          child: Text('Add reply', style: primaryTextStyle(color: white, size: 14)),
                                          style: ButtonStyle(side: MaterialStateProperty.all(BorderSide(color: colorPrimary))),
                                        ),
                                      ).visible(mIsLoggedIn),
                                    ],
                                  ),
                                  4.height,
                                  Text(parseHtmlString(e.content!.rendered.validate()), style: primaryTextStyle(color: Colors.grey, size: 14)),
                                  AppTextField(
                                    controller: controller!,
                                    textFieldType: TextFieldType.ADDRESS,
                                    maxLines: 3,
                                    textStyle: primaryTextStyle(color: textColorPrimary),
                                    decoration: InputDecoration(
                                      hintText: reply,
                                      hintStyle: secondaryTextStyle(),
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.send, size: 18),
                                        color: colorPrimary,
                                        onPressed: () {
                                          buildComment(content: controller.text.trim(), postId: postId, parentId: parentId).then((value) {
                                            controller.clear();
                                            onCommentSubmit!.call(value);
                                          }).catchError((error) {
                                            toast(errorSomethingWentWrong);
                                          });
                                        },
                                      ),
                                      border: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                                    ),
                                  ).visible(e.isAddReply),
                                  8.height,
                                  Divider(thickness: 0.1, color: textColorPrimary, height: 0),
                                  16.height,
                                  Column(
                                    children: list.map((i) {
                                      return i.parent == e.id
                                          ? Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(12),
                                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                                  child: Text(i.author_name![0].validate(), style: boldTextStyle(color: colorPrimary, size: 20)).center(),
                                                ),
                                                16.width,
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(i.author_name.validate(), style: boldTextStyle(color: Colors.white)),
                                                        TextIcon(
                                                          prefix: Icon(Icons.calendar_today_outlined, size: 14, color: textSecondaryColorGlobal),
                                                          edgeInsets: EdgeInsets.zero,
                                                          text: DateFormat('yyyy-MM-dd').format(DateTime.parse(i.date.validate())),
                                                          textStyle: secondaryTextStyle(),
                                                        )
                                                      ],
                                                    ),
                                                    8.height,
                                                    Text(parseHtmlString(i.content!.rendered.validate()), style: primaryTextStyle(color: Colors.grey, size: 14)),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : SizedBox();
                                    }).toList(),
                                  )
                                ],
                              ).expand(),
                            ],
                          ).paddingSymmetric(vertical: 8, horizontal: 16)
                        : SizedBox();
                  }).toList(),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
