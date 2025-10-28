import 'dart:async';

import 'package:flutter/material.dart';
import 'package:petbond_uk/core/services/secure_storage.dart';
import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/utils/validator.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/core/widgets/custom_drop_down_widget.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/models/breeder/view_model.dart';
import 'package:petbond_uk/models/shared/city_model.dart';
import 'package:petbond_uk/modules/auth/signup/widgets/signup_widgets.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';
import 'package:petbond_uk/services/breeder/breeder_services.dart';
import 'package:petbond_uk/services/connect_account/connect_services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petbond_uk/services/shared/shared_services.dart';
import 'package:petbond_uk/core/widgets/globals.dart' as Globals;
import '../../core/widgets/base_widget.dart';
import '../../core/widgets/drawer_buttons.dart';
import '../../core/widgets/shared/header.dart';
import '../../core/widgets/textfield/password_textFied.dart';
import 'advertise_pet/advertise_pet_step_two_create.dart';
import 'breeder-profile_setting.dart';
import 'breeder_dashboard.dart';
import 'breeder_listed_pets.dart';
import 'breeder_my_sale.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'chat/breeder_message_list.dart';

class BreederAccountSetting extends StatefulWidget {
  const BreederAccountSetting({Key? key}) : super(key: key);

  @override
  State<BreederAccountSetting> createState() => _BreederAccountSettingState();
}

class _BreederAccountSettingState extends State<BreederAccountSetting> {
  bool checkboxValue = false;

  XFile? _image;

  final _imagePicker = ImagePicker();
  AuthServices authServices = AuthServices();
  final SharedServices _appServices = SharedServices();
  final BreederServices breederServices = BreederServices();
  ConnectServices connectServices = ConnectServices();
  List<CityModel> citiesList = [];

  String _selectedCity = "Select county";
  final Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? _googleMapController;
  LatLng currentPosition = const LatLng(42.448680, -83.459900);
  bool isChecked = false;

  final _formKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();

  TextEditingController country = TextEditingController();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController searchMapController = TextEditingController();

  TextEditingController mobileController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  TextEditingController postCodeController = TextEditingController();

  TextEditingController rNoController = TextEditingController();

  TextEditingController fbUrlController = TextEditingController();

  TextEditingController instaUrlController = TextEditingController();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  bool visiblePassword = true;
  bool visibleOldPassword = true;
  bool visibleConfirmPassword = true;
  TextEditingController newConfirmPasswordController = TextEditingController();
  SecureStorage storage = SecureStorage();
  ViewModel? viewModel;
  bool viewModelLoading = false;
  String? qrImage;
  bool imageLoaded = false;

