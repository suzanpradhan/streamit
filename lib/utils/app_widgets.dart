import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/screens/movie_detail_screen.dart';
import 'package:streamit_flutter/utils/resources/colors.dart';
import 'package:streamit_flutter/utils/resources/images.dart';
import 'package:streamit_flutter/utils/resources/size.dart';

import 'constants.dart';
import 'dots_indicator/dots_decorator.dart';

Widget text(context, var text,
    {var fontSize = ts_medium,
    textColor = textColorSecondary,
    String fontFamily = font_regular,
    bool isCentered = false,
    int maxLine = 1,
    double latterSpacing = 0.1,
    bool isLongText = false,
    bool isJustify = false,
    TextDecoration? aDecoration}) {
  return Text(
    text,
    textAlign: isCentered
        ? TextAlign.center
        : isJustify
            ? TextAlign.justify
            : TextAlign.start,
    maxLines: isLongText ? 20 : maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        fontFamily: fontFamily,
        decoration: aDecoration != null ? aDecoration : null,
        fontSize: double.parse(fontSize.toString()).toDouble(),
        height: 1.5,
        color: textColor == textColorSecondary
            ? Theme.of(context).textTheme.subtitle2!.color
            : textColor.toString().isNotEmpty
                ? textColor
                : null,
        letterSpacing: latterSpacing),
  );
}

Widget toolBarTitle(BuildContext context, String title) {
  return text(context, title, fontSize: ts_large, textColor: Theme.of(context).textTheme.headline6!.color, fontFamily: font_bold);
}

Widget itemTitle(BuildContext context, String titleText, {var fontfamily = font_medium, fontSize = ts_normal, int? maxLine}) {
  return text(context, titleText, fontSize: fontSize, fontFamily: fontfamily, textColor: Theme.of(context).textTheme.headline6!.color, maxLine: maxLine ?? 1);
}

Widget itemSubTitle(BuildContext context, String titleText, {var fontFamily = font_regular, var fontsize = ts_normal, var colorThird = false, isLongText = true}) {
  return text(context, titleText, fontSize: fontsize, fontFamily: fontFamily, isLongText: isLongText, textColor: colorThird ? Theme.of(context).textTheme.caption!.color : Theme.of(context).textTheme.subtitle2!.color);
}

// ignore: must_be_immutable
class MoreLessText extends StatefulWidget {
  var titleText;
  var fontFamily = font_regular;
  var fontsize = ts_normal;
  var colorThird = false;

  MoreLessText(this.titleText, {this.fontFamily = font_regular, this.fontsize = ts_normal, this.colorThird = false});

  @override
  MoreLessTextState createState() => MoreLessTextState();
}

class MoreLessTextState extends State<MoreLessText> {
  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        text(context, widget.titleText,
            fontSize: widget.fontsize, fontFamily: widget.fontFamily, isLongText: isExpanded, maxLine: 2, textColor: widget.colorThird ? Theme.of(context).textTheme.caption!.color : Theme.of(context).textTheme.subtitle2!.color),
        text(
          context,
          isExpanded ? "Read less" : "Read more",
          textColor: Theme.of(context).textTheme.headline6!.color,
          fontSize: widget.fontsize,
        ).onTap(() {
          setState(() {
            isExpanded = !isExpanded;
          });
        })
      ],
    );
  }
}

Widget headingText(BuildContext context, var titleText, {int? fontSize}) {
  return text(context, titleText, fontSize: fontSize ?? 14, fontFamily: font_bold, textColor: Colors.white);
}

Widget headingWidViewAll(BuildContext context, var titleText, {VoidCallback? callback, bool showViewMore = true}) {
  return Row(
    children: <Widget>[
      Expanded(
        child: headingText(context, titleText),
      ),
      InkWell(onTap: callback, child: itemSubTitle(context, 'View More', fontsize: 12, fontFamily: font_medium, colorThird: true).paddingAll(spacing_control_half)).visible(showViewMore)
    ],
  );
}

AppBar appBarLayout(context, text, {bool darkBackground = true}) {
  return AppBar(
    elevation: 0,
    title: toolBarTitle(context, text),
    backgroundColor: darkBackground ? Theme.of(context).cardColor : Colors.transparent,
  );
}

