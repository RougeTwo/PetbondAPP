// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/services/secure_storage.dart';
import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:petbond_uk/core/utils/helper.dart';
import 'package:petbond_uk/core/utils/validator.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/core/widgets/base_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petbond_uk/core/widgets/custom_description_widget.dart';
import 'package:petbond_uk/core/widgets/custom_drop_down_widget.dart';
import 'package:petbond_uk/core/widgets/custom_radio_button.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/core/widgets/drawer_buttons.dart' as custom;
import 'package:petbond_uk/models/veterinarian/advert_puppies_model/puppy_model.dart';
import 'package:petbond_uk/models/veterinarian/breeder_search_result.dart';
import 'package:petbond_uk/modules/auth/signup/widgets/signup_widgets.dart';
import 'package:petbond_uk/modules/veterinarian/vet_breeder_register.dart';
import 'package:petbond_uk/modules/veterinarian/vet_connected_breeder.dart';
import 'package:petbond_uk/modules/veterinarian/vet_profile.dart';
import 'package:petbond_uk/modules/veterinarian/vet_setting.dart';
import 'package:petbond_uk/core/widgets/shared/header.dart';
import 'package:petbond_uk/services/veterinarian/vet_services.dart';
import 'package:petbond_uk/core/utils/file_universal.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';
import 'package:string_validator/string_validator.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../services/auth/auth_services.dart';
import '../vet_dashboard.dart';

class EditAdvertsPuppiesListMain extends StatefulWidget {
  final int? id;
  final int? connect_breeder_id;
  final String? name;
  final PuppyModel? puppyModel;

  const EditAdvertsPuppiesListMain({
    Key? key,
    this.id,
    this.name,
    this.puppyModel,
    this.connect_breeder_id,
  }) : super(key: key);

  @override
  _EditAdvertsPuppiesListMainState createState() =>
      _EditAdvertsPuppiesListMainState();
}