  final deleteAccountFormKey = GlobalKey<FormState>();
  TextEditingController deleteAccountOldPasswordController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readQR();
    breederServices.getViewModel(context: context).then((value) {
      if (mounted) {
        setState(() {
          viewModel = value;
          _assignValues();
          _animateMap();
          viewModelLoading = true;
        });
      }
    });
    _appServices.getCitiesList(context: context).then((value) {
      citiesList = value;
      if (viewModel?.city_id != null) {
        _selectedCity = citiesList
            .where((element) => element.id == viewModel!.city_id)
            .first
            .name;
      }
    });
  }

  _animateMap() {
    Future.delayed(const Duration(seconds: 1), () {
      if (viewModel!.lat != null && viewModel!.long != null) {
        setState(() {
          currentPosition = LatLng(
              double.parse(viewModel!.lat), double.parse(viewModel!.long));
          _googleMapController!.moveCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: currentPosition, zoom: 14)));
        });
      }
    });
  }

  readQR() async {
    qrImage = await storage.readStore('qr_code');
    if (qrImage != null) {
      setState(() {
        imageLoaded = true;
      });
    }
  }

  _assignValues() {
    if (viewModel!.first_name != null) {
      firstNameController.text = viewModel!.first_name;
    }
    if (viewModel!.last_name != null) {
      lastNameController.text = viewModel!.last_name;
    }
    if (viewModel!.phone_number != null) {
      mobileController.text = viewModel!.phone_number;
    }
    if (viewModel!.email != null) {
      emailController.text = viewModel!.email;
    }
    if (viewModel!.address != null) {
      addressController.text = viewModel!.address!;
    }
    if (viewModel!.postal_code != null) {
      postCodeController.text = viewModel!.postal_code!;
    }
    if (viewModel!.city_id != null) {
      _appServices.getCitiesList(context: context).then((value) {
        citiesList = value;
        if (viewModel!.city_id != null) {
          _selectedCity = citiesList
              .where((element) => element.id == viewModel!.city_id)
              .first
              .name;
        }
      });
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
                                      "Breeder DashBoard",
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
              showHeader: true,
              dashBoardTitle: "BREEDER",
              // drawerIcon: Builder(builder: (context) {
              //   return GestureDetector(
              //     onTap: () => Scaffold.of(context).openDrawer(),
              //     child: SvgPicture.asset(
              //       AssetValues.menuIcon,
              //       height: 30,
              //     ),
              //   );
              // }),
              widget: _body(sizingInformation: sizingInformation),
              sizingInformation: sizingInformation,
            ));
      },
    );
  }

  _body({required SizingInformationModel sizingInformation}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                "Account Setting",
                style: CustomStyles.cardTitleStyle,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            viewModelLoading
                ? _formWidget(
                    sizingInformation: sizingInformation, context: context)
                : CustomWidgets.box(sizingInformation: sizingInformation),
          ],
        ));
  }

  _formWidget(
      {required SizingInformationModel sizingInformation,
      required BuildContext context}) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _firstNameTextField(sizingInformation: sizingInformation),
          _lastNameTextField(sizingInformation: sizingInformation),
          _mobileTextField(sizingInformation: sizingInformation),
          _emailTextField(sizingInformation: sizingInformation),
          _addressTextField(sizingInformation: sizingInformation),
          _postalCodeTextField(sizingInformation: sizingInformation),
          FutureBuilder(
            future: _appServices.getCitiesList(context: context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                citiesList = snapshot.data as List<CityModel>;
                List<String> languageNames = citiesList
                    .map<String>((languageModel) => languageModel.name)
                    .toList();
                return Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
                  child: CustomDropdownWidget(
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
                  ),
                );
              }

              return Container();
            },
          ),
          _addressProof(sizingInformation: sizingInformation),
          _registerButton(
              onTap: () {
                if (_formKey.currentState!.validate() &&
                    citiesList
                            .where((element) => element.name == _selectedCity)
                            .first
                            .id !=
                        0) {
                  breederServices.breedUpdateAccountInfo(
                      context: context,
                      first_name: firstNameController.text,
                      last_name: lastNameController.text,
                      phoneNo: mobileController.text,
                      address: addressController.text,
                      postalCode: postCodeController.text,
                      cityId: citiesList
                          .where((element) => element.name == _selectedCity)
                          .first
                          .id
                          .toString(),
                      lat: currentPosition.latitude.toString(),
                      lng: currentPosition.longitude.toString(),
                      filepath: _image == null ? null : _image!.path);
                }
              },
              sizingInformation: sizingInformation),
          SizedBox(
            height: 20,
          ),
          _passwordForm(sizingInformation: sizingInformation),
          _savePasswordButton(
              onTap: () {
                if (_passwordKey.currentState!.validate()) {
                  breederServices.changePassword(
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
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Map marker location",
              style: TextStyle(
                  fontFamily: "NotoSans",
                  fontSize: 18,
                  color: ColorValues.fontColor),
            ),
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
              breederServices.updateLocation(
                  lat: currentPosition.latitude.toString(),
                  long: currentPosition.longitude.toString(),
                  context: context);
            },
            sizingInformation: sizingInformation,
          ),
          const SizedBox(
            height: 15,
          ),
          _bottomContainer(sizingInformation: sizingInformation),
        ],
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
    return SignUpWidgets.signUptextField(
        textInputType: TextInputType.text,
        hintText: "First name..",
        validator: Validator.validateFirstName,
        textController: firstNameController,
        sizingInformation: sizingInformation);
  }

  _lastNameTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.signUptextField(
        textInputType: TextInputType.text,
        hintText: "Last name..",
        validator: Validator.validateLastName,
        textController: lastNameController,
        sizingInformation: sizingInformation);
  }

  _mobileTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.signUptextField(
        textInputType: TextInputType.phone,
        hintText: "Mobile..",
        validator: Validator.validatePhoneNo,
        textController: mobileController,
        sizingInformation: sizingInformation);
  }

  _emailTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.signUptextField(
        textInputType: TextInputType.emailAddress,
        hintText: "Email..",
        filled: true,
        enabled: false,
        fillColor: ColorValues.lightGreyColor.withOpacity(0.4),
        validator: Validator.validateEmail,
        textController: emailController,
        sizingInformation: sizingInformation);
  }

  _addressTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.signUptextField(
        textInputType: TextInputType.text,
        hintText: "Address..",
        validator: Validator.validateAddress,
        textController: addressController,
        sizingInformation: sizingInformation);
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

  _postalCodeTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.signUptextField(
        textInputType: TextInputType.text,
        hintText: "Postal code..",
        validator: Validator.validatePostCode,
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
    return Text(
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

  _addressProof({required SizingInformationModel sizingInformation}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Note : File size should be less than 2MB",
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("Proof of Address",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Colors.black)),
              Tooltip(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: ColorValues.fontColor, width: 2)),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                waitDuration: Duration(seconds: 1),
                showDuration: Duration(seconds: 1),
                triggerMode: TooltipTriggerMode.tap,
                textStyle: TextStyle(color: ColorValues.fontColor),
                message:
                    "Please upload a valid prood of address.A utility bill within the last 3 month that clearly shows your name and address",
                child: Container(
                    width: 25,
                    // color: Colors.orange,
                    child: const Text(
                      "?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    //  width: 50,
                    decoration: BoxDecoration(
                      //color: Colors.orangeAccent,
                      border: Border.all(width: 2),
                      shape: BoxShape.circle,
                    )),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          _image == null
              ? viewModel!.avatar == null
                  ? SvgPicture.asset(
                      AssetValues.profileIcon,
                      width: sizingInformation.safeBlockHorizontal * 50,
                      height: sizingInformation.safeBlockHorizontal * 50,
                      fit: BoxFit.cover,
                    )
                  : viewModel?.detail?.proof_of_address != null
                      ? CustomWidgets.customNetworkImage(
                          imageUrl: BaseUrl.getImageBaseUrl() +
                              viewModel!.detail!.proof_of_address!,
                          sizingInformation: sizingInformation)
                      : Image.asset(
                          AssetValues.placeholder,
                          width: sizingInformation.safeBlockHorizontal * 50,
                          height: sizingInformation.safeBlockHorizontal * 50,
                          fit: BoxFit.contain,
                        )
              : ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: Image(
                      width: sizingInformation.safeBlockHorizontal * 50,
                      height: sizingInformation.safeBlockHorizontal * 45,
                      fit: BoxFit.cover,
                      image: FileImage(File(_image!.path))),
                ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomWidgets.iconButton(
                  text: "UPLOAD",
                  onPressed: () => _showPicker(context),
                  buttonColor: ColorValues.lighBlueButton,
                  asset: AssetValues.uploadSvg,
                  width: sizingInformation.safeBlockHorizontal * 30,
                  fontColor: ColorValues.fontColor,
                  sizingInformation: sizingInformation),
            ],
          ),
        ],
      ),
    );
  }

  _registerButton(
      {required VoidCallback onTap,
      required SizingInformationModel sizingInformation}) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: CustomWidgets.buttonWithoutFontFamily(
          text: "Submit changes of address",
          onPressed: onTap,
          buttonColor: ColorValues.loginBackground,
          borderColor: ColorValues.loginBackground,
          sizingInformation: sizingInformation),
    );
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

  _bottomContainer({required SizingInformationModel sizingInformation}) {
    return Container(
      height: sizingInformation.safeBlockHorizontal * 30,
      decoration: const BoxDecoration(
          color: ColorValues.fontColor,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Globals.GlobalData.showStripeAccountPopUp
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Connect Stripe account to receive payments",
                    style: TextStyle(color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: CustomWidgets.buttonWithoutFontFamily(
                        text: "Connect now",
                        onPressed: () {
                          connectServices.createStripeAccount(context: context);
                        },
                        buttonColor: ColorValues.loginBackground,
                        borderColor: ColorValues.loginBackground,
                        sizingInformation: sizingInformation),
                  )
                ],
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Stripe connected successfully - you can receive payments from Petbond",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> _imgFromGallery() async {
    _imagePicker
        .pickImage(
      source: ImageSource.gallery,
    )
        .then((pickedFile) {
      if (pickedFile != null) {
        setState(() {
          _image = pickedFile;
        });
      }
    });
  }

  Future<void> _imgFromCamera() async {
    _imagePicker
        .pickImage(
      source: ImageSource.camera,
    )
        .then((pickedFile) {
      if (pickedFile != null) {
        setState(() {
          _image = pickedFile;
        });
      }
    });
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
                      builder: (context) => BreederDashBoardScreen()));
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
                      builder: (context) => const AdvertisePetStepTwoCreate(
                            behaviour: 'create',
                            id: null,
                          )));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "Sell a pet"),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BreederProfileSetting()));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "Profile"),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BreederListedPets()));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "Listed pet"),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BreederMySale()));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "My Sales"),
        DrawerButton(
          sizingInformation: sizingInformation,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BreederMessageList()));
          },
          buttonColor: Colors.white.withOpacity(0.25),
          btnLable: "Advert Messages",
          showMessageCounter: true,
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
