import 'dart:async';

import 'package:flutter/material.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/utils/validator.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/core/widgets/custom_drop_down_widget.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/models/charity/charity_view_model.dart';
import 'package:petbond_uk/models/shared/city_model.dart';
import 'package:petbond_uk/modules/auth/signup/widgets/signup_widgets.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';
import 'package:petbond_uk/services/charity/charity_services.dart';
import 'package:petbond_uk/services/shared/shared_services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/widgets/base_widget.dart';
import '../../core/widgets/drawer_buttons.dart';
import '../../core/widgets/shared/header.dart';
import '../../core/widgets/textfield/password_textFied.dart';
import 'advertise_pet/charity_advert_create.dart';
import 'charity_dashboard.dart';
import 'charity_listed_pets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'chat/charity_message_list.dart';

class CharityAccountSetting extends StatefulWidget {
  const CharityAccountSetting({Key? key}) : super(key: key);

  @override
  State<CharityAccountSetting> createState() => _CharityAccountSettingState();
}

class _CharityAccountSettingState extends State<CharityAccountSetting> {
  String text = "";
  final SharedServices _appServices = SharedServices();
  List<CityModel> citiesList = [];
  String _selectedCity = "Select county";
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? _googleMapController;
  LatLng currentPosition = const LatLng(42.448680, -83.459900);
  TextEditingController country = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController charityNameController = TextEditingController();
  TextEditingController charityNoController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newConfirmPasswordController = TextEditingController();
  TextEditingController searchMapController = TextEditingController();
  CharityServices charityServices = CharityServices();
  bool visiblePassword = true;
  bool visibleOldPassword = true;
  bool visibleConfirmPassword = true;
  AuthServices authServices = AuthServices();
  CharityViewModel? charityViewModel;

