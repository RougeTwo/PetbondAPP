import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/utils/helper.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/utils/validator.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/widgets/base_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petbond_uk/core/widgets/custom_drop_down_widget.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/core/widgets/shared/un_authorized_header.dart';
import 'package:petbond_uk/models/shared/city_model.dart';
import 'package:petbond_uk/modules/auth/signup/widgets/signup_widgets.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';
import 'package:petbond_uk/services/shared/shared_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

class SignUpScreen extends StatefulWidget {
  final dynamic index;

  const SignUpScreen({Key? key, required this.index}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String text = "";
  bool checkboxValue = false;
  XFile? _image;
  final _imagePicker = ImagePicker();
  final SharedServices _sharedServices = SharedServices();
  final AuthServices _authServices = AuthServices();
  List<CityModel> citiesList = [];
  String _selectedCity = "Select county";
  bool isChecked = false;
  bool visiblePassword = true;
  bool visibleConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();
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
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController rNoController = TextEditingController();
  TextEditingController vetPracticeController = TextEditingController();
  TextEditingController fbUrlController = TextEditingController();
  TextEditingController instaUrlController = TextEditingController();
  TextEditingController charityController = TextEditingController();
  TextEditingController searchMapController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _assignValue();
  }

  _assignValue() {
    if (widget.index == 1) {
      setState(() {
        text = "breeder & seller";
      });
    }
    if (widget.index == 2) {
      setState(() {
        text = "Veterinarian";
      });
    }
    if (widget.index == 3) {
      setState(() {
        text = "Charity";
      });
    }
  }