BoxDecoration boxDecoration(BuildContext context, {double radius = 2, Color color = Colors.transparent, Color bgColor = white, var showShadow = false}) {
  return BoxDecoration(
      //gradient: LinearGradient(colors: [bgColor, whiteColor]),
      color: bgColor == white ? Theme.of(context).cardTheme.color : bgColor,
      boxShadow: showShadow ? [BoxShadow(color: Theme.of(context).hoverColor.withOpacity(0.2), blurRadius: 5, spreadRadius: 3, offset: Offset(1, 3))] : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

Widget assetImage(String image, {String aPlaceholder = "", double? aWidth, double? aHeight, var fit = BoxFit.fill}) {
  return Image.asset(
    image,
    width: aWidth,
    height: aHeight,
    fit: fit,
  );
}

Widget networkImage(String image, {String aPlaceholder = "", double? aWidth, double? aHeight, var fit = BoxFit.fill, Alignment? alignment}) {
  return Image.network(
    image,
    width: aWidth,
    height: aHeight,
    fit: fit,
    alignment: alignment ?? Alignment.topCenter,
  );
}

Widget button(BuildContext context, buttonText, {VoidCallback? onTap, double? width}) {
  return AppButton(
    width: width ?? null,
    textColor: colorPrimary,
    color: colorPrimary,
    //splashColor: Colors.grey.withOpacity(0.2),
    padding: EdgeInsets.only(top: 12, bottom: 12),
    child: text(context, buttonText, fontSize: ts_normal, fontFamily: font_medium, textColor: Theme.of(context).textTheme.button!.color),
    shapeBorder: RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(spacing_control),
      side: BorderSide(color: colorPrimary),
    ),
    onTap: onTap,
  );
}

Widget iconButton(context, buttonText, icon, callBack, {backgroundColor, borderColor, buttonTextColor, iconColor, padding = 12.0}) {
  return MaterialButton(
    color: backgroundColor == null ? colorPrimary : backgroundColor,
    splashColor: Colors.grey.withOpacity(0.2),
    padding: EdgeInsets.only(top: padding, bottom: padding),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        iconColor == null
            ? Image.asset(
                icon,
                width: 16,
                height: 16,
                color: Colors.white,
              )
            : Image.asset(
                icon,
                width: 16,
                height: 16,
                color: iconColor,
              ),
        text(context, buttonText, fontSize: ts_normal, fontFamily: font_medium, textColor: buttonTextColor == null ? Theme.of(context).textTheme.button!.color : buttonTextColor).paddingLeft(spacing_standard),
      ],
    ),
    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(spacing_control), side: BorderSide(width: 0.8, color: borderColor == null ? colorPrimary : borderColor)),
    onPressed: callBack,
  );
}

DotsDecorator dotsDecorator(context) {
  return DotsDecorator(color: Colors.grey.withOpacity(0.5), activeColor: colorPrimary, activeSize: Size.square(8.0), size: Size.square(6.0), spacing: EdgeInsets.all(spacing_control_half));
}

Widget streamItTitle(context) {
  return Image.asset(ic_logo, height: 32);
}

Widget loadingWidgetMaker() {
  return Container(
    alignment: Alignment.center,
    child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: spacing_control,
        margin: EdgeInsets.all(4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Container(
          width: 45,
          height: 45,
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        )),
  );
}

Widget notificationIcon(context, cartCount) {
  return InkWell(
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 30,
          height: 30,
          margin: EdgeInsets.only(right: 12),
          child: Icon(
            Icons.notifications_none,
            color: Theme.of(context).iconTheme.color,
            size: 24,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.only(top: spacing_standard),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: text(context, cartCount.toString(), fontSize: 12, textColor: white),
          ).visible(cartCount != 0),
        )
      ],
    ),
    onTap: () {},
  );
}

// ignore: must_be_immutable
class AllMovieGridList extends StatelessWidget {
  List<MovieData> list = [];
  var isHorizontal = false;

  AllMovieGridList(this.list);

  @override
  Widget build(BuildContext context) {
    double height = 250.0;
    double width = context.width() / 2;

    return SingleChildScrollView(
      child: Wrap(
        children: list.map((bookDetail) {
          return Container(
            width: width,
            height: height,
            child: InkWell(
              onTap: () {
                MovieDetailScreen(title: "Action", movie: bookDetail).launch(context);
              },
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(
                    bookDetail.image.validate(),
                    fit: BoxFit.cover,
                    width: width,
                    height: height,
                  ),
                  Positioned(
                    bottom: 0,
                    child: Column(
                      children: [
                        itemTitle(context, bookDetail.title!).paddingTop(spacing_control_half),
                        //itemSubTitle(context, "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.", isLongText: false),
                      ],
                    ).paddingAll(8),
                  ),
                ],
              ),
            ).paddingOnly(left: 5, right: 5, bottom: spacing_standard_new),
          );
        }).toList(),
      ),
    );

    /*return Container(
      child: GridView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 11, right: 11, top: spacing_standard_new),
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 6 / 9),
        scrollDirection: Axis.vertical,
        controller: ScrollController(keepScrollOffset: false),
        itemBuilder: (context, index) {
          Movie bookDetail = list[index];

          return InkWell(
            onTap: () {
              MovieDetailScreen(title: "Action", movie: list[index]).launch(context);
            },
            child: Stack(
              children: <Widget>[
                Expanded(
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: spacing_control_half,
                    margin: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spacing_control)),
                    child: networkImage(bookDetail.slideImage, aWidth: double.infinity, aHeight: double.infinity, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      itemTitle(context, list[index].title).paddingTop(spacing_control_half),
                      itemSubTitle(context, "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.", isLongText: false),
                    ],
                  ),
                ),
              ],
            ),
          ).paddingOnly(left: 5, right: 5, bottom: spacing_standard_new);
        },
      ),
    );*/
  }
}

