import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/routes/routes.dart';
import 'package:petbond_uk/core/utils/validator.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/widgets/base_widget.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/modules/auth/forget_password.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';

import '../../core/utils/helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  sizingInformation: sizingInformation, context: context),
            ));
      },
    );
  }

  _bodyWidget(
      {required SizingInformationModel sizingInformation,
      required BuildContext context}) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: sizingInformation.safeBlockHorizontal * 18,
          ),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    SizedBox(
                      height: sizingInformation.safeBlockHorizontal * 4,
                    ),
                    const Text(
                      "Petbond Login",
                      style: TextStyle(
                          color: ColorValues.fontColor,
                          //fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          fontFamily: 'FredokaOne'),
                    ),
                    SizedBox(
                      height: sizingInformation.safeBlockHorizontal * 1,
                    ),
                    const Text(
                      "Vets, Sellers, Charities",
                      style: TextStyle(
                          color: Colors.black,
                          //fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          fontFamily: 'FredokaOne'),
                    ),
                    SizedBox(
                      height: sizingInformation.safeBlockHorizontal * 3,
                    ),
                    _formWidget(
                        sizingInformation: sizingInformation, context: context),
                    _bottomArea(sizingInformation: sizingInformation),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _bottomArea({required SizingInformationModel sizingInformation}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
              child: const Text(
                "Reset Password",
                style: TextStyle(
                  fontFamily: 'FredokaOne',
                  color: ColorValues.fontColor,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgetPasswordScreen()));
              }),
          const SizedBox(
            height: 15,
          ),
          const Divider(
            height: 10.0,
            color: Colors.black,
          ),
          const SizedBox(
            height: 15,
          ),
          const Text("Dont have an account?",
              style: TextStyle(
                  color: ColorValues.fontColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'FredokaOne')),
          CustomWidgets.button(
              sizingInformation: sizingInformation,
              text: 'Sign up to Petbond',
              onPressed: () {
                Navigator.pushNamed(context, signUpSelectionScreen);
              },
              borderColor: ColorValues.loginBackground,
              buttonColor: ColorValues.loginBackground),
          SizedBox(
            height: sizingInformation.safeBlockHorizontal * 2,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
                child: const Text(
                  "Looking to buy a pet?",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'FredokaOne',
                    color: ColorValues.fontColor,
                    // decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  Helper.launchPetbondWebApp();
                }),
          ),
        ],
      ),
    );
  }

  _formWidget(
      {required SizingInformationModel sizingInformation,
      required BuildContext context}) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomWidgets.loginTextField(
              sizingInformation: sizingInformation,
              textInputType: TextInputType.emailAddress,
              validator: (value) => Validator.validateEmail(value),
              hintText: 'Email',
              textController: emailController,
            ),
            SizedBox(
              height: sizingInformation.safeBlockHorizontal * 18,
              child: TextFormField(
                controller: passwordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: visiblePassword,
                // validator: validator,
                style: const TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'FredokaOne',
                    color: Colors.black),
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide:
                        BorderSide(color: ColorValues.fontColor, width: 2.0),
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  suffixIcon: InkWell(
                    onTap: () =>
                        setState(() => visiblePassword = !visiblePassword),
                    child: visiblePassword
                        ? const Icon(
                            Icons.visibility_off,
                            color: ColorValues.darkerGreyColor,
                          )
                        : const Icon(Icons.visibility, color: ColorValues.fontColor),
                  ),
                  hintText: "Password",
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(width: 1, color: Colors.black)),
                ),
              ),
            ),
            CustomWidgets.button(
                sizingInformation: sizingInformation,
                text: "Login",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _authServices.login(
                        redirect: false,
                        context: context,
                        email: emailController.text,
                        password: passwordController.text);
                  }
                },
                borderColor: ColorValues.fontColor,
                buttonColor: ColorValues.fontColor),
          ],
        ),
      ),
    );
  }
}