  //-----------image picker-----------------
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
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

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, sizingInformation) {
        return Scaffold(
            backgroundColor: ColorValues.backgroundColor,
            body: UnAuthorizedHeader(
              widget: _bodyWidget(sizingInformation: sizingInformation),
              sizingInformation: sizingInformation,
            ));
      },
    );
  }

  _bodyWidget({
    required SizingInformationModel sizingInformation,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.index == 1)
          SignUpWidgets.signUpTitle(txt: 'Breeder Registration'),
        if (widget.index == 2)
          SignUpWidgets.signUpTitle(txt: 'Veterinarian Registration'),
        if (widget.index == 3)
          SignUpWidgets.signUpTitle(txt: 'Charity Registration'),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Please complete the registration form below to become a Petbond approved $text.",
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: SizedBox(
            child: Text(
              "Your Personal details are kept safe and will not publicity publisded on this website or shared with 3rd parties.",
              style: TextStyle(color: Colors.black38, fontSize: 14),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: Divider(
            height: 10.0,
            color: Colors.black,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: SizedBox(
            child: Text(
              "Your details: ",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
        ),
        _formWidget(
          sizingInformation: sizingInformation,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
      ],
    );
  }

  _formWidget({required SizingInformationModel sizingInformation}) {
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
            future: _sharedServices.getCitiesList(context: context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                citiesList = snapshot.data as List<CityModel>;
                List<String> cityNames = citiesList
                    .map<String>((cityModel) => cityModel.name)
                    .toList();

                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
                  child: CustomDropdownWidget(
                    defaultValue: "Select county",
                    selectedValue: _selectedCity,
                    itemList: cityNames,
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
          // FutureBuilder(
          //   future: _sharedServices.getCitiesList(context: context),
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
          //                 hintText: "Search County",
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
          //     return Container();
          //   },
          // ),
          // if (widget.index == 1)
          //   _addressProof(sizingInformation: sizingInformation),
          if (widget.index == 3)
            _charityNumberTexField(sizingInformation: sizingInformation),
          if (widget.index == 2)
            _rcvsNUmberTextField(sizingInformation: sizingInformation),
          if (widget.index == 2)
            vetPracticeName(sizingInformation: sizingInformation),
          if (widget.index == 2)
            _facebookUrlTextField(sizingInformation: sizingInformation),
          if (widget.index == 2)
            _instaUrlTextField(sizingInformation: sizingInformation),
          _passwordTexField(sizingInformation: sizingInformation),
          _confirmPasswordTexField(sizingInformation: sizingInformation),
          if (widget.index == 1 || widget.index == 3)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  _searchMapTextField(sizingInformation: sizingInformation),
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
            ),
          const SizedBox(
            height: 10,
          ),
          // _checkBox(),
          FormField<bool>(
            builder: (state) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              checkboxValue = !checkboxValue;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              border: Border.all(
                                  width: 2, color: ColorValues.lightGreyColor),
                            ),
                            child: checkboxValue
                                ? const Card(
                                    color: ColorValues.fontColor,
                                    child: SizedBox(
                                      height: 16,
                                      width: 16,
                                    ),
                                  )
                                : const SizedBox(
                                    height: 24,
                                    width: 24,
                                  ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Flexible(
                            child: Text(
                                'I ACCEPT” Terms and Conditions of the Petbond platform.')),
                      ],
                    ),
                  ),
                  Text(
                    state.errorText ?? '',
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                  )
                ],
              );
            },
            validator: (value) {
              if (!checkboxValue) {
                return 'You need to accept terms & conditions';
              } else {
                return null;
              }
            },
          ),
          _registerButton(onTap: () {
            if (_formKey.currentState!.validate() &&
                citiesList
                        .where((element) => element.name == _selectedCity)
                        .first
                        .id !=
                    0) {
              if (widget.index == 1) {
                _authServices.breederSignup(
                    context: context,
                    first_name: firstNameController.text,
                    last_name: lastNameController.text,
                    email: emailController.text,
                    phoneNo: mobileController.text,
                    address: addressController.text,
                    postalCode: postCodeController.text,
                    cityId: citiesList
                        .where((element) => element.name == _selectedCity)
                        .first
                        .id
                        .toString(),
                    password: passwordController.text,
                    confirmPassword: confirmPasswordController.text,
                    lat: currentPosition.latitude.toString(),
                    long: currentPosition.longitude.toString());
              } else if (widget.index == 2) {
                _authServices.vetSignUp(
                    first_name: firstNameController.text,
                    last_name: lastNameController.text,
                    email: emailController.text,
                    phoneNo: mobileController.text,
                    address: addressController.text,
                    postalCode: postCodeController.text,
                    practice_name: vetPracticeController.text,
                    cityId: citiesList
                        .where((element) => element.name == _selectedCity)
                        .first
                        .id
                        .toString(),
                    rNumber: rNoController.text,
                    password: passwordController.text,
                    confirmPassword: confirmPasswordController.text,
                    fbUrl: fbUrlController.text,
                    instaUrl: instaUrlController.text,
                    lat: currentPosition.latitude.toString(),
                    long: currentPosition.longitude.toString(),
                    context: context);
              } else if (widget.index == 3) {
                _authServices.charitySignUp(
                    first_name: firstNameController.text,
                    last_name: lastNameController.text,
                    email: emailController.text,
                    phoneNo: mobileController.text,
                    address: addressController.text,
                    postalCode: postCodeController.text,
                    cityId: citiesList
                        .where((element) => element.name == _selectedCity)
                        .first
                        .id
                        .toString(),
                    password: passwordController.text,
                    charityNumber: charityController.text,
                    lat: currentPosition.latitude.toString(),
                    long: currentPosition.longitude.toString(),
                    confirmPassword: confirmPasswordController.text,
                    context: context);
              }
            } else {
              return Helper.showErrorAlert(context,
                  title: "Alert",
                  content: "Complete all the the fields",
                  onPressed: () {});
            }
          }),
        ],
      ),
    );
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
        validator: Validator.validateEmail,
        textController: emailController,
        sizingInformation: sizingInformation);
  }

  vetPracticeName({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.signUptextField(
        textInputType: TextInputType.text,
        hintText: "Practice Name..",
        validator: Validator.validatePracticeName,
        textController: vetPracticeController,
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
              if (_googleMapController != null) {
                _googleMapController!.moveCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: currentPosition, zoom: 14)
                    //17 is new zoom level
                    ));
              }
            });
          }
        },
        sizingInformation: sizingInformation);
  }

  _facebookUrlTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.signUptextField(
        textInputType: TextInputType.text,
        hintText: "Facebook profile url..",
        textController: fbUrlController,
        sizingInformation: sizingInformation);
  }

  _instaUrlTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.signUptextField(
        textInputType: TextInputType.text,
        hintText: "Instagram profile url..",
        textController: instaUrlController,
        sizingInformation: sizingInformation);
  }

  _rcvsNUmberTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.signUptextField(
        textInputType: TextInputType.text,
        hintText: "RCVS_number..",
        validator: Validator.validateRCVSNumber,
        textController: rNoController,
        sizingInformation: sizingInformation);
  }

  _charityNumberTexField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.signUptextField(
        textInputType: TextInputType.text,
        hintText: "Charity Number..",
        validator: Validator.validateCharityNumber,
        textController: charityController,
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

  _passwordTexField({required SizingInformationModel sizingInformation}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
      child: SizedBox(
        height: sizingInformation.safeBlockHorizontal * 18,
        child: TextFormField(
          controller: passwordController,
          obscureText: visiblePassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: Validator.validatePassword,
          style: const TextStyle(fontSize: 15.0, color: ColorValues.fontColor),
          decoration: InputDecoration(
            suffix: GestureDetector(
              onTap: () => setState(() => visiblePassword = !visiblePassword),
              child: visiblePassword
                  ? const Icon(
                      Icons.visibility_off,
                      color: ColorValues.fontColor,
                    )
                  : const Icon(Icons.visibility, color: ColorValues.fontColor),
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
            contentPadding: const EdgeInsets.all(8),
            hintText: "Password",
            labelStyle: const TextStyle(color: ColorValues.darkerGreyColor),
            labelText: "Password",
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(width: 1, color: Colors.black)),
          ),
        ),
      ),
    );
  }

  _confirmPasswordTexField(
      {required SizingInformationModel sizingInformation}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
      child: SizedBox(
        height: sizingInformation.safeBlockHorizontal * 18,
        child: TextFormField(
          controller: confirmPasswordController,
          obscureText: visibleConfirmPassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (val) {
            if (val!.isEmpty) return 'Please enter confirm password';
            if (val != passwordController.text) {
              return 'Your password doesn\'t match';
            }
            return null;
          },
          style: const TextStyle(fontSize: 15.0, color: ColorValues.fontColor),
          decoration: InputDecoration(
            suffix: GestureDetector(
              onTap: () => setState(
                  () => visibleConfirmPassword = !visibleConfirmPassword),
              child: visibleConfirmPassword
                  ? const Icon(
                      Icons.visibility_off,
                      color: ColorValues.fontColor,
                    )
                  : const Icon(Icons.visibility, color: ColorValues.fontColor),
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
            contentPadding: const EdgeInsets.all(8),
            hintText: "Confirm Password",
            labelStyle: const TextStyle(color: ColorValues.darkerGreyColor),
            labelText: "Confirm Password",
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(width: 1, color: Colors.black)),
          ),
        ),
      ),
    );
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
                message:
                    "Please upload a valid prood of address.A utility bill within the last 3 month that clearly shows your name and address",
                child: Container(
                    width: 25,
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
          Image(
              width: MediaQuery.of(context).size.width / 1,
              height: MediaQuery.of(context).size.height / 4,
              image: _image == null
                  ? const AssetImage(AssetValues.fileProofPlaceHolder)
                  : FileImage(File(_image!.path)) as ImageProvider),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          )
        ],
      ),
    );
  }

  _registerButton({required VoidCallback onTap}) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ButtonTheme(
              buttonColor: ColorValues.loginBackground,
              minWidth: 100,
              child: MaterialButton(
                color: ColorValues.loginBackground,
                onPressed: onTap,
                child: const Text('Submit',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'FredokaOne')),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: ColorValues.loginBackground,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(8)),
              ))),
    );
  }
}