class _EditAdvertsPuppiesListMainState
    extends State<EditAdvertsPuppiesListMain> {
  final _formKey = GlobalKey<FormState>();
  SecureStorage secureStorage = SecureStorage();
  TextEditingController chipController = TextEditingController();
  TextEditingController examinationNoteController = TextEditingController();
  TextEditingController significanceController = TextEditingController();
  TextEditingController defectController = TextEditingController();
  TextEditingController examinationTwoController = TextEditingController();
  VeterinarianServices veterinarianServices = VeterinarianServices();
  List<SearchResultModel> staffList = [];
  String _selectedStaff = "Select staff name";
  SearchResultModel searchResultModelTwo = SearchResultModel();
  File? _currentImage;
  List<String> deleteCertificates = [];
  final List<File?> _images = [];
  bool checkboxValue = false;
  int _defectVale = 2;
  AuthServices authServices = AuthServices();
  final String privacyTerms =
      "I certify that today I examined the above animal. In my opinion, the animal is in good health and is free from any physical defect or infirmity other than as listed above.";
  int _significantVale = 2;
  TextStyle style =const TextStyle(color: ColorValues.greyTextColor);
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _assignValues();
  }

  _assignValues() {
    if (widget.puppyModel!.vet_pet_verification != null) {
      if (widget.puppyModel!.vet_pet_verification!.chip_number != null) {
        chipController.text =
            widget.puppyModel!.vet_pet_verification!.chip_number.toString();
      }
    }
    if (widget.puppyModel!.vet_pet_verification != null) {
      if (widget.puppyModel!.vet_pet_verification!.note != null) {
        if (widget.puppyModel!.vet_pet_verification!.note!.note != null) {
          examinationNoteController.text =
              widget.puppyModel!.vet_pet_verification!.note!.note.toString();
        }
      }
    }
    if (widget.puppyModel!.vet_pet_verification != null) {
      if (widget.puppyModel!.vet_pet_verification!.note != null) {
        if (widget.puppyModel!.vet_pet_verification!.note!.physical_defect !=
            null) {
          setState(() {
            _defectVale = 1;
          });
          defectController.text = widget
              .puppyModel!.vet_pet_verification!.note!.physical_defect
              .toString();
        }
      }
    }
    if (widget.puppyModel!.vet_pet_verification != null) {
      if (widget.puppyModel!.vet_pet_verification!.note != null) {
        if (widget.puppyModel!.vet_pet_verification!.note!.significance !=
            null) {
          setState(() {
            _significantVale = 1;
          });
          significanceController.text = widget
              .puppyModel!.vet_pet_verification!.note!.physical_defect
              .toString();
        }
      }
    }
    if (widget.puppyModel!.vet_pet_verification != null) {
      if (widget.puppyModel!.vet_pet_verification!.user_id != null) {
        veterinarianServices
            .getStaffNameListing(context: context)
            .then((value) {
          staffList = value;
          setState(() {
            searchResultModelTwo = staffList
                .where((element) =>
                    element.id ==
                    widget.puppyModel!.vet_pet_verification!.user_id)
                .first;
            _selectedStaff = searchResultModelTwo.first_name.toString() +
                " " +
                searchResultModelTwo.last_name.toString();
          });
        });
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
                            const  SizedBox(
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
                                    const   Spacer(),
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
                            const   SizedBox(
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
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name.toString(),
                        style: CustomStyles.cardTitleStyle,
                      ),
                      CustomWidgets.divider(),
                      const   SizedBox(
                        height: 15,
                      ),
                      Text(
                        widget.puppyModel!.name.toString(),
                        style:const TextStyle(
                            color: ColorValues.fontColor,
                            fontSize: 18,
                            fontFamily: "FredokaOne"),
                      ),
                      _formWidget(sizingInformation: sizingInformation)
                    ],
                  )),
              sizingInformation: sizingInformation,
            ));
      },
    );
  }

  _formWidget({required SizingInformationModel sizingInformation}) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const   SizedBox(
            height: 20,
          ),
          _imageWidget(sizingInformation: sizingInformation),
          const   SizedBox(
            height: 10,
          ),
          CustomWidgets.iconButton(
              text: "SCAN TO ADD CHIP NUMBER",
              onPressed: () {
                showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                    barrierColor: Colors.black45,
                    transitionDuration: const Duration(milliseconds: 200),
                    pageBuilder: (BuildContext buildContext,
                        Animation animation, Animation secondaryAnimation) {
                      return Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height - 50,
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: _buildQrView(context),
                        ),
                      );
                    });
              },
              fontSize: 12,
              fontColor: ColorValues.fontColor,
              buttonColor: ColorValues.lighBlueButton,
              asset: AssetValues.scanIcon,
              sizingInformation: sizingInformation),
          const    SizedBox(
            height: 10,
          ),
          _chipNumberTextField(sizingInformation: sizingInformation),
          const    Text(
            "If Microchip number ass uploaded please confirm number is correct above(adjust number if necessary)",
            style: TextStyle(color: ColorValues.darkerGreyColor, fontSize: 13),
          ),
          const  SizedBox(
            height: 20,
          ),
          CustomRadioButton(
              title: "Any physical defect or infirmity detected?",
              onYesTap: () {
                setState(() {
                  _defectVale = 1;
                });
              },
              onNoTap: () {
                setState(() {
                  _defectVale = 2;
                });
              },
              value: _defectVale),
          const   SizedBox(
            height: 20,
          ),
          _defectVale == 1
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Please state body system and actual defect",
                      style: style,
                    ),
                    const  SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: defectController,
                      minLines: 4,
                      maxLines: 10,
                      textAlignVertical: TextAlignVertical.top,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style:const TextStyle(
                          fontSize: 15.0, color: ColorValues.fontColor),
                      decoration:const InputDecoration(
                        hintText: "Please write description here...",
                        alignLabelWithHint: true,
                        hintStyle: TextStyle(height: 0),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                              color: ColorValues.fontColor, width: 2.0),
                        ),
                        // labelText: "Examination notes...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                width: 1, color: ColorValues.lightGreyColor)),
                      ),
                    ),
                    const  SizedBox(
                      height: 20,
                    ),
                  ],
                )
              :const SizedBox(),
          CustomRadioButton(
              title: "Is this clinically significant?",
              onYesTap: () {
                setState(() {
                  _significantVale = 1;
                });
              },
              onNoTap: () {
                setState(() {
                  _significantVale = 2;
                });
              },
              value: _significantVale),
          const  SizedBox(
            height: 20,
          ),
          _significantVale == 1
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "State the significance",
                      style: style,
                    ),
                    const  SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: significanceController,
                      minLines: 4,
                      maxLines: 10,
                      textAlignVertical: TextAlignVertical.top,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style:const TextStyle(
                          fontSize: 15.0, color: ColorValues.fontColor),
                      decoration:const InputDecoration(
                        hintText: "Please write description here...",

                        alignLabelWithHint: true,
                        hintStyle: TextStyle(height: 0),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                              color: ColorValues.fontColor, width: 2.0),
                        ),
                        // labelText: "Examination notes...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                width: 1, color: ColorValues.lightGreyColor)),
                      ),
                    ),
                    const  SizedBox(
                      height: 20,
                    ),
                  ],
                )
              :const SizedBox(),
          TextFormField(
            controller: examinationNoteController,
            minLines: 4,
            maxLines: 10,
            textAlignVertical: TextAlignVertical.top,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style:const TextStyle(fontSize: 15.0, color: ColorValues.fontColor),
            decoration:const InputDecoration(
              hintText: "Examination notes...",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide:
                    BorderSide(color: ColorValues.fontColor, width: 2.0),
              ),
              alignLabelWithHint: true,
              hintStyle: TextStyle(height: 0),
              labelText: "Examination notes...",
              labelStyle: TextStyle(color: ColorValues.darkerGreyColor),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide:
                      BorderSide(width: 1, color: ColorValues.lightGreyColor)),
            ),
          ),
          const    SizedBox(
            height: 10,
          ),
          FormField<bool>(
            builder: (state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 5,
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
                                ?const Card(
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
                        const   SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: DescriptionTextWidget(text: privacyTerms),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    state.errorText ?? '',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
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
          const    Divider(
            thickness: 1,
            color: ColorValues.lightGreyColor,
          ),
          const  SizedBox(
            height: 10,
          ),
          FutureBuilder(
            future: veterinarianServices.getStaffNameListing(context: context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                staffList = snapshot.data as List<SearchResultModel>;
                List<String> staffName = staffList
                    .map<String>((breedModel) =>
                        breedModel.first_name.toString() +
                        " " +
                        breedModel.last_name.toString())
                    .toList();
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
                  child: CustomDropdownWidget(
                    defaultValue: "Select staff name",
                    selectedValue: _selectedStaff,
                    itemList: staffName,
                    onValueChanged: (newValue) {
                      setState(() {
                        _selectedStaff = newValue!;
                      });
                    },
                    validator: (value) {

                    },
                  ),
                );
              }

              return Container();
            },
          ),
          const  SizedBox(
            height: 20,
          ),
          CustomWidgets.buttonWithoutFontFamily(
              text: "Save Advert",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  veterinarianServices.vetUpdatePuppiesList(
                    pet_id: widget.puppyModel!.id,
                    verification_id:
                        widget.puppyModel!.vet_pet_verification?.id,
                    chip_no: chipController.text,
                    examination_note: examinationNoteController.text,
                    significance_defect: significanceController.text,
                    physical_defect: defectController.text,
                    images: _images,
                    push_id: widget.connect_breeder_id,
                    user_id: staffList
                        .where((element) =>
                            element.first_name.toString() +
                                " " +
                                element.last_name.toString() ==
                            _selectedStaff)
                        .first
                        .id,
                    context: context,
                    deleteCertificates: deleteCertificates,
                  );
                }
              },
              width: double.infinity,
              buttonColor: ColorValues.loginBackground,
              borderColor: ColorValues.loginBackground,
              sizingInformation: sizingInformation),
        ],
      ),
    );
  }

  _chipNumberTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.text,
        textColor: ColorValues.fontColor,
        fillColor: ColorValues.darkerGreyColor,
        hintText: "Input chip number",
        validator: Validator.validateChipName,
        textController: chipController,
        sizingInformation: sizingInformation);
  }

  //---------------------Image Section---------------->>>>>>
  _imageWidget({required SizingInformationModel sizingInformation}) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        _addNewImageWidget(sizingInformation: sizingInformation),
        if (_currentImage != null)
          SizedBox(
            height: sizingInformation.safeBlockHorizontal * 5,
          ),
        if (_currentImage != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomWidgets.buttonWithoutFontFamily(
                sizingInformation: sizingInformation,
                text: 'Cancel',
                width: sizingInformation.safeBlockHorizontal * 25,
                onPressed: () => setState(() => _currentImage = null),
                buttonColor: ColorValues.redColor,
                borderColor: ColorValues.redColor,
              ),
              SizedBox(
                width: sizingInformation.safeBlockHorizontal * 5,
              ),
              CustomWidgets.buttonWithoutFontFamily(
                sizingInformation: sizingInformation,
                buttonColor: ColorValues.lightGreyColor,
                borderColor: ColorValues.lightGreyColor,
                text: 'Ok',
                width: sizingInformation.safeBlockHorizontal * 25,
                onPressed: () => setState(() {
                  _images.insert(0, _currentImage);
                  _currentImage = null;
                }),
              ),
            ],
          ),
        if (_images.isNotEmpty ||
            (widget.puppyModel!.vet_pet_verification != null))
          if ((_images.isNotEmpty ||
                  (widget.puppyModel!.vet_pet_verification!.certificate_details
                              ?.length ??
                          0) >
                      0) &&
              _currentImage == null)
            SizedBox(
              height: sizingInformation.safeBlockHorizontal * 7,
            ),
        if (_images.isNotEmpty ||
            (widget.puppyModel!.vet_pet_verification != null))
          if ((_images.isNotEmpty ||
                  (widget.puppyModel!.vet_pet_verification!.certificate_details
                              ?.length ??
                          0) >
                      0) &&
              _currentImage == null)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics:const BouncingScrollPhysics(),
              child: Row(
                children: [
                  for (File? image in _images)
                    _buildImageBox(
                        sizingInformation: sizingInformation,
                        image: image,
                        isNetworkImage: false),
                  if (widget.puppyModel!.vet_pet_verification != null)
                    for (String imageUrl in widget
                        .puppyModel!.vet_pet_verification!.certificate_details!)
                      _buildImageBox(
                          sizingInformation: sizingInformation,
                          image: imageUrl,
                          isNetworkImage: true),
                ],
              ),
            ),
        SizedBox(
          height: sizingInformation.safeBlockHorizontal * 5,
        ),
      ],
    );
  }

  Widget _addNewImageWidget(
      {required SizingInformationModel sizingInformation}) {
    return Center(
      child: GestureDetector(
        onTap: () => _currentImage != null
            ? null
            : _showBottomModalPicker(context, sizingInformation),
        child: _currentImage != null
            ? Container(
                width: sizingInformation.safeBlockHorizontal * 40,
                height: sizingInformation.safeBlockHorizontal * 60,
                padding:
                    EdgeInsets.all(sizingInformation.safeBlockHorizontal * 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    6,
                  ),
                  child: Image(
                    image: FileImage(File(_currentImage!.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(
                decoration:const BoxDecoration(
                    color: ColorValues.lighBlueButton,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const   Text("UPLOAD VACCINATION CERTIFICATE",
                          style: TextStyle(
                            color: ColorValues.fontColor,
                            fontWeight: FontWeight.normal,
                          )),
                      const  Spacer(),
                      SvgPicture.asset(
                        AssetValues.uploadSvg,
                        height: 15,
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _showBottomModalPicker(
      BuildContext context, SizingInformationModel sizingInformationModel) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext modalContext) {
          return SafeArea(
              child: Wrap(
                children: [
                  ListTile(
                    leading:const Icon(
                      Icons.photo_library,
                    ),
                    title:const Text(
                      'Gallery',
                      style: TextStyle(
                        fontFamily: "FredokaOne",
                      ),
                    ),
                    onTap: () {
                      _getFile(
                        ImageSource.gallery,
                      );
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading:const Icon(
                      Icons.photo_camera,
                    ),
                    title:const Text(
                      'Camera',
                      style: TextStyle(
                        fontFamily: "FredokaOne",
                      ),
                    ),
                    onTap: () {
                      _getFile(ImageSource.camera);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ));
        });
  }

  void _getFile(ImageSource imageSource) {
    Helper.imagePicker(imageSource: imageSource).then((file) async {
      setState(() {
        _currentImage = file;
      });
      return _currentImage;
    });
  }

  Widget _buildImageBox(
      {required SizingInformationModel sizingInformation,
      dynamic image,
      required bool isNetworkImage}) {
    return Stack(
      children: [
        Row(
          children: [
            SizedBox(
              width: sizingInformation.safeBlockHorizontal * 2.5,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                6,
              ),
              child: SizedBox(
                width: sizingInformation.safeBlockHorizontal * 25,
                height: sizingInformation.safeBlockHorizontal * 40,
                child: isNetworkImage
                    ? Image(
                        image: NetworkImage(image),
                        fit: BoxFit.cover,
                      )
                    : Image(
                        image: FileImage(image),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ],
        ),
        Positioned(
          right: sizingInformation.safeBlockHorizontal * 2,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isNetworkImage
                    ? widget
                        .puppyModel!.vet_pet_verification!.certificate_details!
                        .remove(image)
                    : _images.remove(image);
              });
              if (isNetworkImage == true) {
                String str = image.toString();

                //split string
                var arr = str.split(BaseUrl.getImageBaseUrl());
                deleteCertificates.add(arr[1]);
              }
            },
            child: Icon(
              Icons.cancel,
              color: ColorValues.redColor,
              size: sizingInformation.fontSize.twentySix,
            ),
          ),
        ),
      ],
    );
  }

  //---------------------drawer section-------------------------->>
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
            buttonColor: ColorValues.loginBackground,
            btnLable: "Connected Breeders"),
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const VetProfile()));
            },
            buttonColor: Colors.white.withValues(alpha: 0.25),
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
                child:const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10),
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

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 350)
        ? 250.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: ColorValues.loginBackground,
          borderRadius: 2,
          borderLength: 20,
          borderWidth: 8,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        result = scanData;
        bool number = isNumeric(result!.code.toString());
        bool length = isLength(result!.code.toString(), 15, 15);
        if (number == true && length == true) {
          await controller.pauseCamera();
          chipController.text = result!.code.toString();
          EasyLoading.showSuccess("Added Successfully");
          return Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
          });
        } else {
          EasyLoading.showInfo("Invalid Chip Number");
        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Permission denied',
            style: TextStyle(
                color: Colors.white,
                fontFamily: "NotoSans",
                fontWeight: FontWeight.w500,
                fontSize: 16),
          ),
          backgroundColor: ColorValues.loginBackground,
        ),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

