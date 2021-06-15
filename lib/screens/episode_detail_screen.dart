import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/CommentWidget.dart';
import 'package:streamit_flutter/models/CommentModel.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/models/MovieDetailResponse.dart';
import 'package:streamit_flutter/network/network_utils.dart';
import 'package:streamit_flutter/network/rest_apis.dart';
import 'package:streamit_flutter/screens/movieDetailComponents/MovieFileWidget.dart';
import 'package:streamit_flutter/screens/movieDetailComponents/MovieURLWidget.dart';
import 'package:streamit_flutter/screens/signin.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/common.dart';
import 'package:streamit_flutter/utils/constants.dart';
import 'package:streamit_flutter/utils/resources/colors.dart';
import 'package:streamit_flutter/utils/resources/size.dart';

import '../main.dart';

class EpisodeDetailScreen extends StatefulWidget {
  static String tag = '/EpisodeDetailScreen';
  final String? title;
  final Episode? episode;
  final List<Episode>? episodes;
  final int? index;
  final int? lastIndex;

  EpisodeDetailScreen({this.title, this.episode, this.episodes, this.index, this.lastIndex});

  @override
  EpisodeDetailScreenState createState() => EpisodeDetailScreenState();
}

class EpisodeDetailScreenState extends State<EpisodeDetailScreen> with WidgetsBindingObserver {
  ScrollController scrollController = ScrollController();

  TextEditingController mainCommentCont = TextEditingController();
  TextEditingController firstInnerCommCont = TextEditingController();
  TextEditingController secondInnerCommCont = TextEditingController();

  bool isLoaded = false;

  List<MovieData> actors = [];
  bool isExpanded = false;

  bool isSubscribe = false;

  List<CommentModel> commentList = [];
  List<CommentModel> innerCommentList = [];

  int page = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft, DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    //getUserDetails();

