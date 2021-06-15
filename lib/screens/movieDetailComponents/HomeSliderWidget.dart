import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/screens/movie_detail_screen.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/common.dart';
import 'package:streamit_flutter/utils/resources/size.dart';

class DashboardSliderWidget extends StatelessWidget {
  final List<MovieData> mSliderList;

  DashboardSliderWidget(this.mSliderList);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final Size cardSize = Size(width, width / 1.8);

    return Container(
      height: cardSize.height,
      child: PageView.builder(
        itemCount: mSliderList.length,
        itemBuilder: (context, index) {
          MovieData slider = mSliderList[index];

          return Container(
            width: MediaQuery.of(context).size.width,
            height: cardSize.height,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 0,
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  Stack(
                    children: [
                      commonCacheImageWidget(slider.attachment.validate(), width: cardSize.width, height: cardSize.height, fit: BoxFit.cover),
                      Positioned(
                        child: commonCacheImageWidget(slider.logo.validate(), height: 20, fit: BoxFit.cover).visible(slider.logo.validate().isNotEmpty),
                        left: 16,
                        top: 16,
                      )
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                        stops: [0.0, 1.0],
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        tileMode: TileMode.repeated,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(slider.run_time.validate(), style: boldTextStyle(size: 12)),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: radius(4)),
                          padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                        ).visible(slider.run_time.validate().isNotEmpty),
                        itemTitle(context, parseHtmlString(slider.title.validate()), fontSize: ts_large),
                        4.height,
                        Row(
                          children: <Widget>[
                            hdWidget(context).paddingRight(spacing_standard).visible(slider.isHD.validate()),
                            Container(
                              child: Text(slider.censor_rating.validate(), style: boldTextStyle(color: Colors.black)),
                              padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                              decoration: BoxDecoration(color: Colors.white),
                            ).visible(slider.censor_rating.validate().isNotEmpty),
                            8.width,
                            itemSubTitle(context, slider.publish_date.validate().getYear().toString()),
                          ],
                        ),
                      ],
                    ).paddingOnly(left: 16, bottom: 16, top: 50),
                  )
                ],
              ),
            ).paddingBottom(spacing_control),
          ).onTap(() async {
            MovieDetailScreen(movie: slider).launch(context);
          });
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
