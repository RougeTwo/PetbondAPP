import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/utils/validator.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/core/widgets/base_widget.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthServices _authServices = AuthServices();
  final _formKey = GlobalKey<FormState>();
  bool visiblePassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, sizingInformation) {
        return Scaffold(
            key: scaffoldKey,
            backgroundColor: ColorValues.loginBackground,
            body: Center(
                child: _bodyWidget(
                    sizingInformation: sizingInformation, context: context)));
      },
    );
  }

  _bodyWidget(
      {required SizingInformationModel sizingInformation,
      required BuildContext context}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: sizingInformation.safeBlockHorizontal * 15),
        Image.asset(
          AssetValues.logo,
          fit: BoxFit.cover,
          width: sizingInformation.safeBlockHorizontal * 80,
        ),
        SizedBox(height: sizingInformation.safeBlockHorizontal * 5),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            //  / clipBehavior: Clip.none,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  SizedBox(height: sizingInformation.safeBlockHorizontal * 4),
                  const  Text(
                    "Forgot Your Password?",
                    style: TextStyle(
                        color: ColorValues.fontColor,
                        //fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        fontFamily: 'FredokaOne'),
                  ),
                  SizedBox(height: sizingInformation.safeBlockHorizontal * 4),
                  const   Text(
                    "Enter you email address and we will send you password reset email.",
                    style: CustomStyles.textStyle,
                  ),
                  SizedBox(height: sizingInformation.safeBlockHorizontal * 4),
                  _formWidget(
                      sizingInformation: sizingInformation, context: context),
                  SizedBox(height: sizingInformation.safeBlockHorizontal * 4),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _formWidget(
      {required SizingInformationModel sizingInformation,
      required BuildContext context}) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomWidgets.loginTextField(
            sizingInformation: sizingInformation,
            textInputType: TextInputType.emailAddress,
            validator: (value) => Validator.validateEmail(value),
            hintText: 'Email',
            textController: emailController,
          ),
          CustomWidgets.button(
              sizingInformation: sizingInformation,
              text: "Reset Password",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _authServices.forgetPassword(
                    context: context,
                    email: emailController.text,
                  );
                }
              },
              borderColor: ColorValues.fontColor,
              buttonColor: ColorValues.fontColor),
        ],
      ),
    );
  }
}
