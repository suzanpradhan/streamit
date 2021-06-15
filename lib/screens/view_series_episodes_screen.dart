import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/screens/episode_detail_screen.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/constants.dart';
import 'package:streamit_flutter/utils/resources/size.dart';

class ViewSeriesEpisodeScreen extends StatefulWidget {
  static String tag = '/ViewSeriesEpisodeScreen';

  final String? title;
  final List<Episode>? episodes;
  final MovieData? movie;

  ViewSeriesEpisodeScreen({this.title, this.episodes, this.movie});

  @override
  ViewSeriesEpisodeScreenState createState() => ViewSeriesEpisodeScreenState();
}

class ViewSeriesEpisodeScreenState extends State<ViewSeriesEpisodeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    var episodesList = ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.episodes!.length,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: spacing_standard_new, right: spacing_standard_new, top: spacing_standard_new),
        itemBuilder: (context, index) {
          Episode episode = widget.episodes![index];

          return Container(
            margin: EdgeInsets.only(bottom: spacing_standard_new),
            child: InkWell(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: spacing_control_half,
                    margin: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(spacing_control),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        commonCacheImageWidget(episode.image.validate(), width: (width / 2) - 36, height: (width / 2) - 36 * (2.5 / 4), fit: BoxFit.cover),
                        Container(
                          decoration: boxDecoration(context, bgColor: Colors.white.withOpacity(0.8)),
                          padding: EdgeInsets.only(left: spacing_control, right: spacing_control),
                          child: text(context, "EPISODE " + (index + 1).toString(), fontSize: 10, textColor: Colors.black, fontFamily: font_bold),
                        ).paddingAll(spacing_control)
                      ],
                    ),
                  ).paddingRight(spacing_standard),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        text(context, "Episode " + (index + 1).toString(), textColor: Theme.of(context).textTheme.headline6!.color, fontSize: ts_normal),
                        itemSubTitle(context, "S1 E" + (index + 1).toString() + ", ${episode.release_date.validate()}", fontsize: ts_medium),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () {
                EpisodeDetailScreen(title: episode.title.validate(), episode: episode, episodes: widget.episodes, index: index, lastIndex: widget.episodes!.length).launch(context);
              },
              radius: spacing_control,
            ),
          );
        });
    return Scaffold(
      appBar: appBarLayout(context, widget.title),
      body: episodesList,
    );
  }
}