Widget subType(context, key, VoidCallback callback, icon, {bool showTrailIcon = true}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      icon != null
          ? Image.asset(
              icon,
              width: 20,
              height: 20,
              color: Theme.of(context).textTheme.headline6!.color,
            ).paddingRight(spacing_standard)
          : SizedBox(),
      Expanded(child: itemTitle(context, key)),
      Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).textTheme.caption!.color,
      ).visible(showTrailIcon)
    ],
  ).paddingOnly(left: spacing_standard_new, right: 12, top: spacing_standard_new, bottom: spacing_standard_new).onTap(callback);
}

Widget hdWidget(context) {
  return Container(
    decoration: BoxDecoration(color: colorPrimary, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(4))),
    padding: EdgeInsets.only(top: 0, bottom: 2, left: 4, right: 4),
    child: text(context, "HD", textColor: Theme.of(context).textTheme.button!.color, fontSize: 10, fontFamily: font_bold),
  );
}

Widget formField(
  context,
  hint, {
  isEnabled = true,
  isDummy = false,
  controller,
  isPasswordVisible = false,
  isPassword = false,
  keyboardType = TextInputType.text,
  FormFieldValidator<String>? validator,
  onSaved,
  textInputAction = TextInputAction.next,
  FocusNode? focusNode,
  FocusNode? nextFocus,
  IconData? suffixIcon,
  maxLine = 1,
  suffixIconSelector,
}) {
  return TextFormField(
    textCapitalization: TextCapitalization.words,
    controller: controller,
    obscureText: isPassword && isPasswordVisible,
    cursorColor: colorPrimary,
    maxLines: maxLine,
    keyboardType: keyboardType,
    validator: validator,
    onSaved: onSaved,
    textInputAction: textInputAction,
    focusNode: focusNode,
    onFieldSubmitted: (arg) {
      if (nextFocus != null) {
        FocusScope.of(context).requestFocus(nextFocus);
      }
    },
    decoration: InputDecoration(
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).textTheme.headline6!.color!)),
      labelText: hint,
      labelStyle: TextStyle(fontSize: ts_normal, color: Theme.of(context).textTheme.headline6!.color),
      suffixIcon: isPassword && isPasswordVisible ? GestureDetector(onTap: suffixIconSelector, child: Icon(suffixIcon, color: colorPrimary, size: 20)) : Icon(suffixIcon, color: colorPrimary, size: 20),
      contentPadding: EdgeInsets.only(bottom: 2.0),
    ),
    style: TextStyle(fontSize: ts_normal, color: isDummy ? Colors.transparent : Theme.of(context).textTheme.headline6!.color, fontFamily: font_regular),
    enabled: isEnabled,
  );
}

Widget noDataWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset('assets/images/no_data.png', height: 130),
      Text('No data', style: boldTextStyle(color: Colors.white)),
    ],
  );
}

class EmbedWidget extends StatefulWidget {
  final String data;

  EmbedWidget(this.data);

  @override
  _EmbedWidgetState createState() => _EmbedWidgetState();
}

class _EmbedWidgetState extends State<EmbedWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          child: HtmlWidget(
            widget.data.validate().contains('iframe') ? '<html>${widget.data}</html>' : '<html><iframe>${widget.data}</iframe></html>',
            webView: true,
          ),
        ),
      ),
    );
  }
}

Widget placeholderWidget() => Image.asset('assets/images/grey.jpg', fit: BoxFit.cover);

Widget Function(BuildContext, String) placeholderWidgetFn() => (_, s) => placeholderWidget();

Widget commonCacheImageWidget(String? url, {double? width, BoxFit? fit, double? height}) {
  if (url.validate().isEmpty) {
    return Image.asset('assets/images/grey.jpg', height: height, width: width, fit: fit);
  }
  if (url.validate().startsWith('http')) {
    if (isMobile) {
      return CachedNetworkImage(
        placeholder: placeholderWidgetFn(),
        imageUrl: '$url',
        height: height,
        width: width,
        fit: fit,
      );
    } else {
      return Image.network(url!, height: height, width: width, fit: fit);
    }
  } else {
    return Image.asset(url!, height: height, width: width, fit: fit);
  }
}