  final deleteAccountFormKey = GlobalKey<FormState>();
  TextEditingController deleteAccountOldPasswordController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    charityServices.getViewModel(context: context).then((value) {
      setState(() {
        charityViewModel = value;
        _assignValues();
        _animateMap();
      });
    });
  }

  _animateMap() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        currentPosition = LatLng(double.parse(charityViewModel!.lat),
            double.parse(charityViewModel!.long));
        _googleMapController!.moveCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: currentPosition, zoom: 14)));
      });
    });
  }

  _assignValues() {
    if (charityViewModel!.first_name != null) {
      firstNameController.text = charityViewModel!.first_name;
    }
    if (charityViewModel!.last_name != null) {
      lastNameController.text = charityViewModel!.last_name;
    }
    if (charityViewModel!.phone_number != null) {
      mobileController.text = charityViewModel!.phone_number;
    }
    if (charityViewModel!.email != null) {
      emailController.text = charityViewModel!.email;
    }
    if (charityViewModel!.address != null) {
      addressController.text = charityViewModel!.address!;
    }
    if (charityViewModel!.postal_code != null) {
      postCodeController.text = charityViewModel!.postal_code!;
    }
    if (charityViewModel!.city_id != null) {
      _appServices.getCitiesList(context: context).then((value) {
        citiesList = value;
        if (charityViewModel!.city_id != null) {
          _selectedCity = citiesList
              .where((element) => element.id == charityViewModel!.city_id)
              .first
              .name;
        }
      });
    }
    if (charityViewModel!.detail != null) {
      if (charityViewModel!.detail!.charity_name != null) {
        charityNameController.text = charityViewModel!.detail!.charity_name!;
      }
      if (charityViewModel!.detail!.charity_number != null) {
        charityNoController.text = charityViewModel!.detail!.charity_number!;
      }
    }
  }

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
                                      "Charity DashBoard",
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
              // drawerIcon: Builder(builder: (context) {
              //   return GestureDetector(
              //     onTap: () => Scaffold.of(context).openDrawer(),
              //     child: SvgPicture.asset(
              //       AssetValues.menuIcon,
              //       height: 30,
              //     ),
              //   );
              // }),
              dashBoardTitle: "CHARITY",
              widget: _formWidget(sizingInformation: sizingInformation),
              sizingInformation: sizingInformation,
            ));
      },
    );
  }

  _formWidget({required SizingInformationModel sizingInformation}) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Change of Address",
              style: CustomStyles.textStyle,
            ),
            const SizedBox(
              height: 20,
            ),
            _firstNameTextField(sizingInformation: sizingInformation),
            const SizedBox(
              height: 20,
            ),
            _lastNameTextField(sizingInformation: sizingInformation),
            const SizedBox(
              height: 20,
            ),
            _mobileTextField(sizingInformation: sizingInformation),
            const SizedBox(
              height: 20,
            ),
            _emailTextField(sizingInformation: sizingInformation),
            const SizedBox(
              height: 20,
            ),
            _charityNoTexField(sizingInformation: sizingInformation),
            const SizedBox(
              height: 20,
            ),
            _addressTextField(sizingInformation: sizingInformation),
            const SizedBox(
              height: 20,
            ),
            _postalCodeTextField(sizingInformation: sizingInformation),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: _appServices.getCitiesList(context: context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  citiesList = snapshot.data as List<CityModel>;
                  List<String> languageNames = citiesList
                      .map<String>((languageModel) => languageModel.name)
                      .toList();
                  return CustomDropdownWidget(
                    defaultValue: "Select county",
                    selectedValue: _selectedCity,
                    itemList: languageNames,
                    onValueChanged: (newValue) {
                      setState(() {
                        _selectedCity = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == "Select county") {
                        return 'Please select county';
                      }
                      if (value == null) {
                        return 'Please select county';
                      }
                    },
                  );
                }

                return Container();
              },
            ),
            const SizedBox(
              height: 30,
            ),
            _charityNameTexField(sizingInformation: sizingInformation),
            const SizedBox(
              height: 30,
            ),
            _registerButton(
                onTap: () {
                  charityServices.updateCharityProfileInfo(
                    first_name: firstNameController.text,
                    last_name: lastNameController.text,
                    phone_number: mobileController.text,
                    context: context,
                    postal_code: postCodeController.text,
                    address: addressController.text,
                    city_id: citiesList
                        .where((element) => element.name == _selectedCity)
                        .first
                        .id
                        .toString(),
                    lat: currentPosition.latitude.toString(),
                    lng: currentPosition.longitude.toString(),
                    charity_name: charityNameController.text,
                    charity_number: charityNoController.text,
                  );
                },
                sizingInformation: sizingInformation),
            const SizedBox(
              height: 30,
            ),
            _passwordForm(sizingInformation: sizingInformation),
            _savePasswordButton(
                onTap: () {
                  if (_passwordKey.currentState!.validate()) {
                    charityServices.changePassword(
                        oldPassword: oldPasswordController.text,
                        newPassword: newPasswordController.text,
                        confirmPassword: newPasswordController.text,
                        context: context);
                  }
                },
                sizingInformation: sizingInformation),
            const SizedBox(
              height: 9,
            ),
            _deleteAccountButton(sizingInformation: sizingInformation),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Map marker location",
              style: TextStyle(
                  fontFamily: "NotoSans",
                  fontSize: 18,
                  color: ColorValues.fontColor),
            ),
            const Divider(
              thickness: 2,
              color: ColorValues.fontColor,
            ),
            const SizedBox(
              height: 20,
            ),
            _searchMapTextField(sizingInformation: sizingInformation),
            Column(
              children: [
                SizedBox(
                  height: 300,
                  child: Stack(
                    children: [
                      Material(
                          child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: currentPosition,
                          zoom: 14,
                        ),
                        onMapCreated: (GoogleMapController controller) => {
                          setState(() {
                            _googleMapController = controller;
                            _mapController.complete(controller);
                          })
                        },
                        onCameraMove: ((CameraPosition cp) async {
                          currentPosition = cp.target;
                        }),
                        gestureRecognizers:
                            <Factory<OneSequenceGestureRecognizer>>[
                          new Factory<OneSequenceGestureRecognizer>(
                            () => new EagerGestureRecognizer(),
                          ),
                        ].toSet(),
                        cameraTargetBounds: CameraTargetBounds.unbounded,
                      )),
                      const Center(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            _updateLocationButton(
              onTap: () {
                charityServices.updateLocation(
                    lat: currentPosition.latitude.toString(),
                    long: currentPosition.longitude.toString(),
                    context: context);
              },
              sizingInformation: sizingInformation,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  _updateLocationButton(
      {required VoidCallback onTap,
      required SizingInformationModel sizingInformation}) {
    return Align(
        alignment: Alignment.bottomLeft,
        child: CustomWidgets.buttonWithoutFontFamily(
            width: sizingInformation.safeBlockHorizontal * 30,
            text: "Update Marker Position",
            onPressed: onTap,
            buttonColor: ColorValues.loginBackground,
            borderColor: ColorValues.loginBackground,
            sizingInformation: sizingInformation));
  }

  _firstNameTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.text,
        hintText: "First name..",
        textColor: ColorValues.fontColor,
        // validator: Validator.validateFirstName,
        textController: firstNameController,
        sizingInformation: sizingInformation);
  }

  _lastNameTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.text,
        hintText: "Last name..",
        textColor: ColorValues.fontColor,
        // validator: Validator.validateLastName,
        textController: lastNameController,
        sizingInformation: sizingInformation);
  }

  _mobileTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.phone,
        hintText: "Mobile..",
        textColor: ColorValues.fontColor,
        // validator: Validator.validatePhoneNo,
        textController: mobileController,
        sizingInformation: sizingInformation);
  }

  _emailTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.emailAddress,
        hintText: "Email..",
        filled: true,
        enabled: false,
        textColor: ColorValues.fontColor,
        fillColor: ColorValues.lightGreyColor.withOpacity(0.4),
        validator: Validator.validateEmail,
        textController: emailController,
        sizingInformation: sizingInformation);
  }

  _addressTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.text,
        hintText: "Address..",
        textColor: ColorValues.fontColor,
        // validator: Validator.validateAddress,
        textController: addressController,
        sizingInformation: sizingInformation);
  }

  _postalCodeTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.text,
        hintText: "Postal code..",
        textColor: ColorValues.fontColor,
        // validator: Validator.validatePostCode,
        textController: postCodeController,
        onFieldSubmitted: (_) async {
          List<Location> locations =
              await locationFromAddress(postCodeController.text);
          Location location = locations.first;
          if (location != null) {
            setState(() {
              currentPosition = LatLng(location.latitude, location.longitude);
              _googleMapController!.moveCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: currentPosition, zoom: 14)
                  //17 is new zoom level
                  ));
            });
          }
        },
        sizingInformation: sizingInformation);
  }

  _charityNameTexField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.text,
        hintText: "Charity Name..",
        textColor: ColorValues.fontColor,
        validator: Validator.validatePostCode,
        textController: charityNameController,
        sizingInformation: sizingInformation);
  }

  _charityNoTexField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.text,
        hintText: "Charity No..",
        textColor: ColorValues.fontColor,
        validator: Validator.validatePostCode,
        textController: charityNoController,
        sizingInformation: sizingInformation);
  }

  _passwordForm({required SizingInformationModel sizingInformation}) {
    return Form(
      key: _passwordKey,
      child: Column(
        children: [
          _oldPasswordTexField(sizingInformation: sizingInformation),
          _newPasswordTexField(sizingInformation: sizingInformation),
          _newConfirmPasswordTexField(sizingInformation: sizingInformation),
        ],
      ),
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

  _searchMapTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.text,
        hintText: "5 Sutherland Avenue, London, UK",
        labelText: "Search map for location",
        onFieldSubmitted: (_) async {
          List<Location> locations =
              await locationFromAddress(searchMapController.text);
          Location location = locations.first;
          if (location != null) {
            setState(() {
              currentPosition = LatLng(location.latitude, location.longitude);
              _googleMapController!.moveCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: currentPosition, zoom: 14)
                  //17 is new zoom level
                  ));
            });
          }
        },
        textController: searchMapController,
        sizingInformation: sizingInformation);
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
          if (val != newPasswordController.text) {
            return 'Your password doesn\'t match';
          }
          return null;
        },
        textEditingController: newConfirmPasswordController,
        eyeTap: () =>
            setState(() => visibleConfirmPassword = !visibleConfirmPassword));
  }

  _registerButton(
      {required VoidCallback onTap,
      required SizingInformationModel sizingInformation}) {
    return Align(
        alignment: Alignment.bottomLeft,
        child: CustomWidgets.iconButton(
            width: sizingInformation.safeBlockHorizontal * 30,
            text: "Save",
            onPressed: onTap,
            buttonColor: ColorValues.loginBackground,
            asset: AssetValues.saveIcon,
            sizingInformation: sizingInformation));
  }

  _savePasswordButton(
      {required VoidCallback onTap,
      required SizingInformationModel sizingInformation}) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: CustomWidgets.buttonWithoutFontFamily(
          text: "Change Password",
          onPressed: onTap,
          buttonColor: ColorValues.loginBackground,
          borderColor: ColorValues.loginBackground,
          sizingInformation: sizingInformation),
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
                      builder: (context) => const CharityDashBoardScreen()));
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
                      builder: (context) => const CharityAdvertCreate(
                            id: null,
                          )));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "Sell a pet"),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CharityListedPets()));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "Listed pet"),
        DrawerButton(
          sizingInformation: sizingInformation,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CharityMessageList()));
          },
          buttonColor: Colors.white.withOpacity(0.25),
          btnLable: "Advert Messages",
          showMessageCounter: true,
          role: 'charity',
        ),
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
                    borderRadius:
                        BorderRadius.circular(20.0)), //this right here
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: ColorValues.fontColor),
                                obscureText: visibleOldPassword,
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () => setState(() =>
                                        visibleOldPassword =
                                            !visibleOldPassword),
                                    child: visibleOldPassword
                                        ? const Icon(
                                            Icons.visibility_off,
                                            color: ColorValues.lightGreyColor,
                                          )
                                        : Icon(Icons.visibility,
                                            color: ColorValues.fontColor),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                        color: ColorValues.fontColor,
                                        width: 2.0),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                        color: ColorValues.lightGreyColor,
                                        width: 2.0),
                                  ),
                                  contentPadding: EdgeInsets.all(8),
                                  hintText: 'Current Password',
                                  labelStyle: TextStyle(
                                      color: ColorValues.darkerGreyColor),
                                  labelText: 'Current Password',
                                  border: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.black)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (deleteAccountOldPasswordController
                                .text.isNotEmpty) {
                              _appServices.deleteAccount(
                                  context: context,
                                  password:
                                      deleteAccountOldPasswordController.text);
                              return;
                            }

                            EasyLoading.showError(
                                'Please enter your password.');
                          },
                          child: Container(
                            width: 80,
                            height: 40,
                            decoration: const BoxDecoration(
                                color: ColorValues.loginBackground,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
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
