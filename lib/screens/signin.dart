import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/network/rest_apis.dart';
import 'package:streamit_flutter/screens/UrlLauncherScreen.dart';
import 'package:streamit_flutter/screens/home_screen.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/constants.dart';
import 'package:streamit_flutter/utils/resources/colors.dart';
import 'package:streamit_flutter/utils/resources/size.dart';

class SignInScreen extends StatefulWidget {
  static String tag = '/SignInScreen';

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode passFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  bool passwordVisible = false;
  bool isLoading = false;

  Future<void> doSignIn() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      Map req = {
        "username": emailController.text,
        "password": passwordController.text,
      };

      hideKeyboard(context);
      isLoading = true;
      setState(() {});

      await token(req).then((res) async {
        isLoading = false;

        await setValue(PASSWORD, passwordController.text);
        setState(() {});
        HomeScreen().launch(context, isNewTask: true);
      }).catchError((e) {
        isLoading = false;
        FocusScope.of(context).requestFocus(passFocus);
        setState(() {});
        toast(e.toString());
        log(e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var signInButton = SizedBox(
      width: double.infinity,
      child: button(context, 'Login', onTap: () {
        doSignIn();
      }),
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            commonCacheImageWidget('assets/images/background_ek49.png', fit: BoxFit.cover, width: context.width(), height: context.height() * 0.5),
            Container(
              height: context.height() * 0.5,
              decoration: BoxDecoration(
                gradient: new LinearGradient(colors: [
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.4),
                  Theme.of(context).scaffoldBackgroundColor,
                ], stops: [
                  0.0,
                  1.0
                ], begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, tileMode: TileMode.repeated),
              ),
            ),
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Text('Login', style: boldTextStyle(size: 30, color: Colors.white)),
                    16.height,
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: primaryTextStyle(color: Colors.white),
                        suffixIcon: Icon(Icons.mail_outline, color: colorPrimary),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                      ),
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) return errorThisFieldRequired;
                        //if (!value.validateEmail()) return 'Email is invalid';
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      focusNode: emailFocus,
                      onFieldSubmitted: (s) {
                        FocusScope.of(context).requestFocus(passFocus);
                      },
                    ),
                    8.height,
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: primaryTextStyle(color: Colors.white),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        suffixIcon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off, color: colorPrimary).onTap(() {
                          passwordVisible = !passwordVisible;
                          setState(() {});
                        }),
                      ),
                      obscureText: !passwordVisible,
                      validator: (value) {
                        if (value!.isEmpty) return errorThisFieldRequired;
                        if (value.length < passwordLength) return passwordLengthMsg;
                        return null;
                      },
                      focusNode: passFocus,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (s) {
                        doSignIn();
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: text(context, 'Forgot Password', fontSize: ts_medium, textColor: Colors.grey).paddingAll(spacing_standard_new).onTap(() {
                        onForgotPasswordClicked(context);
                      }),
                    ),
                    signInButton
                  ],
                ),
              ).center(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                streamItTitle(context),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: radius()),
                  child: Text('Register', style: boldTextStyle(color: colorPrimary)),
                ).onTap(() {
                  if (getStringAsync(REGISTRATION_PAGE).isNotEmpty) {
                    UrlLauncherScreen(getStringAsync(REGISTRATION_PAGE)).launch(context);
                  } else {
                    toast(redirectionUrlNotFound);
                  }
                }),
              ],
            ).paddingOnly(top: 40, left: 16, right: 16),
            Center(child: loadingWidgetMaker().visible(isLoading)),
            BackButton(),
          ],
        ),
      ),
    );
  }

  Future<void> onForgotPasswordClicked(BuildContext context) async {
    var emailCont = TextEditingController();

    void loginClick() async {
      if (emailCont.text.trim().isEmpty) {
        toast(errorThisFieldRequired);
        return;
      }
      if (!emailCont.text.trim().validateEmail()) {
        toast('Enter valid email');
        return;
      }
      await forgotPassword({'email': emailCont.text.trim()}).then((value) {
        toast(value.message.validate());
        finish(context);
      }).catchError((e) {
        toast(e.toString());
      });
    }

    await showInDialog(
      context,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Forgot password?'),
            TextField(
              controller: emailCont,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email', labelStyle: secondaryTextStyle(color: Colors.white), contentPadding: EdgeInsets.only(top: 16)),
              autofocus: true,
              onSubmitted: (s) {
                loginClick();
              },
            ),
            30.height,
            MaterialButton(
              onPressed: () async {
                loginClick();
              },
              color: colorPrimary,
              child: Text('Submit', style: boldTextStyle(color: Colors.white)),
            ).center(),
          ],
        ),
      ),
    );
  }
}
