import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/network/rest_apis.dart';
import 'package:streamit_flutter/utils/app_widgets.dart';
import 'package:streamit_flutter/utils/constants.dart';
import 'package:streamit_flutter/utils/resources/colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  static String tag = '/ChangePasswordScreen';

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController oldPassCont = TextEditingController();
  TextEditingController newPassCont = TextEditingController();
  TextEditingController confNewPassCont = TextEditingController();

  FocusNode newPassFocus = FocusNode();
  FocusNode confPassFocus = FocusNode();

  bool oldPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confPasswordVisible = false;

  bool mIsLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  submit() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      Map req = {
        'old_password': oldPassCont.text,
        'new_password': newPassCont.text,
      };

      mIsLoading = true;
      setState(() {});

      await changePassword(req).then((value) {
        mIsLoading = false;
        setState(() {});

        toast(value.message.validate());

        finish(context);
      }).catchError((e) {
        mIsLoading = false;
        setState(() {});

        toast(e.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Change Password', elevation: 0, color: Theme.of(context).cardColor, textColor: Colors.white, textSize: 22),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Stack(
          children: [
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  TextFormField(
                    controller: oldPassCont,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: primaryTextStyle(color: Colors.white),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      suffixIcon: Icon(oldPasswordVisible ? Icons.visibility : Icons.visibility_off, color: colorPrimary).onTap(() {
                        oldPasswordVisible = !oldPasswordVisible;
                        setState(() {});
                      }),
                    ),
                    obscureText: oldPasswordVisible,
                    validator: (value) {
                      if (value!.isEmpty) return errorThisFieldRequired;
                      if (value.length < passwordLength) return passwordLengthMsg;
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (s) {
                      FocusScope.of(context).requestFocus(newPassFocus);
                    },
                  ),
                  16.height,
                  TextFormField(
                    controller: newPassCont,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      labelStyle: primaryTextStyle(color: Colors.white),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      suffixIcon: Icon(newPasswordVisible ? Icons.visibility : Icons.visibility_off, color: colorPrimary).onTap(() {
                        newPasswordVisible = !newPasswordVisible;
                        setState(() {});
                      }),
                    ),
                    obscureText: newPasswordVisible,
                    validator: (value) {
                      if (value!.isEmpty) return errorThisFieldRequired;
                      if (value.length < passwordLength) return passwordLengthMsg;
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    focusNode: newPassFocus,
                    onFieldSubmitted: (s) {
                      FocusScope.of(context).requestFocus(confPassFocus);
                    },
                  ),
                  16.height,
                  TextFormField(
                    controller: confNewPassCont,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      labelStyle: primaryTextStyle(color: Colors.white),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      suffixIcon: Icon(confPasswordVisible ? Icons.visibility : Icons.visibility_off, color: colorPrimary).onTap(() {
                        confPasswordVisible = !confPasswordVisible;
                        setState(() {});
                      }),
                    ),
                    obscureText: confPasswordVisible,
                    validator: (value) {
                      if (value!.isEmpty) return errorThisFieldRequired;
                      if (value.length < passwordLength) return passwordLengthMsg;
                      if (value.trim() != newPassCont.text.trim()) return 'Both password should be matched';
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    focusNode: confPassFocus,
                    onFieldSubmitted: (s) {
                      submit();
                    },
                  ),
                  20.height,
                  button(context, 'Submit', width: context.width(), onTap: () {
                    submit();
                  })
                ],
              ),
            ),
            Loader().withSize(height: 40, width: 40).center().visible(mIsLoading),
          ],
        ),
      ),
    );
  }
}
