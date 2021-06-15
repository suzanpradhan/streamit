import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/screens/movie_detail_screen.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/common.dart';

// ignore: must_be_immutable
class MovieGridList extends StatelessWidget {
  List<MovieData> list = [];

  MovieGridList(this.list);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: list.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 7 / 9),
      scrollDirection: Axis.vertical,
      controller: ScrollController(keepScrollOffset: false),
      itemBuilder: (context, index) {
        MovieData data = list[index];

        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: data)));
          },
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 2,
            margin: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(borderRadius: radius(4)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                commonCacheImageWidget(data.image.validate(), fit: BoxFit.cover),
                Positioned(
                  bottom: 4,
                  child: Text('${parseHtmlString(data.title.validate())}', style: boldTextStyle(color: Colors.white), maxLines: 2).paddingAll(8),
                ),
              ],
            ),
          ),
        ).paddingAll(6);
      },
    );
  }
}
