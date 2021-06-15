import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/models/response.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/resources/colors.dart';
import 'package:streamit_flutter/utils/resources/size.dart';

class FaqScreen extends StatefulWidget {
  static String tag = '/FaqScreen';

  @override
  FaqScreenState createState() => FaqScreenState();
}

class FaqScreenState extends State<FaqScreen> {
  List<FAQ> faqs = [];
  bool isLoading = false;

  showLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var faqlist = ListView.builder(
        itemCount: faqs.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(left: spacing_standard_new, right: spacing_standard_new, top: spacing_standard_new),
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Color(0xFF333333), shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(spacing_control_half))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: itemTitle(context, faqs[index].title!)),
                    Icon(
                      faqs[index].isExpanded! ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: colorPrimary,
                      size: 22,
                    )
                  ],
                ).paddingBottom(spacing_standard),
                itemSubTitle(context, faqs[index].subTitle!).visible(faqs[index].isExpanded!)
              ],
            ),
          ).onTap(() {
            setState(() {
              faqs[index].isExpanded = !faqs[index].isExpanded!;
            });
          });
        });
    return Scaffold(
      appBar: appBarLayout(context, 'FAQ'),
      body: Stack(
        children: <Widget>[faqlist, Center(child: loadingWidgetMaker().visible(isLoading))],
      ),
    );
  }
}
