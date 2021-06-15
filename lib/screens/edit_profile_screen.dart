import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/network/network_utils.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/constants.dart';
import 'package:streamit_flutter/utils/resources/colors.dart';
import 'package:streamit_flutter/utils/resources/images.dart';
import 'package:streamit_flutter/utils/resources/size.dart';

class EditProfileScreen extends StatefulWidget {
  static String tag = '/ProfileScreen';

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool passwordVisible = false;
  bool isRemember = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();

  bool autoValidate = false;

  PickedFile? image;

  bool isLoading = false;

  bool loadFromFile = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    firstNameController.text = await getString(NAME);
    lastNameController.text = await getString(LAST_NAME);
    emailController.text = await getString(USER_EMAIL);
  }

  Future getImage() async {
    await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 100).then((value) {
      image = value;
      setState(() {});
    }).catchError((error) {
      toast(error);
    });
  }

  Future save() async {
    isLoading = true;
    setState(() {});

    var multiPartRequest = await getMultiPartRequest('streamit-api/api/v2/streamit/update-profile');

    multiPartRequest.fields['first_name'] = firstNameController.text.trim();
    multiPartRequest.fields['last_name'] = lastNameController.text.trim();
    if (image != null) multiPartRequest.files.add(await MultipartFile.fromPath('profile_image', image!.path));

    multiPartRequest.headers.addAll(await buildTokenHeader());

    log(multiPartRequest.fields.toString());
    Response response = await Response.fromStream(await multiPartRequest.send());
    log(response.body);

    if (response.statusCode.isSuccessful()) {
      Map<String, dynamic> res = jsonDecode(response.body);

      toast(res['message'].toString());

      await setValue(NAME, res['first_name']);
      await setValue(LAST_NAME, res['last_name']);

      appStore.setFirstName(res['first_name']);
      appStore.setLastName(res['last_name']);

      if (res['streamit_profile_image'] != null) await setValue(USER_PROFILE, res['streamit_profile_image']);
      if (res['streamit_profile_image'] != null) appStore.setUserProfile(res['streamit_profile_image']);

      isLoading = false;
      setState(() {});
    } else {
      isLoading = false;
      setState(() {});

      toast(errorSomethingWentWrong);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget profilePhoto = Container(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Card(
          semanticContainer: true,
          color: colorPrimary,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: spacing_standard_new,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: image != null
              ? Image.file(File(image!.path), height: 95, width: 95, fit: BoxFit.cover)
              : appStore.userProfileImage.validate().isNotEmpty
                  ? commonCacheImageWidget(appStore.userProfileImage, height: 95, width: 95, fit: BoxFit.cover)
                  : commonCacheImageWidget(ic_profile, width: 95, height: 95, fit: BoxFit.cover),
        ).onTap(() {
          getImage();
        }),
        text(context, 'Change Avatar', textColor: Theme.of(context).textTheme.headline6!.color, fontFamily: font_bold, fontSize: ts_medium).paddingTop(spacing_standard_new)
      ],
    ).paddingOnly(top: 16))
        .center();

    Widget fields = Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          formField(
            context,
            "First Name",
            controller: firstNameController,
            nextFocus: lastNameFocusNode,
            validator: (value) {
              return value!.isEmpty ? 'Name is required' : null;
            },
            suffixIcon: Icons.person_outline,
          ).paddingBottom(spacing_standard_new),
          formField(
            context,
            "Last Name",
            controller: lastNameController,
            focusNode: lastNameFocusNode,
            nextFocus: emailFocusNode,
            validator: (value) {
              return value!.isEmpty ? 'Name is required' : null;
            },
            suffixIcon: Icons.person_outline,
          ).paddingBottom(spacing_standard_new),
          formField(
            context,
            "Email",
            controller: emailController,
            focusNode: emailFocusNode,
            suffixIcon: Icons.mail_outline,
            textInputAction: TextInputAction.done,
            isEnabled: false,
          ).paddingBottom(spacing_standard_new),
        ],
      ),
    ).paddingOnly(left: spacing_standard_new, right: spacing_standard_new, top: 36);

    return Scaffold(
      appBar: appBarLayout(context, 'Edit Profile'),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                profilePhoto,
                fields,
                SizedBox(
                  width: double.infinity,
                  child: button(
                    context,
                    'Save',
                    onTap: () {
                      if (isLoading) {
                        return;
                      }

                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        save();
                      } else {
                        setState(() => autoValidate = true);
                      }
                    },
                  ).paddingOnly(top: 30, left: 18, right: 18, bottom: 30),
                )
              ],
            ),
          ),
          loadingWidgetMaker().visible(isLoading)
        ],
      ),
    );
  }
}
