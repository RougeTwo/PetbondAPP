import 'package:flutter/material.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/utils/validator.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/core/widgets/textfield/password_textFied.dart';
import 'package:petbond_uk/models/veterinarian/breeder_search_result.dart';
import 'package:petbond_uk/modules/veterinarian/vet_add_staff.dart';
import 'package:petbond_uk/modules/veterinarian/vet_breeder_register.dart';
import 'package:petbond_uk/modules/veterinarian/vet_connected_breeder.dart';
import 'package:petbond_uk/modules/veterinarian/vet_dashboard.dart';
import 'package:petbond_uk/modules/veterinarian/vet_profile.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';
import 'package:petbond_uk/services/veterinarian/vet_services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../core/values/asset_values.dart';
import '../../core/widgets/base_widget.dart';
import '../../core/widgets/drawer_buttons.dart';
import '../../core/widgets/shared/header.dart';
import '../../services/shared/shared_services.dart';
import 'edit_vet_staff/edit_vet_staff_main.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VetSettings extends StatefulWidget {
  @override
  State<VetSettings> createState() => _VetSettingsState();
}

class _VetSettingsState extends State<VetSettings> {
  final SharedServices _appServices = SharedServices();
  final TextEditingController vetNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  TextEditingController charityNoController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newConfirmPasswordController = TextEditingController();
  bool visiblePassword = true;
  bool visibleOldPassword = true;
  bool visibleConfirmPassword = true;
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _passwordKey = GlobalKey<FormState>();
  VeterinarianServices veterinarianServices = VeterinarianServices();
  AuthServices authServices = AuthServices();
  List<SearchResultModel> vetStaffList = [];
  Future? getStaffList;

