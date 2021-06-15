import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/network/rest_apis.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/common.dart';
import 'package:streamit_flutter/utils/constants.dart';
import 'package:streamit_flutter/utils/resources/colors.dart';
import 'package:streamit_flutter/utils/resources/images.dart';
import 'package:streamit_flutter/utils/resources/size.dart';

import '../signin.dart';

class MovieDetailLikeWatchListWidget extends StatefulWidget {
  static String tag = '/LikeWatchlistWidget';
  final MovieData? movie;

  MovieDetailLikeWatchListWidget(this.movie);

  @override
  MovieDetailLikeWatchListWidgetState createState() => MovieDetailLikeWatchListWidgetState();
}

class MovieDetailLikeWatchListWidgetState extends State<MovieDetailLikeWatchListWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  Future<void> watchlistClick() async {
    if (!mIsLoggedIn) {
      SignInScreen().launch(context);
      return;
    }
    Map req = {
      'post_id': widget.movie!.id.validate(),
      'user_id': await getInt(USER_ID),
    };

    widget.movie!.isInWatchList = !widget.movie!.isInWatchList.validate();
    setState(() {});

    await watchlistMovie(req).then((res) {
      //widget.movie.isInWatchList = res.isAdded.validate();
      //setState(() {});
    }).catchError((e) {
      widget.movie!.isInWatchList = !widget.movie!.isInWatchList.validate();
      toast(e.toString());

      setState(() {});
    });
  }

  Future<void> likeClick() async {
    if (!mIsLoggedIn) {
      SignInScreen().launch(context);
      return;
    }

    Map req = {
      'post_id': widget.movie!.id.validate(),
    };

    widget.movie!.isLiked = !widget.movie!.isLiked.validate();

    if (widget.movie!.isLiked.validate()) {
      widget.movie!.likes = widget.movie!.likes! + 1;
    } else {
      widget.movie!.likes = widget.movie!.likes! - 1;
    }
    setState(() {});

    await likeMovie(req).then((res) {
      //widget.movie.isLiked = res.isAdded.validate();
      //setState(() {});
    }).catchError((e) {
      widget.movie!.isLiked = !widget.movie!.isLiked.validate();
      if (widget.movie!.isLiked.validate()) {
        widget.movie!.likes = widget.movie!.likes! + 1;
      } else {
        widget.movie!.likes = widget.movie!.likes! - 1;
      }
      toast(e.toString());

      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          MaterialButton(
            color: Theme.of(context).scaffoldBackgroundColor,
            splashColor: Colors.grey.withOpacity(0.2),
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(widget.movie!.isLiked.validate() ? Icons.favorite : Icons.favorite_border, color: colorPrimary),
                text(
                  context,
                  buildLikeCountText(widget.movie!.likes.validate()),
                  fontSize: ts_normal,
                  fontFamily: font_medium,
                  textColor: Theme.of(context).textTheme.headline6!.color == null ? Theme.of(context).textTheme.button!.color : Theme.of(context).textTheme.headline6!.color,
                ).paddingLeft(spacing_standard),
              ],
            ),
            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(spacing_control), side: BorderSide(width: 0.8, color: colorPrimary)),
            onPressed: () {
              likeClick();
            },
          ).expand(),
          16.width,
          Expanded(
            child: iconButton(
              context,
              widget.movie!.isInWatchList.validate() ? 'Added to List' : 'My List',
              ic_add,
              () {
                watchlistClick();
              },
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              buttonTextColor: Theme.of(context).textTheme.headline6!.color,
              iconColor: colorPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
