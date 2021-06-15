import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/screens/episode_detail_screen.dart';

class SeasonDataWidget extends StatefulWidget {
  static String tag = '/SeasonDataWidget';
  final List<Season> seasons;
  final MovieData? movie;

  SeasonDataWidget(this.seasons, this.movie);

  @override
  SeasonDataWidgetState createState() => SeasonDataWidgetState();
}

class SeasonDataWidgetState extends State<SeasonDataWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.seasons.map((e) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.name.validate(), style: boldTextStyle(color: Colors.white)).paddingLeft(16),
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: e.episode!.length,
                    padding: EdgeInsets.all(8),
                    itemBuilder: (_, index) {
                      Episode episode = e.episode![index];

                      return Container(
                        margin: EdgeInsets.only(right: 8, left: 8),
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(episode.image.validate(), width: 150, height: 100, fit: BoxFit.cover),
                            8.height,
                            Text(episode.title.validate(), style: boldTextStyle(color: Colors.white)),
                            Text(episode.run_time.validate(), style: secondaryTextStyle(color: Colors.white)),
                          ],
                        ),
                      ).onTap(() {
                        EpisodeDetailScreen(title: episode.title.validate(), episode: episode, episodes: e.episode, index: index, lastIndex: e.episode!.length).launch(context);
                        //ViewSeriesEpisodeScreen(title: e.name.validate(), episodes: e.episode, movie: widget.movie).launch(context);
                      });
                    },
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ),
    ).visible(widget.seasons.isNotEmpty);
  }
}
