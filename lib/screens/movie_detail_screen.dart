import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/CommentWidget.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/CommentModel.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/models/MovieDetailResponse.dart';
import 'package:streamit_flutter/network/network_utils.dart';
import 'package:streamit_flutter/network/rest_apis.dart';
import 'package:streamit_flutter/screens/movieDetailComponents/ItemHorizontalList.dart';
import 'package:streamit_flutter/screens/movieDetailComponents/MovieDetailLikeWatchListWidget.dart';
import 'package:streamit_flutter/screens/signin.dart';
import 'package:streamit_flutter/screens/view_all_movies_screen.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/common.dart';
import 'package:streamit_flutter/utils/constants.dart';
import 'package:streamit_flutter/utils/resources/colors.dart';
import 'package:streamit_flutter/utils/resources/size.dart';

import 'movieDetailComponents/MovieFileWidget.dart';
import 'movieDetailComponents/MovieURLWidget.dart';
import 'movieDetailComponents/SeasonDataWidget.dart';

// ignore: must_be_immutable
class MovieDetailScreen extends StatefulWidget {
  static String tag = '/MovieDetailScreen';
  String? title = "";
  MovieData? movie;
  String? id;

  MovieDetailScreen({this.title, this.movie, this.id});

  @override
  MovieDetailScreenState createState() => MovieDetailScreenState();
}

class MovieDetailScreenState extends State<MovieDetailScreen> with WidgetsBindingObserver {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();

  TextEditingController mainCommentCont = TextEditingController();

  List<MovieData> mMovieList = [];
  List<MovieData> mMovieOriginalsList = [];

  bool isSubscribe = false;

  Future<MovieDetailResponse>? future;

  int page = 1;

  List<CommentModel> commentList = [];
  List<CommentModel> innerCommentList = [];

  InterstitialAd? interstitialAd;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    if (widget.movie!.postType == PostType.MOVIE) {
      future = movieDetail(widget.movie!.id.validate());
    } else if (widget.movie!.postType == PostType.TV_SHOW) {
      future = tvShowDetail(widget.movie!.id.validate());
    } else if (widget.movie!.postType == PostType.EPISODE) {
      future = episodeDetail(widget.movie!.id.validate());
    } else if (widget.movie!.postType == PostType.VIDEO) {
      future = getVideosDetail(widget.movie!.id.validate());
    }
    //fetch user plan data from shared pref
    loadComments();