  final deleteAccountFormKey = GlobalKey<FormState>();
  TextEditingController deleteAccountOldPasswordController = TextEditingController();


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
                            const    SizedBox(
                              height: 42,
                            ),
                            Material(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Row(
                                  children: [
                                    const    Text(
                                      "Veterinarian DashBoard",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    const  Spacer(),
                                    IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon:const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 25,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            const  SizedBox(
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
              widget: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
                child: _body(sizingInformation: sizingInformation),
              ),
              sizingInformation: sizingInformation,
            ));
      },
    );
  }

  _body({required SizingInformationModel sizingInformation}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Account Settings",
          style: CustomStyles.cardTitleStyle,
        ),
        const Divider(
          thickness: 2,
          color: ColorValues.fontColor,
        ),
        const SizedBox(
          height: 20,
        ),
        _staffContainer(sizingInformation: sizingInformation)
      ],
    );
  }

  _staffContainer({required SizingInformationModel sizingInformation}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Veterinarian staff",
          style: TextStyle(
              fontFamily: "NotoSans",
              fontSize: 18,
              color: ColorValues.fontColor),
        ),
        CustomWidgets.divider(),
        StreamBuilder(
            stream: veterinarianServices.getStaffStreamListing(
                context: context, addStaffName: false),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: SizedBox());
              } else {
                vetStaffList = snapshot.data as List<SearchResultModel>;
                return ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${vetStaffList[index].first_name} - ${vetStaffList[index].last_name} - ${vetStaffList[index].email}",
                            style: const TextStyle(
                              color: ColorValues.darkerGreyColor,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              CustomWidgets.buttonWithoutFontFamily(
                                  text: "Edit",
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditVetStaffMain(
                                                  id: vetStaffList[index].id,
                                                )));
                                  },
                                  widthSizedBox:
                                      sizingInformation.screenWidth / 2.5,
                                  buttonColor: ColorValues.lightGreyColor,
                                  borderColor: ColorValues.lightGreyColor,
                                  sizingInformation: sizingInformation),
                              const Spacer(),
                              CustomWidgets.buttonWithoutFontFamily(
                                  text: "Delete",
                                  widthSizedBox:
                                      sizingInformation.screenWidth / 2.5,
                                  onPressed: () {
                                    setState(() {
                                      // connectedBreederList.removeAt(index);
                                      veterinarianServices
                                          .deleteVetStaff(
                                              vet_staff_id:
                                                  vetStaffList[index].id,
                                              context: context)
                                          .then((value) {
                                        setState(() {
                                          getStaffList = veterinarianServices
                                              .getStaffListing(
                                                  context: context,
                                                  addStaffName: false);
                                          EasyLoading.showSuccess(
                                              "Connection Deleted Successfully!");
                                        });
                                      });
                                    });
                                  },
                                  buttonColor: ColorValues.redColor,
                                  borderColor: ColorValues.redColor,
                                  sizingInformation: sizingInformation),
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                          )
                        ],
                      );
                    });
              }
            }),
        _vetRow(sizingInformation: sizingInformation),
        const SizedBox(
          height: 20,
        ),
        _passwordChangeContainer(sizingInformation: sizingInformation),
        const SizedBox(
          height: 9,
        ),
        _deleteAccountButton(sizingInformation: sizingInformation),
      ],
    );
  }

  _vetRow({required SizingInformationModel sizingInformation}) {
    return Align(
      alignment: Alignment.centerRight,
      child: CustomWidgets.buttonWithoutFontFamily(
          text: "Add Staff",
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddVetStaff(
                          comingFrom: "Settings",
                        )));
          },
          width: 10,
          widthSizedBox: sizingInformation.screenWidth / 3.5,
          buttonColor: ColorValues.loginBackground,
          borderColor: ColorValues.loginBackground,
          sizingInformation: sizingInformation),
    );
  }

  _oldPasswordTexField({required SizingInformationModel sizingInformation}) {
    return CustomPasswordTextField(
        hintText: "Current Password",
        obscureValue: visibleOldPassword,
        sizingInformation: sizingInformation,
        validator: Validator.validateOldPassword,
        textEditingController: oldPasswordController,
        eyeTap: () => setState(() => visibleOldPassword = !visibleOldPassword));
  }

  _newPasswordTexField({required SizingInformationModel sizingInformation}) {
    return CustomPasswordTextField(
      hintText: "New Password",
      obscureValue: visiblePassword,
      sizingInformation: sizingInformation,
      validator: Validator.validatePassword,
      textEditingController: newPasswordController,
      eyeTap: () => setState(() => visiblePassword = !visiblePassword),
    );
  }

  _text() {
    return const Text(
        "Minimum 8 Characters, must contain at least one uppercase letter, one number. Special character (like []/()*%#\$) are optional");
  }

  _newConfirmPasswordTexField(
      {required SizingInformationModel sizingInformation}) {
    return CustomPasswordTextField(
        hintText: "New Confirm Password",
        obscureValue: visibleConfirmPassword,
        sizingInformation: sizingInformation,
        validator: (val) {
          if (val!.isEmpty) return 'Please enter confirm new password';
          if (val != newPasswordController.text)
            return 'Your password doesn\'t match';
          return null;
        },
        textEditingController: newConfirmPasswordController,
        eyeTap: () =>
            setState(() => visibleConfirmPassword = !visibleConfirmPassword));
  }

  _passwordChangeContainer(
      {required SizingInformationModel sizingInformation}) {
    return Form(
      key: _passwordKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Change main account password",
            style: TextStyle(
                fontFamily: "NotoSans",
                fontSize: 18,
                color: ColorValues.fontColor),
          ),
          CustomWidgets.divider(),
          const SizedBox(
            height: 20,
          ),
          _oldPasswordTexField(sizingInformation: sizingInformation),
          _newPasswordTexField(sizingInformation: sizingInformation),
          // _text(),
          _newConfirmPasswordTexField(sizingInformation: sizingInformation),
          CustomWidgets.buttonWithoutFontFamily(
              text: "Change Password",
              onPressed: () {
                if (_passwordKey.currentState!.validate()) {
                  veterinarianServices.vetChangePassword(
                      oldPassword: oldPasswordController.text,
                      newPassword: newPasswordController.text,
                      confirmPassword: newPasswordController.text,
                      context: context);
                }
              },
              widthSizedBox: sizingInformation.screenWidth / 2.3,
              buttonColor: ColorValues.loginBackground,
              borderColor: ColorValues.loginBackground,
              sizingInformation: sizingInformation),
        ],
      ),
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
            buttonColor: Colors.white.withOpacity(0.25),
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
            },
            buttonColor: ColorValues.loginBackground,
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

  _deleteAccountButton({required SizingInformationModel sizingInformation}) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: CustomWidgets.buttonWithoutFontFamily(
        text: "Delete Account",
        onPressed: () {
          _showAccountDeleteDialog(context);
        },
        buttonColor: ColorValues.dullRed,
        borderColor: ColorValues.dullRed,
        sizingInformation: sizingInformation,
      ),
    );
  }

  _showAccountDeleteDialog(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )),
                    const Text(
                      'Warning!!!',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Flexible(
                      child: Text(
                        'Proceeding this action will permanently delete your account. \n\nTo continue please enter your password.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                      child: Container(
                        child: Form(
                          key: deleteAccountFormKey,
                          child: TextFormField(
                            controller: deleteAccountOldPasswordController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            style: TextStyle(fontSize: 15.0, color: ColorValues.fontColor),
                            obscureText: visibleOldPassword,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () => setState(() => visibleOldPassword = !visibleOldPassword),
                                child: visibleOldPassword
                                    ? const Icon(
                                  Icons.visibility_off,
                                  color: ColorValues.lightGreyColor,
                                )
                                    : Icon(Icons.visibility, color: ColorValues.fontColor),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: ColorValues.fontColor, width: 2.0),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide:
                                BorderSide(color: ColorValues.lightGreyColor, width: 2.0),
                              ),
                              contentPadding: EdgeInsets.all(8),
                              hintText: 'Current Password',
                              labelStyle: TextStyle(color: ColorValues.darkerGreyColor),
                              labelText: 'Current Password',
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(width: 1, color: Colors.black)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (deleteAccountOldPasswordController.text.isNotEmpty) {
                          _appServices.deleteAccount(
                              context: context,
                              password: deleteAccountOldPasswordController.text
                          );
                          return ;
                        }

                        EasyLoading.showError('Please enter your password.');
                      },
                      child: Container(
                        width: 80,
                        height: 40,
                        decoration: const BoxDecoration(
                            color: ColorValues.loginBackground,
                            borderRadius: BorderRadius.all(Radius.circular(12))),
                        child: const Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
