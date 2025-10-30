import 'dart:io';
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/services/secure_storage.dart';
import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/utils/validator.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/models/breeder/view_model.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';
import 'package:petbond_uk/services/breeder/breeder_services.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/widgets/base_widget.dart';
import '../../core/widgets/drawer_buttons.dart';
import '../../core/widgets/shared/header.dart';
import 'advertise_pet/advert_pet_overview.dart';
import 'advertise_pet/advertise_pet_step_two_create.dart';
import 'breeder-profile_setting.dart';
import 'breeder_account_setting.dart';
import 'breeder_listed_pets.dart';
import 'breeder_my_sale.dart';
import 'chat/breeder_message_list.dart';

class BreederEditBio extends StatefulWidget {
  const BreederEditBio({Key? key}) : super(key: key);

  @override
  _BreederEditBioState createState() => _BreederEditBioState();
}

class _BreederEditBioState extends State<BreederEditBio> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController bioController = TextEditingController();
  XFile? _image;
  final _imagePicker = ImagePicker();
  BreederServices breederServices = BreederServices();
  SecureStorage secureStorage = SecureStorage();
  ViewModel? viewModel;
  bool viewModelLoading = false;
  // String? qrImage;
  // bool imageLoaded = false;
  AuthServices authServices = AuthServices();

  // readQR() async {
  //   qrImage = await secureStorage.readStore('qr_code');
  //   if (qrImage != null) {
  //     setState(() {
  //       imageLoaded = true;
  //     });
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    breederServices.getViewModel(context: context).then((value) {
      if (mounted) {
        setState(() {
          viewModel = value;
          viewModelLoading = true;
          _assignValue();
        });
      }
    });
  }

  _assignValue() {
    if (viewModel!.detail != null) {
      if (viewModel!.detail!.bio != null) {
        bioController.text = viewModel!.detail!.bio!;
      }
    }
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
              // onTap: () {
              //   readQR();
              //   showGeneralDialog(
              //       context: context,
              //       barrierDismissible: true,
              //       barrierLabel: MaterialLocalizations.of(context)
              //           .modalBarrierDismissLabel,
              //       barrierColor: Colors.black45,
              //       transitionDuration: const Duration(milliseconds: 200),
              //       pageBuilder: (BuildContext buildContext,
              //           Animation animation, Animation secondaryAnimation) {
              //         return Center(
              //           child: Container(
              //             height: sizingInformation.safeBlockHorizontal * 60,
              //             width: sizingInformation.safeBlockHorizontal * 60,
              //             padding: const EdgeInsets.all(20),
              //             color: Colors.white,
              //             child: Container(
              //               child: imageLoaded == true
              //                   ? SvgPicture.network(
              //                       BaseUrl.getImageBaseUrl() + qrImage!,
              //                       width:
              //                           sizingInformation.safeBlockHorizontal *
              //                               20,
              //                       height:
              //                           sizingInformation.safeBlockHorizontal *
              //                               20,
              //                     )
              //                   : Container(),
              //             ),
              //           ),
              //         );
              //       });
              // },
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
      child: viewModelLoading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Edit Bio",
                  style: CustomStyles.cardTitleStyle,
                ),
                const SizedBox(
                  height: 30,
                ),
                _profileContainer(sizingInformation: sizingInformation),
                const SizedBox(
                  height: 20,
                ),
                _bioContainer(sizingInformation: sizingInformation)
              ],
            )
          : CustomWidgets.box(sizingInformation: sizingInformation),
    );
  }

  _profileContainer({required SizingInformationModel sizingInformation}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _image == null
            ? viewModel!.avatar == null
                ? SvgPicture.asset(
                    AssetValues.profileIcon,
                    width: sizingInformation.safeBlockHorizontal * 50,
                    height: sizingInformation.safeBlockHorizontal * 50,
                    fit: BoxFit.cover,
                  )
                : CustomWidgets.customNetworkImage(
                    imageUrl: BaseUrl.getImageBaseUrl() +
                        viewModel!.avatar.toString(),
                    sizingInformation: sizingInformation)
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
        CustomWidgets.iconButton(
            text: "UPLOAD",
            onPressed: () => _showPicker(context),
            buttonColor: ColorValues.lighBlueButton,
            asset: AssetValues.uploadSvg,
            width: sizingInformation.safeBlockHorizontal * 30,
            fontColor: ColorValues.fontColor,
            sizingInformation: sizingInformation),
      ],
    );
  }

  _bioContainer({required SizingInformationModel sizingInformation}) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bio",
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
            height: 10,
          ),
          TextFormField(
            controller: bioController,
            minLines: 4,
            maxLines: 10,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter bio';
              }
              return null;
            },
            textAlignVertical: TextAlignVertical.top,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(fontSize: 15.0, color: Colors.black),
            decoration: const InputDecoration(
              hintText: "Your bio..",
              alignLabelWithHint: true,
              hintStyle: TextStyle(height: 0),
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
            height: 20,
          ),
          CustomWidgets.iconButton(
              text: "Save",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  breederServices.breederUpdateBioInfo(
                      url: "${BaseUrl.getBaseUrl()}" +
                          "breeder/profile/info/update",
                      bio: bioController.text == null
                          ? viewModel!.detail!.bio.toString()
                          : bioController.text,
                      context: context,
                      filepath: _image == null ? null : _image!.path);
                }
              },
              width: sizingInformation.safeBlockHorizontal * 40,
              buttonColor: ColorValues.loginBackground,
              asset: AssetValues.saveIcon,
              sizingInformation: sizingInformation)
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
            },
            buttonColor: ColorValues.loginBackground,
            btnLable: "Overview"),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdvertisePetStepTwoCreate(
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BreederAccountSetting()));
            },
            buttonColor: Colors.white.withOpacity(0.25),
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