    if (!disabledAds) {
      log('ads count $adShowCount');
      if (adShowCount < 5) {
        adShowCount++;
      } else {
        adShowCount = 0;
        buildInterstitialAd();
      }
    }
    init();
  }

  Future<void> init() async {
    isSubscribe = await getUserPlanData(widget.movie!.restSubPlan.validate());
  }

  Future<void> loadComments() async {
    if (widget.movie!.no_of_comments.validate() > 0) {
      appStore.setLoading(true);

      await getComments(postId: widget.movie!.id, page: page, commentPerPage: widget.movie!.no_of_comments).then((value) {
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

  void showInterstitialAd() {
    if (interstitialAd == null) {
      log('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        //
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        buildInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        buildInterstitialAd();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }

  void buildInterstitialAd() {
    InterstitialAd.load(
      adUnitId: kReleaseMode ? mAdMobInterstitialId : InterstitialAd.testAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          this.interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  double roundDouble({required double value, int? places}) {
    return ((value * 10).round().toDouble() / 10);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    scrollController.dispose();
    showInterstitialAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBarLayout(context, parseHtmlString(widget.movie!.title.validate()), darkBackground: false),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: FutureBuilder<MovieDetailResponse>(
          future: future!.then((value) => value),
          builder: (_, snap) {
            String genre = '';
            if (snap.hasData) {
              widget.movie = snap.data!.data!;

              if (widget.movie!.postType == PostType.TV_SHOW) {
                log(snap.data!.seasons.validate().length);
              }

              if (snap.data!.data!.genre != null) {
                snap.data!.data!.genre!.forEach((element) {
                  if (genre.isNotEmpty) {
                    genre = '$genre • ${element.name.validate()}';
                  } else {
                    genre = element.name.validate();
                  }
                });
              }

              if (snap.data!.data!.cat != null) {
                snap.data!.data!.cat!.forEach((element) {
                  if (genre.isNotEmpty) {
                    genre = '$genre • ${element.name.validate()}';
                  } else {
                    genre = element.name.validate();
                  }
                });
              }
            }
            return Container(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isSubscribe ||
                            ((widget.movie!.restrict_user_status != UserRestrictionStatus || widget.movie!.restrict_user_status == '' || (widget.movie!.restrict_user_status == UserRestrictionStatus && mIsLoggedIn)) &&
                                widget.movie!.restSubPlan.validate().isEmpty))
                          if (isMobile && (widget.movie!.choice.validate() == movieChoiceURL || widget.movie!.choice.validate() == videoChoiceURL))
                            MovieURLWidget(widget.movie!.url_link.validate())
                          else if (isMobile && (widget.movie!.choice.validate() == movieChoiceEmbed || widget.movie!.choice.validate() == videoChoiceEmbed))
                            EmbedWidget(widget.movie!.embed_content.validate())
                          else if (isMobile && (widget.movie!.choice.validate() == movieChoiceFile || widget.movie!.choice.validate() == videoChoiceFile))
                            MovieFileWidget(widget.movie!.file.validate())
                          else
                            AspectRatio(
                              child: commonCacheImageWidget(widget.movie!.image.validate(), width: context.width(), fit: BoxFit.cover),
                              aspectRatio: 16 / 9,
                            )
                        else
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Stack(
                              children: [
                                commonCacheImageWidget(
                                  widget.movie!.image.validate(),
                                  width: context.width(),
                                  fit: BoxFit.cover,
                                ),
                                Container(color: Colors.black.withOpacity(0.7), width: context.width()),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if ((widget.movie!.restrict_user_status == UserRestrictionStatus || widget.movie!.restrict_user_status == '') && mIsLoggedIn)
                                      if (widget.movie!.restrictionSetting!.restrict_type == RestrictionTypeMessage ||
                                          widget.movie!.restrictionSetting!.restrict_type == RestrictionTypeTemplate ||
                                          widget.movie!.restrictionSetting!.restrict_type == " ")
                                        Column(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                openInfoBottomSheet(
                                                  context: context,
                                                  restrictSubscriptionPlan: widget.movie!.restSubPlan,
                                                  data: HtmlWidget(
                                                    '<html>${widget.movie!.restrictionSetting!.restrict_message.validate().replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&quot;', '"').replaceAll('[embed]', '<embed>').replaceAll('[/embed]', '</embed>').replaceAll('[caption]', '<caption>').replaceAll('[/caption]', '</caption>')}</html>',
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
                                    if ((widget.movie!.restrict_user_status == UserRestrictionStatus || widget.movie!.restrict_user_status == '') && !mIsLoggedIn)
                                      Column(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              openInfoBottomSheet(
                                                context: context,
                                                restrictSubscriptionPlan: widget.movie!.restSubPlan,
                                                data: HtmlWidget(
                                                  '<html>${widget.movie!.restrictionSetting!.restrict_message.validate().replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&quot;', '"').replaceAll('[embed]', '<embed>').replaceAll('[/embed]', '</embed>').replaceAll('[caption]', '<caption>').replaceAll('[/caption]', '</caption>')}</html>',
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
                          ),
                        Row(
                          children: [
                            headingText(context, parseHtmlString(widget.movie!.title.validate()), fontSize: 20).paddingOnly(left: 8, right: 8, bottom: 8).expand(),
                            widget.movie!.trailer_link != null
                                ? InkWell(
                                    onTap: () {
                                      movieTrialDialog(context, widget.movie!.trailer_link);
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
                        ),
                        widget.movie!.imdb_rating != null && widget.movie!.imdb_rating != 0.0
                            ? Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: roundDouble(value: widget.movie!.imdb_rating.toDouble() ?? 0, places: 1),
                                    itemBuilder: (context, index) => Icon(Icons.star, color: colorPrimary),
                                    itemCount: 5,
                                    itemSize: 18.0,
                                    unratedColor: Colors.white12,
                                  ).paddingLeft(8),
                                  8.width,
                                  Text('(${roundDouble(value: widget.movie!.imdb_rating.toDouble() ?? 0, places: 1)})', style: primaryTextStyle(color: Colors.white, size: 14)),
                                  8.height,
                                ],
                              ).visible(widget.movie!.postType == PostType.MOVIE).paddingBottom(8)
                            : SizedBox(),
                        itemSubTitle(context, genre, colorThird: true, fontsize: ts_medium).paddingOnly(left: 8, right: 8, bottom: 8).visible(genre.trim().isNotEmpty),
                        if (snap.hasData)
                          Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  8.width,
                                  Container(
                                    child: Text(snap.data!.data!.censor_rating.validate(), style: boldTextStyle(color: Colors.black)),
                                    padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                    decoration: BoxDecoration(color: Colors.white),
                                  ).visible(snap.data!.data!.censor_rating.validate().isNotEmpty),
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(Icons.visibility_outlined, color: Colors.black, size: 14),
                                        4.width,
                                        Text('${snap.data!.data!.views.validate()}', style: boldTextStyle(size: 12)),
                                        4.width,
                                        Text('Views', style: boldTextStyle(size: 12)),
                                      ],
                                    ),
                                    padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                    decoration: BoxDecoration(color: Colors.white),
                                  ).cornerRadiusWithClipRRect(4).visible(widget.movie!.postType == PostType.VIDEO),
                                  8.width,
                                  itemTitle(context, snap.data!.data!.run_time.validate()).visible(snap.data!.data!.run_time.validate().isNotEmpty),
                                ],
                              ),
                              8.height.visible(snap.data!.data!.run_time.validate().isNotEmpty),
                            ],
                          ),
                        MoreLessText(parseHtmlString(widget.movie!.description.validate()), colorThird: true, fontsize: 14).paddingOnly(left: 8, right: 8, bottom: 8).visible(widget.movie!.excerpt.validate().isNotEmpty),
                        MovieDetailLikeWatchListWidget(widget.movie).paddingAll(8),
                      ],
                    ).paddingAll(8),
                    if (snap.hasData && widget.movie!.postType == PostType.TV_SHOW) SeasonDataWidget(snap.data!.seasons.validate(), widget.movie),
                    snap.hasData
                        ? Column(
                            children: [
                              Column(
                                children: [
                                  Divider(),
                                  headingWidViewAll(
                                    context,
                                    "Recommended Movies",
                                    callback: () {
                                      ViewAllMovieScreen(title: "Recommended Movies").launch(context);
                                    },
                                    showViewMore: false,
                                  ).paddingOnly(left: 16, right: 16, top: 12, bottom: 16),
                                  ItemHorizontalList(snap.data!.recommended_movie, isMovie: false),
                                  headingWidViewAll(
                                    context,
                                    "Upcoming Movies",
                                    callback: () {
                                      ViewAllMovieScreen(title: "Upcoming Movies").launch(context);
                                    },
                                    showViewMore: false,
                                  ).paddingOnly(left: 16, right: 16, top: 12, bottom: 16),
                                  ItemHorizontalList(snap.data!.upcomming_movie, isMovie: false),
                                ],
                              ).visible(snap.data!.recommended_movie.validate().isNotEmpty),
                              Column(
                                children: [
                                  headingWidViewAll(
                                    context,
                                    "Upcoming Video",
                                    callback: () {
                                      ViewAllMovieScreen(title: "Upcoming Video").launch(context);
                                    },
                                    showViewMore: false,
                                  ).paddingOnly(left: 16, right: 16, top: 12, bottom: 16),
                                  ItemHorizontalList(snap.data!.upcomming_video, isMovie: false),
                                ],
                              ).visible(snap.data!.upcomming_video.validate().isNotEmpty),
                            ],
                          )
                        : Loader().visible(isSnapshotLoading(snap, checkHasData: true)),
                    8.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${buildCommentCountText(widget.movie!.no_of_comments.validate())}', style: boldTextStyle(size: 22, color: textColorPrimary)),
                        16.height,
                        mIsLoggedIn
                            ? AppTextField(
                                controller: mainCommentCont,
                                textFieldType: TextFieldType.ADDRESS,
                                maxLines: 5,
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

                                      buildComment(content: mainCommentCont.text.trim(), postId: widget.movie!.id).then((value) {
                                        mainCommentCont.clear();

                                        commentList.add(value);
                                        widget.movie!.no_of_comments = widget.movie!.no_of_comments! + 1;

                                        setState(() {});
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
                    CommentWidget(commentList: commentList, postId: widget.movie!.id, noOfComments: widget.movie!.no_of_comments),
                    8.height,
                    Observer(builder: (_) => Loader().visible(appStore.isLoading)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
