import 'dart:io';
import 'package:flutter/material.dart' hide DrawerButton;
import 'package:petbond_uk/core/services/secure_storage.dart';
import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/core/widgets/custom_drop_down_widget.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/core/widgets/base_widget.dart';
import 'package:petbond_uk/core/widgets/drawer_buttons.dart' as custom;
import 'package:petbond_uk/core/widgets/shared/header.dart';
import 'package:petbond_uk/models/charity/get_edit_model/edit_model.dart';
import 'package:petbond_uk/models/shared/breed_list_model.dart';
import 'package:petbond_uk/models/shared/examinations.dart';
import 'package:petbond_uk/modules/auth/signup/widgets/signup_widgets.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';
import 'package:petbond_uk/services/charity/charity_services.dart';
import 'package:petbond_uk/services/shared/shared_services.dart';
import 'package:image_picker/image_picker.dart';
import '../charity_account_setting.dart';
import '../charity_dashboard.dart';
import '../charity_listed_pets.dart';
import '../chat/charity_message_list.dart';

class CharityAdvertCreate extends StatefulWidget {
  final int? id;

  const CharityAdvertCreate({Key? key, required this.id}) : super(key: key);

  @override
  _CharityAdvertCreateState createState() => _CharityAdvertCreateState();
}

class _CharityAdvertCreateState extends State<CharityAdvertCreate> {
  int i = 2;
  SecureStorage secureStorage = SecureStorage();
  bool showExaminationData = false;
  List<ExaminationModel> userChecked = [];
  TextStyle style = const TextStyle(color: ColorValues.greyTextColor);
  TextEditingController chipController = TextEditingController();
  TextEditingController advertNameController = TextEditingController();
  TextEditingController puppyNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  SharedServices sharedServices = SharedServices();
  CharityServices charityServices = CharityServices();
  String _selectedGender = 'Select Gender';
  CharityAdvertEditModel charityAdvertEditModel = CharityAdvertEditModel();
  List<BreedListModel> breedList = [];
  String _selectedBreed = "Select breed";
  bool isLoading = false;
  XFile? puppyPhoto;
  XFile? puppyCoverPhoto;
  AuthServices authServices = AuthServices();
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.id != null) {
      charityServices
          .getEditAdvert(context: context, id: widget.id)
          .then((value) {
        setState(() {
          charityAdvertEditModel = value!;
          isLoading = true;
        });
        _assignValues();
      });
    }
  }

  _assignValues() {
    if (charityAdvertEditModel.pets != null) {
      if (charityAdvertEditModel.pets![0].name != null) {
        puppyNameController.text = charityAdvertEditModel.pets![0].name!;
      }
      if (charityAdvertEditModel.pets![0].price != null) {
        priceController.text = charityAdvertEditModel.pets![0].price.toString();
      }
      if (charityAdvertEditModel.pets![0].chip_number != null &&
          charityAdvertEditModel.pets![0].chip_number!
                  .contains(RegExp(r'[a-z]')) ==
              false) {
        chipController.text = charityAdvertEditModel.pets![0].chip_number!;
      }
      if (charityAdvertEditModel.pets![0].color != null) {
        colorController.text = charityAdvertEditModel.pets![0].color!;
      }
      if (charityAdvertEditModel.pets![0].gender != null) {
        _selectedGender =
            charityAdvertEditModel.pets![0].gender![0].toUpperCase() +
                charityAdvertEditModel.pets![0].gender!.substring(1);
      }
    }
    if (charityAdvertEditModel.breed_id != null) {
      sharedServices.getBreedList(context: context).then((value) {
        breedList = value;
        if (charityAdvertEditModel.breed_id != null) {
          _selectedBreed = breedList
              .where((element) => element.id == charityAdvertEditModel.breed_id)
              .first
              .name;
        }
      });
    }
    if (charityAdvertEditModel.advert_name != null) {
      advertNameController.text = charityAdvertEditModel.advert_name!;
    }
    if (charityAdvertEditModel.description != null) {
      bioController.text = charityAdvertEditModel.description!;
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
                  //other styles
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ClipRRect(
                    // borderRadius: BorderRadius.only(
                    //     topRight: Radius.circular(12),
                    //     bottomRight: Radius.circular(12)),
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
              widget: _bodyWidget(sizingInformation: sizingInformation),
              sizingInformation: sizingInformation,
            ));
      },
    );
  }

  _bodyWidget({required SizingInformationModel sizingInformation}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Advertise a pet",
            style: CustomStyles.cardTitleStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            thickness: 2,
            color: ColorValues.fontColor,
          ),
          const Text(
            "Please complete the upload process to advertise a pet",
            style: TextStyle(
                fontFamily: "NotoSans",
                color: ColorValues.darkerGreyColor,
                fontSize: 11),
          ),
          const SizedBox(
            height: 30,
          ),
          // _profileContainer(sizingInformation: sizingInformation),
          // _bioContainer(sizingInformation: sizingInformation),
          const SizedBox(
            height: 20,
          ),
          _formContainer(sizingInformation: sizingInformation)
          // _listedPetsContainer(sizingInformation: sizingInformation)
        ],
      ),
    );
  }

  _formContainer({required SizingInformationModel sizingInformation}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SignUpWidgets.customtextField(
              textInputType: TextInputType.text,
              hintText: "Advert Name",
              textColor: ColorValues.fontColor,
              textController: advertNameController,
              sizingInformation: sizingInformation),
          FutureBuilder(
            future: sharedServices.getBreedList(context: context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                breedList = snapshot.data as List<BreedListModel>;
                List<String> breedNames = breedList
                    .map<String>((breedModel) => breedModel.name)
                    .toList();
                return CustomDropdownWidget(
                  defaultValue: "Select breed",
                  selectedValue: _selectedBreed,
                  selectedColor: ColorValues.fontColor,
                  itemList: breedNames,
                  onValueChanged: (newValue) {
                    setState(() {
                      _selectedBreed = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == "Select breed") {
                      return 'Please select breed';
                    }
                    if (value == null) {
                      return 'Please select breed';
                    }
                  },
                );
              }
              return Container();
            },
          ),
          // CustomDropdownWidget(
          //     defaultValue: "",
          //     selectedValue: "",
          //     onValueChanged: null,
          //     itemList: [],
          //     validator: () {}),
          const SizedBox(
            height: 20,
          ),
          SignUpWidgets.customtextField(
              textInputType: TextInputType.text,
              hintText: "Puppy Name",
              textColor: ColorValues.fontColor,
              textController: puppyNameController,
              sizingInformation: sizingInformation),
          SignUpWidgets.customtextField(
              textInputType: TextInputType.text,
              hintText: "Microchip No",
              textController: chipController,
              maxLength: 15,
              textColor: ColorValues.fontColor,
              sizingInformation: sizingInformation),
          SignUpWidgets.customtextField(
              textInputType: TextInputType.text,
              hintText: "Puppy price",
              textColor: ColorValues.fontColor,
              textController: priceController,
              sizingInformation: sizingInformation),
          SignUpWidgets.customtextField(
              textInputType: TextInputType.text,
              hintText: "Puppy Color",
              textColor: ColorValues.fontColor,
              textController: colorController,
              sizingInformation: sizingInformation),
          CustomDropdownWidget(
              defaultValue: "Select Gender",
              selectedValue: _selectedGender,
              selectedColor: ColorValues.fontColor,
              onValueChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
              itemList: const ['Select Gender', 'Male', 'Female'],
              validator: () {}),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: bioController,
            minLines: 4,
            maxLines: 10,
            textAlignVertical: TextAlignVertical.top,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(fontSize: 15.0, color: ColorValues.fontColor),
            decoration: const InputDecoration(
              hintText: "Write advert description here...",
              alignLabelWithHint: true,
              hintStyle: TextStyle(height: 0),
              labelText: "Advert description",
              labelStyle: TextStyle(color: ColorValues.darkerGreyColor),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide:
                    BorderSide(color: ColorValues.fontColor, width: 2.0),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide:
                      BorderSide(width: 1, color: ColorValues.lightGreyColor)),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          if (widget.id == null)
            puppyPhoto == null
                ? const SizedBox()
                : ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    child: Stack(
                      children: [
                        Image(
                            width: sizingInformation.safeBlockHorizontal * 35,
                            height: sizingInformation.safeBlockHorizontal * 45,
                            fit: BoxFit.cover,
                            image: FileImage(File(puppyPhoto!.path))
                                as ImageProvider),
                        Positioned(
                          right: 3,
                          top: 3,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                puppyPhoto = null;
                              });
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: ColorValues.redColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          if (isLoading == true && widget.id != null)
            puppyPhoto == null
                ? charityAdvertEditModel.pets![0].photo != null
                    ? Image(
                        width: sizingInformation.safeBlockHorizontal * 35,
                        height: sizingInformation.safeBlockHorizontal * 45,
                        fit: BoxFit.cover,
                        image: NetworkImage(BaseUrl.getImageBaseUrl() +
                            charityAdvertEditModel.pets![0].photo!))
                    : const SizedBox()
                : ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    child: Stack(
                      children: [
                        Image(
                            width: sizingInformation.safeBlockHorizontal * 35,
                            height: sizingInformation.safeBlockHorizontal * 45,
                            fit: BoxFit.cover,
                            image: FileImage(File(puppyPhoto!.path))
                                as ImageProvider),
                        Positioned(
                          right: 3,
                          top: 3,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                puppyPhoto = null;
                              });
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: ColorValues.redColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          CustomWidgets.iconButton(
              text: "UPLOAD PUPPY PHOTO",
              onPressed: () {
                _showPicker(context: context, role: "puppy");
              },
              buttonColor: ColorValues.lighBlueButton,
              asset: AssetValues.uploadSvg,
              width: sizingInformation.safeBlockHorizontal * 60,
              fontColor: ColorValues.fontColor,
              sizingInformation: sizingInformation),
          const SizedBox(
            height: 12,
          ),
          if (isLoading == true)
            puppyCoverPhoto == null
                ? charityAdvertEditModel.cover_photo != null
                    ? Image(
                        width: sizingInformation.safeBlockHorizontal * 35,
                        height: sizingInformation.safeBlockHorizontal * 45,
                        fit: BoxFit.cover,
                        image: NetworkImage(BaseUrl.getImageBaseUrl() +
                            charityAdvertEditModel.cover_photo!))
                    : const SizedBox()
                : Stack(
                    children: [
                      Image(
                          width: sizingInformation.safeBlockHorizontal * 35,
                          height: sizingInformation.safeBlockHorizontal * 45,
                          fit: BoxFit.cover,
                          image: FileImage(File(puppyCoverPhoto!.path))
                              as ImageProvider),
                      Positioned(
                        right: 3,
                        top: 3,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              puppyCoverPhoto = null;
                            });
                          },
                          child: const Icon(
                            Icons.cancel,
                            color: ColorValues.redColor,
                          ),
                        ),
                      ),
                    ],
                  ),
          const SizedBox(
            height: 10,
          ),
          CustomWidgets.iconButton(
              text: "UPLOAD PUPPY COVER PHOTO",
              onPressed: () {
                _showPicker(context: context, role: "puppyCover");
              },
              buttonColor: ColorValues.lighBlueButton,
              asset: AssetValues.uploadSvg,
              fontColor: ColorValues.fontColor,
              sizingInformation: sizingInformation),
          const SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Expanded(
                child: CustomWidgets.iconButton(
                    text: "Save",
                    fontSize: 14,
                    asset: AssetValues.saveIcon,
                    onPressed: () {
                      if (widget.id != null) {
                        charityServices.updateCharityAdvert(
                            chipNo: chipController.text,
                            advert_id: widget.id,
                            breed_id: breedList
                                .where(
                                    (element) => element.name == _selectedBreed)
                                .first
                                .id,
                            pet_id: charityAdvertEditModel.pets![0].pet_id,
                            price: priceController.text,
                            puppyName: puppyNameController.text,
                            description: bioController.text,
                            color: colorController.text,
                            advertName: advertNameController.text,
                            gender: _selectedGender,
                            isPublish: false,
                            photo: puppyPhoto?.path,
                            coverPhoto: puppyCoverPhoto?.path,
                            context: context);
                      } else {
                        charityServices.createCharityAdvert(
                            chipNo: chipController.text,
                            breed_id: breedList
                                .where(
                                    (element) => element.name == _selectedBreed)
                                .first
                                .id,
                            price: priceController.text,
                            puppyName: puppyNameController.text,
                            description: bioController.text,
                            color: colorController.text,
                            advertName: advertNameController.text,
                            gender: _selectedGender,
                            isPublish: false,
                            photo: puppyPhoto?.path,
                            coverPhoto: puppyCoverPhoto?.path,
                            context: context);
                      }
                    },
                    buttonColor: ColorValues.greyButtonColor,
                    sizingInformation: sizingInformation),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: CustomWidgets.iconButton(
                    text: "Finish",
                    fontSize: 14,
                    asset: AssetValues.forwardIcon,
                    onPressed: () {
                      if (widget.id != null) {
                        charityServices.updateCharityAdvert(
                            chipNo: chipController.text,
                            advert_id: widget.id,
                            breed_id: breedList
                                .where(
                                    (element) => element.name == _selectedBreed)
                                .first
                                .id,
                            pet_id: charityAdvertEditModel.pets![0].pet_id,
                            price: priceController.text,
                            puppyName: puppyNameController.text,
                            description: bioController.text,
                            color: colorController.text,
                            advertName: advertNameController.text,
                            gender: _selectedGender,
                            isPublish: true,
                            photo: puppyPhoto?.path,
                            coverPhoto: puppyCoverPhoto?.path,
                            context: context);
                      } else {
                        charityServices.createCharityAdvert(
                            chipNo: chipController.text,
                            breed_id: breedList
                                .where(
                                    (element) => element.name == _selectedBreed)
                                .first
                                .id,
                            price: priceController.text,
                            puppyName: puppyNameController.text,
                            description: bioController.text,
                            color: colorController.text,
                            advertName: advertNameController.text,
                            gender: _selectedGender,
                            isPublish: true,
                            photo: puppyPhoto?.path,
                            coverPhoto: puppyCoverPhoto?.path,
                            context: context);
                      }
                    },
                    buttonColor: ColorValues.loginBackground,
                    sizingInformation: sizingInformation),
              )
            ],
          )
        ],
      ),
    );
  }

  void _showPicker({required BuildContext context, required String role}) {
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
                        _imgFromGallery(role: role);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      _imgFromCamera(role: role);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
            ),
          );
        });
  }

  Future<void> _imgFromGallery({required String role}) async {
    _imagePicker
        .pickImage(
      source: ImageSource.gallery,
    )
        .then((pickedFile) {
      if (pickedFile != null) {
        if (role == "puppy") {
          setState(() {
            puppyPhoto = pickedFile;
            isLoading = true;
          });
        } else if (role == "puppyCover") {
          setState(() {
            puppyCoverPhoto = pickedFile;
          });
        }
      }
    });
  }

  Future<void> _imgFromCamera({required String role}) async {
    _imagePicker
        .pickImage(
      source: ImageSource.camera,
    )
        .then((pickedFile) {
      if (pickedFile != null) {
        if (role == "puppy") {
          setState(() {
            puppyPhoto = pickedFile;
          });
        } else if (role == "puppyCover") {
          setState(() {
            puppyCoverPhoto = pickedFile;
          });
        }
      }
    });
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
                      builder: (context) => const CharityDashBoardScreen()));
            },
            buttonColor: Colors.white.withValues(alpha: 0.25),
            btnLable: "Overview"),
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => CharityAdvertCreate(
              //           id: null,
              //         )));
            },
            buttonColor: ColorValues.loginBackground,
            btnLable: "Sell a pet"),
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CharityListedPets()));
            },
            buttonColor: Colors.white.withValues(alpha: 0.25),
            btnLable: "Listed pet"),
        custom.DrawerButton(
          sizingInformation: sizingInformation,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CharityMessageList()));
          },
          buttonColor: Colors.white.withValues(alpha: 0.25),
          btnLable: "Advert Messages",
          showMessageCounter: true,
          role: 'charity',
        ),
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CharityAccountSetting()));
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

