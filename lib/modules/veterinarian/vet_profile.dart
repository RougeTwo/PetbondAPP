import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide DrawerButton;
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/utils/validator.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/core/widgets/custom_drop_down_widget.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/models/shared/city_model.dart';
import 'package:petbond_uk/models/veterinarian/vet_view_model.dart';
import 'package:petbond_uk/modules/auth/signup/widgets/signup_widgets.dart';
import 'package:petbond_uk/modules/veterinarian/vet_breeder_register.dart';
import 'package:petbond_uk/modules/veterinarian/vet_connected_breeder.dart';
import 'package:petbond_uk/modules/veterinarian/vet_dashboard.dart';
import 'package:petbond_uk/modules/veterinarian/vet_setting.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';
import 'package:petbond_uk/services/shared/shared_services.dart';
import 'package:petbond_uk/services/veterinarian/vet_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../../core/widgets/base_widget.dart';
import '../../core/widgets/drawer_buttons.dart' as custom;
import '../../core/widgets/shared/header.dart';

class VetProfile extends StatefulWidget {
  const VetProfile({Key? key}) : super(key: key);

  @override
  State<VetProfile> createState() => _VetProfileState();
}

class _VetProfileState extends State<VetProfile> {
  String text = "";
  bool checkboxValue = false;
  final SharedServices _appServices = SharedServices();
  List<CityModel> citiesList = [];
  String _selectedCity = "Select county";
  ScrollController controller = ScrollController();
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();
  final Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? _googleMapController;
  LatLng currentPosition = const LatLng(53.19159068845241, -8.119742820906124);
  TextEditingController country = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController vetPracticeNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController rNoController = TextEditingController();
  TextEditingController fbUrlController = TextEditingController();
  TextEditingController instaUrlController = TextEditingController();
  TextEditingController searchMapController = TextEditingController();
  TextEditingController charityController = TextEditingController();
  VeterinarianServices veterinarianServices = VeterinarianServices();
  VetViewModel? vetViewModel;
  AuthServices authServices = AuthServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    veterinarianServices.getVetViewModel(context: context).then((value) {
      setState(() {
        vetViewModel = value;
        _animateMap();
        _assignValues();
      });
    });
  }

  _animateMap() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        currentPosition = LatLng(
            double.parse(vetViewModel!.lat), double.parse(vetViewModel!.long));
        _googleMapController!.moveCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: currentPosition, zoom: 14)));
      });
    });
  }

  _assignValues() {
    firstNameController.text = vetViewModel!.first_name;
      lastNameController.text = vetViewModel!.last_name;
      mobileController.text = vetViewModel!.phone_number;
      emailController.text = vetViewModel!.email;
      addressController.text = vetViewModel!.address;
      postCodeController.text = vetViewModel!.postal_code;
      _appServices.getCitiesList(context: context).then((value) {
      citiesList = value;
      _selectedCity = citiesList
          .where((element) => element.id == vetViewModel!.city_id)
          .first
          .name;
        });
      if (vetViewModel!.detail.rcvs_number != null) {
      rNoController.text = vetViewModel!.detail.rcvs_number!;
    }
    if (vetViewModel!.detail.practice_name != null) {
      vetPracticeNameController.text = vetViewModel!.detail.practice_name!;
    }
    if (vetViewModel!.detail.fb_url != null) {
      fbUrlController.text = vetViewModel!.detail.fb_url!;
    }
    if (vetViewModel!.detail.insta_url != null) {
      instaUrlController.text = vetViewModel!.detail.insta_url!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, sizingInformation) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
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
              // ignore: unnecessary_null_comparison
              widget: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
                  child: _formWidget(sizingInformation: sizingInformation)),
              sizingInformation: sizingInformation,
            ));
      },
    );
  }

  _formWidget({required SizingInformationModel sizingInformation}) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Profile Information",
            style: CustomStyles.cardTitleStyle,
          ),
          const Divider(
            thickness: 2,
            color: ColorValues.fontColor,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Veterinarian practice profile",
            style: TextStyle(
                fontFamily: "NotoSans",
                fontSize: 18,
                color: ColorValues.fontColor),
          ),
          const Divider(
            thickness: 1,
            color: ColorValues.fontColor,
          ),
          const SizedBox(
            height: 20,
          ),
          _vetPracticeNameTextField(sizingInformation: sizingInformation),
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
          // FutureBuilder(
          //   future: _appServices.getCitiesList(context: context),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       citiesList = snapshot.data as List<CityModel>;
          //       List<String> cityNames = citiesList
          //           .map<String>((cityModel) => cityModel.name)
          //           .toList();
          //       return Padding(
          //         padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
          //         child: Container(
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(8.0),
          //               border: Border.all(
          //                   color: ColorValues.lightGreyColor, width: 2)),
          //           child: DropdownSearch<String>(
          //             mode: Mode.BOTTOM_SHEET,
          //             showSearchBox: true,
          //             items: cityNames,
          //             dropdownSearchDecoration: const InputDecoration(
          //                 enabledBorder: InputBorder.none,
          //                 isCollapsed: true,
          //                 contentPadding: EdgeInsets.symmetric(
          //                     vertical: 10, horizontal: 5)),
          //             onChanged: (newValue) {
          //               setState(() {
          //                 _selectedCity = newValue!;
          //               });
          //             },
          //             selectedItem: _selectedCity,
          //           ),
          //         ),
          //       );
          //     }
          //
          //     return Container();
          //   },
          // ),
          _rcvsNUmberTextField(sizingInformation: sizingInformation),
          const SizedBox(
            height: 20,
          ),
          _facebookUrlTextField(sizingInformation: sizingInformation),
          const SizedBox(
            height: 20,
          ),
          _instaUrlTextField(sizingInformation: sizingInformation),
          const SizedBox(
            height: 20,
          ),
          _registerButton(
              sizingInformation: sizingInformation,
              onTap: () {
                veterinarianServices.updateVetProfileInfo(
                  first_name: firstNameController.text,
                  last_name: lastNameController.text,
                  phone_number: mobileController.text,
                  context: context,
                  postal_code: postCodeController.text,
                  address: addressController.text,
                  rcvs_number: rNoController.text,
                  fb_url: fbUrlController.text,
                  insta_url: instaUrlController.text,
                  practice_name: vetPracticeNameController.text,
                  lat: currentPosition.latitude.toString(),
                  lng: currentPosition.longitude.toString(),
                  city_id: citiesList
                      .where((element) => element.name == _selectedCity)
                      .first
                      .id
                      .toString(),
                );
              }),
          const SizedBox(
            height: 10,
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
                          <Factory<OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
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
              veterinarianServices.updateLocation(
                  lat: currentPosition.latitude.toString(),
                  long: currentPosition.longitude.toString(),
                  context: context);
            },
            sizingInformation: sizingInformation,
          )
        ],
      ),
    ));
  }

  _firstNameTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.text,
        hintText: "First name..",
        // validator: Validator.validateFirstName,
        textController: firstNameController,
        sizingInformation: sizingInformation);
  }

  _vetPracticeNameTextField(
      {required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.text,
        hintText: "Vet practice name..",
        // validator: Validator.validateFirstName,
        textController: vetPracticeNameController,
        sizingInformation: sizingInformation);
  }

  _lastNameTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.text,
        hintText: "Last name..",
        // validator: Validator.validateLastName,
        textController: lastNameController,
        sizingInformation: sizingInformation);
  }

  _mobileTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.phone,
        hintText: "Mobile..",
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
        fillColor: ColorValues.lightGreyColor.withValues(alpha: 0.4),
        validator: Validator.validateEmail,
        textController: emailController,
        sizingInformation: sizingInformation);
  }

  _addressTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.text,
        hintText: "Address..",
        // validator: Validator.validateAddress,
        textController: addressController,
        sizingInformation: sizingInformation);
  }

  _postalCodeTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.text,
        hintText: "Postal code..",
        // validator: Validator.validatePostCode,
        textController: postCodeController,
        onFieldSubmitted: (_) async {
          List<Location> locations =
              await locationFromAddress(postCodeController.text);
          Location location = locations.first;
          setState(() {
            currentPosition = LatLng(location.latitude, location.longitude);
            _googleMapController!.moveCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: currentPosition, zoom: 14)
                //17 is new zoom level
                ));
          });
                },
        sizingInformation: sizingInformation);
  }

  _facebookUrlTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.text,
        hintText: "Facebook profile url..",
        textController: fbUrlController,
        sizingInformation: sizingInformation);
  }

  _instaUrlTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.text,
        hintText: "Instagram profile url..",
        textController: instaUrlController,
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
          setState(() {
            currentPosition = LatLng(location.latitude, location.longitude);
            _googleMapController!.moveCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: currentPosition, zoom: 14)
                //17 is new zoom level
                ));
          });
                },
        textController: searchMapController,
        sizingInformation: sizingInformation);
  }

  _rcvsNUmberTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.text,
        hintText: "RCVS_number..",
        // validator: Validator.validateRCVSNumber,
        textController: rNoController,
        sizingInformation: sizingInformation);
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

  _drawerItems({required SizingInformationModel sizingInformation}) {
    return Column(
      children: [
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VetDashBoardScreen()));
            },
            buttonColor: Colors.white.withValues(alpha: 0.25),
            btnLable: "Overview"),
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VetBreederRegistration()));
            },
            buttonColor: Colors.white.withValues(alpha: 0.25),
            btnLable: "Register Breeder"),
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VetConnectedBreeders()));
            },
            buttonColor: Colors.white.withValues(alpha: 0.25),
            btnLable: "Connected Breeders"),
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
            },
            buttonColor: ColorValues.loginBackground,
            btnLable: "Profile"),
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const VetSettings()));
            },
            buttonColor: Colors.white.withValues(alpha: 0.25),
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
                    color: Colors.black.withValues(alpha: 0.2),
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

