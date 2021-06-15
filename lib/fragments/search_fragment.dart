import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/network/rest_apis.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/constants.dart';
import 'package:streamit_flutter/utils/resources/colors.dart';
import 'package:streamit_flutter/utils/resources/images.dart';
import 'package:streamit_flutter/utils/resources/size.dart';

import '../screens/movieDetailComponents/MovieGridWidget.dart';

class SearchFragment extends StatefulWidget {
  static String tag = '/SearchFragment';

  @override
  SearchFragmentState createState() => SearchFragmentState();
}

class SearchFragmentState extends State<SearchFragment> {
  List<MovieData> movies = [];
  ScrollController scrollController = ScrollController();

  TextEditingController searchController = TextEditingController();
  String searchText = "";

  int page = 1;

  bool isLoading = true;
  bool loadMore = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (loadMore) {
          page++;
          isLoading = true;

          setState(() {});

          init();
        }
      }
    });
  }

  Future<void> init() async {
    searchMovie(searchController.text, page: page).then((value) {
      isLoading = false;

      if (page == 1) movies.clear();
      loadMore = value.data!.length == postPerPage;

      movies.addAll(value.data!);

      setState(() {});
    }).catchError((e) {
      log(e);
      isLoading = false;
      hasError = true;

      toast(e.toString());
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Search', showBack: false, color: Theme.of(context).cardColor, textColor: Colors.white),
      body: Stack(
        children: [
          Container(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    color: search_edittext_color,
                    padding: EdgeInsets.only(left: spacing_standard_new, right: spacing_standard),
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: searchController,
                                textInputAction: TextInputAction.search,
                                style: TextStyle(fontFamily: font_regular, fontSize: ts_normal, color: Theme.of(context).textTheme.headline6!.color),
                                decoration: InputDecoration(
                                  hintText: 'Search movies, tv shows, videos',
                                  hintStyle: TextStyle(fontFamily: font_regular, color: Theme.of(context).textTheme.subtitle2!.color),
                                  border: InputBorder.none,
                                  filled: false,
                                ),
                                onFieldSubmitted: (s) {
                                  searchText = s;

                                  page = 1;
                                  init();
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                searchText = '';
                                searchController.clear();

                                hideKeyboard(context);

                                page = 1;
                                init();
                              },
                              icon: Icon(Icons.cancel, color: colorPrimary, size: 20),
                            ).visible(searchText.isNotEmpty),
                            IconButton(
                              onPressed: () {
                                hideKeyboard(context);

                                page = 1;
                                init();
                              },
                              icon: Image.asset(ic_search, color: colorPrimary, width: 20, height: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  headingText(context, 'Result For' + " \'" + searchText + "\'").paddingOnly(left: 16, right: 16, top: 16, bottom: 12).visible(searchText.isNotEmpty),
                  MovieGridList(movies),
                ],
              ),
            ),
          ),
          Loader().withSize(height: 40, width: 40).center().visible(isLoading),
          noDataWidget().center().visible(!isLoading && movies.isEmpty && !hasError),
        ],
      ),
    );
  }
}
