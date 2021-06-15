import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/network/rest_apis.dart';
import 'package:streamit_flutter/screens/home_screen.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/constants.dart';
import 'package:streamit_flutter/utils/resources/colors.dart';
import 'package:streamit_flutter/utils/resources/size.dart';

class SignUpScreen extends StatefulWidget {
  static String tag = '/SignUpScreen';

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  bool passwordVisible = false;

  bool isLoading = false;

  Future<void> doSignUp() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      Map req = {
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "user_email": emailController.text,
        "user_login": userNameController.text,
        "user_pass": passwordController.text,
      };

      isLoading = true;
      setState(() {});

      await register(req).then((value) async {
        Map req = {
          "username": emailController.text,
          "password": passwordController.text,
        };

        await token(req).then((value) async {
          await setValue(PASSWORD, passwordController.text);

          HomeScreen().launch(context);
        }).catchError((e) {
          isLoading = false;
          setState(() {});
          toast(e.toString());
        });
      }).catchError((e) {
        isLoading = false;
        setState(() {});
        toast(e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget form = Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: firstNameController,
            cursorColor: colorPrimary,
            maxLines: 1,
            keyboardType: TextInputType.text,
            validator: (value) {
              return value!.isEmpty ? errorThisFieldRequired : null;
            },
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            onFieldSubmitted: (arg) {
              FocusScope.of(context).requestFocus(lastNameFocus);
            },
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).textTheme.headline6!.color!)),
              labelText: 'First Name',
              labelStyle: TextStyle(fontSize: ts_normal, color: Theme.of(context).textTheme.headline6!.color),
              contentPadding: EdgeInsets.only(top: 8),
            ),
            style: TextStyle(fontSize: ts_normal, color: Theme.of(context).textTheme.headline6!.color, fontFamily: font_regular),
          ).paddingBottom(spacing_standard_new),
          TextFormField(
            controller: lastNameController,
            cursorColor: colorPrimary,
            maxLines: 1,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              return value!.isEmpty ? errorThisFieldRequired : null;
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (arg) {
              FocusScope.of(context).requestFocus(userNameFocus);
            },
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).textTheme.headline6!.color!)),
              labelText: 'Last Name',
              labelStyle: TextStyle(fontSize: ts_normal, color: Theme.of(context).textTheme.headline6!.color),
              contentPadding: EdgeInsets.only(top: 8),
            ),
            style: TextStyle(fontSize: ts_normal, color: Theme.of(context).textTheme.headline6!.color, fontFamily: font_regular),
          ).paddingBottom(spacing_standard_new),
          TextFormField(
            controller: userNameController,
            cursorColor: colorPrimary,
            maxLines: 1,
            focusNode: userNameFocus,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              return value!.isEmpty ? errorThisFieldRequired : null;
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (arg) {
              FocusScope.of(context).requestFocus(emailFocus);
            },
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).textTheme.headline6!.color!)),
              labelText: 'Username',
              labelStyle: TextStyle(fontSize: ts_normal, color: Theme.of(context).textTheme.headline6!.color),
              contentPadding: EdgeInsets.only(top: 8),
            ),
            style: TextStyle(fontSize: ts_normal, color: Theme.of(context).textTheme.headline6!.color, fontFamily: font_regular),
          ).paddingBottom(spacing_standard_new),
          TextFormField(
            controller: emailController,
            cursorColor: colorPrimary,
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty) return errorThisFieldRequired;
              if (!value.validateEmail()) return 'Email is invalid';
              return null;
            },
            textInputAction: TextInputAction.next,
            focusNode: emailFocus,
            onFieldSubmitted: (arg) {
              FocusScope.of(context).requestFocus(passFocus);
            },
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).textTheme.headline6!.color!)),
              labelText: 'Email',
              labelStyle: TextStyle(fontSize: ts_normal, color: Theme.of(context).textTheme.headline6!.color),
              contentPadding: EdgeInsets.only(top: 8),
            ),
            style: TextStyle(fontSize: ts_normal, color: Theme.of(context).textTheme.headline6!.color, fontFamily: font_regular),
          ).paddingBottom(spacing_standard_new),
          TextFormField(
            controller: passwordController,
            obscureText: !passwordVisible,
            cursorColor: colorPrimary,
            style: TextStyle(fontSize: ts_normal, color: Theme.of(context).textTheme.headline6!.color, fontFamily: font_regular),
            validator: (value) {
              if (value!.isEmpty) return errorThisFieldRequired;
              if (value.length < passwordLength) return passwordLengthMsg;
              return null;
            },
            focusNode: passFocus,
            onFieldSubmitted: (s) {
              FocusScope.of(context).requestFocus(confirmPasswordFocus);
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).textTheme.headline6!.color!)),
              labelText: 'Password',
              labelStyle: TextStyle(fontSize: ts_normal, color: Theme.of(context).textTheme.headline6!.color),
              suffixIcon: GestureDetector(
                onTap: () {
                  passwordVisible = !passwordVisible;
                  setState(() {});
                },
                child: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off, color: colorPrimary, size: 20),
              ),
              contentPadding: EdgeInsets.only(top: 8),
            ),
          ).paddingBottom(spacing_standard_new),
          TextFormField(
            obscureText: !passwordVisible,
            cursorColor: colorPrimary,
            style: TextStyle(fontSize: ts_normal, color: Theme.of(context).textTheme.headline6!.color, fontFamily: font_regular),
            focusNode: confirmPasswordFocus,
            validator: (value) {
              if (value!.isEmpty) return errorThisFieldRequired;
              return passwordController.text == value ? null : 'Password not match';
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (arg) {
              doSignUp();
            },
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              labelText: 'Confirm Password',
              labelStyle: TextStyle(fontSize: ts_normal, color: Theme.of(context).textTheme.headline6!.color),
              suffixIcon: GestureDetector(
                onTap: () {
                  passwordVisible = !passwordVisible;
                  setState(() {});
                },
                child: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off, color: colorPrimary, size: 20),
              ),
              contentPadding: EdgeInsets.only(top: 8),
            ),
          ),
        ],
      ),
    );

    Widget signUpButton = SizedBox(
      width: double.infinity,
      child: button(context, 'Sign Up', onTap: () {
        doSignUp();
      }),
    );

    return Scaffold(
      appBar: appBarLayout(context, "", darkBackground: false),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 70),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                text(context, "Create Account", fontSize: ts_xlarge, textColor: Theme.of(context).textTheme.headline6!.color, maxLine: 2, fontFamily: font_bold, isCentered: true)
                    .paddingOnly(top: spacing_standard_new, left: spacing_standard_new, right: spacing_standard_new),
                text(
                  context,
                  'Sign up to discover all our movies and enjoy our features',
                  fontSize: ts_normal,
                  textColor: Theme.of(context).textTheme.subtitle2!.color,
                  maxLine: 2,
                ).paddingOnly(top: spacing_control, left: spacing_standard_new, right: spacing_standard_new),
                form.paddingOnly(left: spacing_standard_new, right: spacing_standard_new, top: spacing_large, bottom: spacing_standard_new),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: signUpButton.paddingOnly(left: spacing_standard_new, right: spacing_standard_new, top: spacing_large, bottom: spacing_standard_new),
          ),
          Center(child: loadingWidgetMaker().visible(isLoading))
        ],
      ),
    );
  }
}