    getUserPlanData();
    loadComments();
  }

  Future<void> loadComments() async {
    if (widget.episode!.no_of_comments! > 0) {
      appStore.setLoading(true);

      await getComments(postId: widget.episode!.id, page: page, commentPerPage: widget.episode!.no_of_comments).then((value) {
        commentList.clear();

        commentList.addAll(value);

        setState(() {});

        appStore.setLoading(false);
      }).catchError((error) {
        appStore.setLoading(false);

        toast(error.toString());
      });
    }
  }

  Future<void> getUserPlanData() async {
    for (var i in widget.episode!.restrict_subscription_plan.validate()) {
      if (getStringAsync(SUBSCRIPTION_PLAN_NAME).toLowerCase() == i.label!.toLowerCase() && getStringAsync(SUBSCRIPTION_PLAN_STATUS) == userPlanStatus) {
        isSubscribe = true;
      }
    }

    setState(() {});
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    Widget episodesList = Container(
      height: ((width / 2) - 36) * (2.5 / 4) + 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.episodes!.length,
        padding: EdgeInsets.only(left: spacing_standard, right: spacing_standard_new),
        itemBuilder: (context, index) {
          Episode episode = widget.episodes![index];

          return Container(
            decoration: widget.index == index ? boxDecoration(context, color: colorPrimary, radius: 5) : null,
            margin: EdgeInsets.only(left: spacing_standard),
            width: (width / 2) - 36,
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 4 / 2.5,
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: spacing_control_half,
                        margin: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spacing_control)),
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: <Widget>[
                            commonCacheImageWidget(episode.image.validate(), width: double.infinity, height: double.infinity, fit: BoxFit.cover),
                            Container(
                              decoration: boxDecoration(context, bgColor: Colors.white.withOpacity(0.8)),
                              padding: EdgeInsets.only(left: spacing_control, right: spacing_control),
                              child: text(context, "EPISODE " + (index + 1).toString(), fontSize: 10, textColor: Colors.black, fontFamily: font_medium),
                            ).paddingAll(spacing_control)
                          ],
                        ),
                      ),
                    ),
                  ),
                  8.height,
                  itemSubTitle(context, "${episode.episode_number.validate()} , ${episode.release_date.validate()}", fontsize: ts_medium),
                ],
              ),
              onTap: () async {
                finish(context);
                EpisodeDetailScreen(title: episode.title.validate(), episode: episode, episodes: widget.episodes, index: index, lastIndex: widget.episodes!.length).launch(context);
              },
              radius: spacing_control,
            ),
          );
        },
      ),
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: mounted
            ? FutureBuilder<MovieDetailResponse>(
                future: episodeDetail(widget.episode!.id),
                builder: (_, snap) {
                  if (snap.hasData) {
                    //
                  }
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            if (isSubscribe ||
                                ((widget.episode!.restrict_user_status != UserRestrictionStatus || widget.episode!.restrict_user_status == '' || (widget.episode!.restrict_user_status == UserRestrictionStatus && mIsLoggedIn)) &&
                                    widget.episode!.restrict_subscription_plan.validate().isEmpty))
                              checkEpisodeData()
                            else
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Stack(
                                  children: [
                                    commonCacheImageWidget(
                                      widget.episode!.image.validate(),
                                      width: context.width(),
                                      fit: BoxFit.cover,
                                    ),
                                    Container(color: Colors.black.withOpacity(0.7), width: context.width()),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if ((widget.episode!.restrict_user_status == UserRestrictionStatus || widget.episode!.restrict_user_status == '') && mIsLoggedIn)
                                          if (widget.episode!.restriction_setting!.restrict_type == RestrictionTypeMessage ||
                                              widget.episode!.restriction_setting!.restrict_type == RestrictionTypeTemplate ||
                                              widget.episode!.restriction_setting!.restrict_type == " ")
                                            Column(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    openInfoBottomSheet(
                                                      context: context,
                                                      restrictSubscriptionPlan: widget.episode!.restrict_subscription_plan,
                                                      data: HtmlWidget(
                                                        '<html>${widget.episode!.restriction_setting!.restrict_message.validate().replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&quot;', '"').replaceAll('[embed]', '<embed>').replaceAll('[/embed]', '</embed>').replaceAll('[caption]', '<caption>').replaceAll('[/caption]', '</caption>')}</html>',
                                                      ),
                                                      btnText: "Subscribe now",
                                                      onTap: () async {
                                                        finish(context);
                                                        if (getStringAsync(ACCOUNT_PAGE).isNotEmpty) {
                                                          await launchURL(getStringAsync(REGISTRATION_PAGE)).then((value) async {
                                                            await refreshToken();
                                                            getUserProfileDetails().then((value) {
                                                              setState(() {});
                                                            });
                                                          });
                                                        } else {
                                                          toast(redirectionUrlNotFound);
                                                        }
                                                      },
                                                    );
                                                  },
                                                  child: Text("View Info", style: boldTextStyle(color: Colors.white)),
                                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colorPrimary)),
                                                ),
                                              ],
                                            ),
                                        if ((widget.episode!.restrict_user_status == UserRestrictionStatus || widget.episode!.restrict_user_status == '') && !mIsLoggedIn)
                                          Column(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  openInfoBottomSheet(
                                                    context: context,
                                                    restrictSubscriptionPlan: widget.episode!.restrict_subscription_plan,
                                                    data: HtmlWidget(
                                                      '<html>${widget.episode!.restriction_setting!.restrict_message.validate().replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&quot;', '"').replaceAll('[embed]', '<embed>').replaceAll('[/embed]', '</embed>').replaceAll('[caption]', '<caption>').replaceAll('[/caption]', '</caption>')}</html>',
                                                    ),
                                                    btnText: "Login now",
                                                    onTap: () {
                                                      finish(context);
                                                      SignInScreen().launch(context);
                                                    },
                                                  );
                                                },
                                                child: Text("View Info", style: boldTextStyle(color: Colors.white)),
                                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colorPrimary)),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ).center(),
                                  ],
                                ),
                              ).paddingBottom(16),
                            if (isSnapshotLoading(snap, checkHasData: true)) Loader().center(),
                            Positioned(child: BackButton().paddingAll(12), top: 0, left: 0),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                AppButton(
                                  enabled: widget.index == 0 ? false : true,
                                  color: colorPrimary,
                                  child: Text("Previous", style: primaryTextStyle(color: white)),
                                  onTap: () {
                                    finish(context);
                                    EpisodeDetailScreen(
                                            title: widget.episodes![widget.index! - 1].title.validate(),
                                            episode: widget.episodes![widget.index! - 1],
                                            episodes: widget.episodes,
                                            index: widget.index! - 1,
                                            lastIndex: widget.episodes!.length)
                                        .launch(context);
                                  },
                                ).expand(flex: 2),
                                16.width,
                                AppButton(
                                  color: colorPrimary,
                                  enabled: widget.lastIndex! - 1 == widget.index ? false : true,
                                  child: Text("Next", style: primaryTextStyle(color: white)),
                                  onTap: () {
                                    finish(context);
                                    EpisodeDetailScreen(
                                            title: widget.episodes![widget.index! + 1].title.validate(),
                                            episode: widget.episodes![widget.index! + 1],
                                            episodes: widget.episodes,
                                            index: widget.index! + 1,
                                            lastIndex: widget.episodes!.length)
                                        .launch(context);
                                  },
                                ).expand(flex: 2),
                              ],
                            ).paddingOnly(left: 16, right: 16),
                            16.height,
                            Row(
                              children: <Widget>[
                                Expanded(child: headingText(context, widget.title)),
                                widget.episode!.trailer_link != null
                                    ? InkWell(
                                        onTap: () {
                                          movieTrialDialog(context, widget.episode!.trailer_link);
                                        },
                                        borderRadius: BorderRadius.circular(4),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(border: Border.all(color: colorPrimary), borderRadius: BorderRadius.circular(4)),
                                          child: Text('Trailer Link', style: boldTextStyle(color: colorPrimary)),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ).paddingOnly(left: spacing_standard_new, right: spacing_standard_new),
                            Row(
                              children: [
                                itemSubTitle(context, "${widget.episode!.episode_number.validate()}, ${widget.episode!.release_date.validate()}").paddingOnly(left: spacing_standard_new, right: spacing_standard_new).expand(),
                                IconButton(
                                  icon: Icon(!isExpanded ? Icons.arrow_drop_down : Icons.arrow_drop_up),
                                  onPressed: () {
                                    isExpanded = !isExpanded;
                                    setState(() {});
                                  },
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                itemSubTitle(context, widget.episode!.excerpt.validate()),
                                8.height,
                                Row(
                                  children: [
                                    itemSubTitle(context, 'Run time:'),
                                    8.width,
                                    itemTitle(context, widget.episode!.run_time.validate()),
                                  ],
                                ),
                              ],
                            ).paddingOnly(left: spacing_standard_new, right: spacing_standard_new, bottom: spacing_standard_new).visible(isExpanded),
                            Divider(thickness: 1, height: 1).paddingTop(spacing_standard),
                            headingWidViewAll(context, "Episodes", callback: () {
                              finish(context);
                            }).paddingAll(spacing_standard_new),
                            episodesList,
                            16.height,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${buildCommentCountText(widget.episode!.no_of_comments.validate())}', style: boldTextStyle(size: 22, color: textColorPrimary)),
                                16.height,
                                mIsLoggedIn
                                    ? AppTextField(
                                        controller: mainCommentCont,
                                        textFieldType: TextFieldType.ADDRESS,
                                        maxLines: 3,
                                        textStyle: primaryTextStyle(color: textColorPrimary),
                                        errorThisFieldRequired: errorThisFieldRequired,
                                        decoration: InputDecoration(
                                          hintText: comment,
                                          hintStyle: secondaryTextStyle(),
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.send),
                                            color: colorPrimary,
                                            onPressed: () {
                                              hideKeyboard(context);

                                              buildComment(content: mainCommentCont.text.trim(), postId: widget.episode!.id).then((value) {
                                                mainCommentCont.clear();

                                                commentList.add(value);
                                                widget.episode!.no_of_comments = widget.episode!.no_of_comments! + 1;
                                              }).catchError((error) {
                                                toast(errorSomethingWentWrong);
                                              });
                                            },
                                          ),
                                          border: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                                        ),
                                      )
                                    : Text('Login to add comment', style: primaryTextStyle(color: colorPrimary, size: 18)).onTap(() {
                                        SignInScreen().launch(context);
                                      }),
                              ],
                            ).paddingAll(16),
                            Divider(thickness: 0.1, color: textColorPrimary),
                            CommentWidget(commentList: commentList, postId: widget.episode!.id!, noOfComments: widget.episode!.no_of_comments!),
                            8.height,
                            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              )
            : SizedBox(),
      ),
    );
  }

  Widget checkEpisodeData() {
    if (widget.episode!.embed_content.validate().isNotEmpty) {
      return EmbedWidget(widget.episode!.embed_content.validate()).center();
    }
    if (widget.episode!.episode_choice.validate() == episodeChoiceURL) {
      return MovieURLWidget(widget.episode!.url_link.validate());
    } else if (widget.episode!.episode_choice.validate() == episodeChoiceEmbed) {
      return EmbedWidget(widget.episode!.embed_content.validate()).center();
    } else if (widget.episode!.episode_choice.validate() == episodeChoiceFile) {
      return MovieFileWidget(widget.episode!.episode_file.validate());
    } else {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: commonCacheImageWidget(widget.episode!.image.validate(), fit: BoxFit.cover).visible(!isLoaded),
      );
    }
  }
}
