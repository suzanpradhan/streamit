import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/models/CommentModel.dart';
import 'package:streamit_flutter/utils/common.dart';
import 'package:streamit_flutter/utils/constants.dart';
import 'package:streamit_flutter/utils/resources/colors.dart';

import '../main.dart';

// ignore: must_be_immutable
class CommentWidget extends StatefulWidget {
  static String tag = '/CommentWidget';
  final List<CommentModel>? commentList;
  final int? postId;
  int? noOfComments;

  CommentWidget({this.commentList, this.postId, this.noOfComments});

  @override
  CommentWidgetState createState() => CommentWidgetState();
}

class CommentWidgetState extends State<CommentWidget> {
  TextEditingController firstInnerCommCont = TextEditingController();
  TextEditingController secondInnerCommCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.commentList!.length,
      itemBuilder: (_, index) {
        CommentModel comment = widget.commentList![index];

        return comment.parent == 0
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    child: Text(comment.author_name![0].validate(), style: boldTextStyle(color: colorPrimary, size: 20)).center(),
                  ),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(comment.author_name.validate(), style: boldTextStyle(color: Colors.white)),
                              TextIcon(
                                prefix: Icon(Icons.calendar_today_outlined, size: 14, color: textSecondaryColorGlobal),
                                edgeInsets: EdgeInsets.zero,
                                text: DateFormat('yyyy-MM-dd').format(DateTime.parse(comment.date.validate())),
                                textStyle: secondaryTextStyle(),
                              )
                            ],
                          ).expand(),
                          Container(
                            child: TextButton(
                              onPressed: () {
                                comment.isAddReply = !comment.isAddReply;
                                setState(() {});
                              },
                              child: Text('Add reply', style: primaryTextStyle(color: white, size: 14)),
                              style: ButtonStyle(side: MaterialStateProperty.all(BorderSide(color: colorPrimary))),
                            ),
                          ).visible(mIsLoggedIn),
                        ],
                      ),
                      4.height,
                      Text(parseHtmlString(comment.content!.rendered.validate()), style: primaryTextStyle(color: Colors.grey, size: 14)),
                      AppTextField(
                        controller: firstInnerCommCont,
                        textFieldType: TextFieldType.ADDRESS,
                        maxLines: 3,
                        textStyle: primaryTextStyle(color: textColorPrimary),
                        decoration: InputDecoration(
                          hintText: reply,
                          hintStyle: secondaryTextStyle(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send, size: 18),
                            color: colorPrimary,
                            onPressed: () {
                              hideKeyboard(context);

                              buildComment(content: firstInnerCommCont.text.trim(), parentId: comment.id, postId: widget.postId).then((value) {
                                firstInnerCommCont.clear();

                                widget.commentList!.add(value);
                                widget.noOfComments = widget.noOfComments! + 1;
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
                      ).visible(comment.isAddReply),
                      if (widget.commentList!.any((e) => e.parent == comment.id))
                        TextButton(
                          onPressed: () {
                            multiCommentSheet(
                              context: context,
                              id: comment.id,
                              postId: widget.postId!,
                              controller: secondInnerCommCont,
                              list: widget.commentList!,
                              parentId: widget.commentList!.firstWhere((e) => e.parent == comment.id).id,
                              onCommentSubmit: (value) {
                                widget.commentList!.add(value);
                                widget.noOfComments = widget.noOfComments! + 1;
                              },
                            );
                          },
                          child: Text('View reply', style: primaryTextStyle(color: colorPrimary)),
                        )
                    ],
                  ).expand(),
                ],
              ).paddingAll(16)
            : SizedBox();
      },
      separatorBuilder: (_, index) => Divider(color: textColorPrimary, thickness: 0.1, height: 0),
    );
  }
}
