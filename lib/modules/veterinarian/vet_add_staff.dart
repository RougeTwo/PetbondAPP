import 'package:flutter/material.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/utils/validator.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/core/widgets/drawer_buttons.dart';
import 'package:petbond_uk/modules/auth/signup/widgets/signup_widgets.dart';
import 'package:petbond_uk/modules/veterinarian/vet_breeder_register.dart';
import 'package:petbond_uk/modules/veterinarian/vet_connected_breeder.dart';
import 'package:petbond_uk/modules/veterinarian/vet_dashboard.dart';
import 'package:petbond_uk/modules/veterinarian/vet_profile.dart';
import 'package:petbond_uk/modules/veterinarian/vet_setting.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';
import 'package:petbond_uk/services/veterinarian/vet_services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/values/asset_values.dart';
import '../../core/widgets/base_widget.dart';
import '../../core/widgets/shared/header.dart';
import '../../core/widgets/textfield/password_textFied.dart';

class AddVetStaff extends StatefulWidget {
  final String comingFrom;

  const AddVetStaff({Key? key, required this.comingFrom}) : super(key: key);

  @override
  State<AddVetStaff> createState() => _AddVetStaffState();
}

class _AddVetStaffState extends State<AddVetStaff> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  AuthServices authServices = AuthServices();
  TextEditingController passwordController = TextEditingController();
  VeterinarianServices veterinarianServices = VeterinarianServices();
  bool visiblePassword = true;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, sizingInformation) {
        return Scaffold(
            drawer: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: ColorValues
                      .fontColor, //This will change the drawer background to blue.
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ClipRRect(
                    child: Drawer(
                      elevation: 10,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 42,
                            ),
                            Material(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Row(
                                  children: [
                                    const Text(
                                      "Veterinarian DashBoard",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 25,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _drawerItems(sizingInformation: sizingInformation)
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
            backgroundColor: ColorValues.backgroundColor,
            body: AuthorizedHeader(
              titleWidth: sizingInformation.safeBlockHorizontal * 68,
              // drawerIcon: Builder(builder: (context) {
              //   return GestureDetector(
              //     onTap: () => Scaffold.of(context).openDrawer(),
              //     child: SvgPicture.asset(
              //       AssetValues.menuIcon,
              //       height: 30,
              //     ),
              //   );
              // }),
              dashBoardTitle: "VETERINARIAN DASHBOARD",
              widget: _form(sizingInformation: sizingInformation),
              sizingInformation: sizingInformation,
            ));
      },
    );
  }

  _form({required SizingInformationModel sizingInformation}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Vet Team Staff",
              style: CustomStyles.cardTitleStyle,
            ),
            const Divider(
              thickness: 2,
              color: ColorValues.fontColor,
            ),
            const SizedBox(
              height: 20,
            ),
            _firstNameTextField(sizingInformation: sizingInformation),
            _lastNameTextField(sizingInformation: sizingInformation),
            _emailTextField(sizingInformation: sizingInformation),
            _passwordTexField(sizingInformation: sizingInformation),
            CustomWidgets.buttonWithoutFontFamily(
                text: "Add Staff",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    veterinarianServices.addVetStaff(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      key: _formKey,
                      context: context,
                    );
                  }
                },
                buttonColor: ColorValues.loginBackground,
                borderColor: ColorValues.loginBackground,
                sizingInformation: sizingInformation)
          ],
        ),
      ),
    );
  }

  _firstNameTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.signUptextField(
        textInputType: TextInputType.text,
        hintText: "First Name",
        validator: Validator.validateFirstName,
        textController: firstNameController,
        sizingInformation: sizingInformation);
  }

  _lastNameTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.signUptextField(
        textInputType: TextInputType.text,
        hintText: "Last Name..",
        validator: Validator.validateLastName,
        textController: lastNameController,
        sizingInformation: sizingInformation);
  }

  _emailTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.signUptextField(
        textInputType: TextInputType.emailAddress,
        hintText: "Email..",
        validator: Validator.validateEmail,
        textController: emailController,
        sizingInformation: sizingInformation);
  }

  _passwordTexField({required SizingInformationModel sizingInformation}) {
    return CustomPasswordTextField(
      hintText: "New Password",
      obscureValue: visiblePassword,
      sizingInformation: sizingInformation,
      validator: Validator.validatePassword,
      textEditingController: passwordController,
      eyeTap: () => setState(() => visiblePassword = !visiblePassword),
    );
  }

  _drawerItems({required SizingInformationModel sizingInformation}) {
    return Column(
      children: [
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VetDashBoardScreen()));
            },
            buttonColor: widget.comingFrom == "Overview"
                ? ColorValues.loginBackground
                : Colors.white.withOpacity(0.25),
            btnLable: "Overview"),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VetBreederRegistration()));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "Register Breeder"),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VetConnectedBreeders()));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "Connected Breeders"),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => VetProfile()));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "Profile"),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => VetSettings()));
            },
            buttonColor: widget.comingFrom == "Settings"
                ? ColorValues.loginBackground
                : Colors.white.withOpacity(0.25),
            btnLable: "Settings"),
        InkWell(
            onTap: () {
              authServices.logout(context: context);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 35, 10),
              child: Container(
                height: 45,
                width: sizingInformation.screenWidth,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4)),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
