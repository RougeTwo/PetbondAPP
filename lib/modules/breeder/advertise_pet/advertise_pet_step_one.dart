import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart' hide DrawerButton;
import 'package:petbond_uk/core/services/secure_storage.dart';
import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/core/widgets/base_widget.dart';
import 'package:petbond_uk/core/widgets/custom_radio_button.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/core/widgets/drawer_buttons.dart' as custom;
import 'package:petbond_uk/core/widgets/shared/header.dart';
import 'package:petbond_uk/models/breeder/view_model.dart';
import 'package:petbond_uk/modules/auth/signup/widgets/signup_widgets.dart';
import 'package:petbond_uk/modules/breeder/breeder_dashboard.dart';
import 'package:petbond_uk/services/breeder/breeder_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petbond_uk/services/connect_account/connect_services.dart';
import 'package:petbond_uk/modules/breeder/chat/breeder_message_list.dart';
import '../../../core/utils/validator.dart';
import '../../../services/auth/auth_services.dart';
import '../breeder-profile_setting.dart';
import '../breeder_account_setting.dart';
import '../breeder_listed_pets.dart';
import '../breeder_my_sale.dart';

class AdvertisePetStepOne extends StatefulWidget {
  final String behaviour;
  final int? id;

  const AdvertisePetStepOne({Key? key, required this.behaviour, this.id})
      : super(key: key);

  @override
  _AdvertisePetStepOneState createState() => _AdvertisePetStepOneState();
}

class _AdvertisePetStepOneState extends State<AdvertisePetStepOne> {
  SecureStorage secureStorage = SecureStorage();
  int _valKennyClub = 2;
  int _valRegistration = 2;
  XFile? _firstImage;
  final _imagePicker = ImagePicker();
  TextStyle style = const TextStyle(color: ColorValues.greyTextColor);
  TextEditingController kennyClubController = TextEditingController();
  final licenseKey = GlobalKey<FormState>();
  TextEditingController registrationController = TextEditingController();
  TextEditingController licenceController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  BreederServices breederServices = BreederServices();
  ViewModel? viewModel;
  bool viewModelLoading = false;
  AuthServices authServices = AuthServices();
  ConnectServices connectServices = ConnectServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    breederServices.getViewModel(context: context).then((value) {
      setState(() {
        viewModel = value;
        _assignFirstStepValues();
        viewModelLoading = true;
      });
    });
  }

  _assignFirstStepValues() {
    if (viewModel!.detail != null) {
      if (viewModel!.detail!.reg_number != null) {
        setState(() {
          _valRegistration = 1;
        });
        registrationController.text = viewModel!.detail!.reg_number!;
      }
      if (viewModel!.detail!.kenney_club != null) {
        setState(() {
          _valKennyClub = 1;
        });
        kennyClubController.text = viewModel!.detail!.kenney_club!;
      }
      if (viewModel!.detail!.local_council != null) {
        licenceController.text = viewModel!.detail!.local_council!;
      }
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
          _firstImage = pickedFile;
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
          _firstImage = pickedFile;
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
                  //other styles
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
              widget: _bodyWidget(sizingInformation: sizingInformation),
              sizingInformation: sizingInformation,
            ));
      },
    );
  }

  _bodyWidget({required SizingInformationModel sizingInformation}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
          _bioContainer(sizingInformation: sizingInformation),
          const SizedBox(
            height: 30,
          ),
          viewModelLoading
              ? _formContainer(sizingInformation: sizingInformation)
              : CustomWidgets.box(sizingInformation: sizingInformation)
        ],
      ),
    );
  }

  _bioContainer({required SizingInformationModel sizingInformation}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Step 1 of 3",
              style: TextStyle(
                  fontFamily: "NotoSans",
                  fontSize: 16,
                  color: ColorValues.fontColor),
            ),
            const Spacer(),
            Row(
              children: [
                const CircleAvatar(
                  radius: 4,
                  backgroundColor: ColorValues.fontColor,
                ),
                const SizedBox(
                  width: 3,
                ),
                CircleAvatar(
                  radius: 4,
                  backgroundColor: ColorValues.fontColor.withValues(alpha: 0.4),
                ),
                const SizedBox(
                  width: 3,
                ),
                CircleAvatar(
                  radius: 4,
                  backgroundColor: ColorValues.fontColor.withValues(alpha: 0.4),
                ),
                const SizedBox(
                  width: 2,
                ),
              ],
            )
          ],
        ),
        const Divider(
          thickness: 2,
          color: ColorValues.fontColor,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  _formContainer({required SizingInformationModel sizingInformation}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Form(
        key: licenseKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Breeder details:",
              style: TextStyle(
                  color: ColorValues.greyTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomRadioButton(
                title: "Kennel Club Membership ID",
                onYesTap: () {
                  setState(() {
                    _valKennyClub = 1;
                  });
                },
                onNoTap: () {
                  setState(() {
                    _valKennyClub = 2;
                  });
                },
                value: _valKennyClub),
            const SizedBox(
              height: 20,
            ),
            if (_valKennyClub == 1)
              SignUpWidgets.customtextField(
                  textInputType: TextInputType.text,
                  hintText: "Kennel Club id...",
                  textColor: ColorValues.fontColor,
                  textController: kennyClubController,
                  sizingInformation: sizingInformation),
            const SizedBox(
              height: 12,
            ),
            CustomRadioButton(
                title: "If you sell more than 5 pets per year then",
                onYesTap: () {
                  setState(() {
                    _valRegistration = 1;
                  });
                },
                onNoTap: () {
                  setState(() {
                    _valRegistration = 2;
                    registrationController.text = "";
                  });
                },
                value: _valRegistration),
            const SizedBox(
              height: 20,
            ),
            if (_valRegistration == 1)
              SignUpWidgets.customtextField(
                  textInputType: TextInputType.text,
                  hintText: "Registration number...",
                  textColor: ColorValues.fontColor,
                  validator: Validator.validateEmptyFiled,
                  textController: registrationController,
                  sizingInformation: sizingInformation),
            const SizedBox(
              height: 12,
            ),
            SignUpWidgets.customtextField(
                textInputType: TextInputType.text,
                hintText: "Local Council...",
                validator: Validator.validateEmptyFiled,
                textColor: ColorValues.fontColor,
                textController: licenceController,
                sizingInformation: sizingInformation),
            const Text(
                "Tell the pet parents a little bit about yourself in your bio."),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: bioController,
              minLines: 4,
              maxLines: 10,
              textAlignVertical: TextAlignVertical.top,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style:
                  const TextStyle(fontSize: 15.0, color: ColorValues.fontColor),
              decoration: const InputDecoration(
                hintText: "Breeder bio...",
                alignLabelWithHint: true,
                hintStyle: TextStyle(height: 0),
                labelText: "Breeder bio...",
                labelStyle: TextStyle(color: ColorValues.fontColor),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide:
                      BorderSide(color: ColorValues.fontColor, width: 2.0),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                        width: 2.0, color: ColorValues.lightGreyColor)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _profileContainer(sizingInformation: sizingInformation),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  _profileContainer({required SizingInformationModel sizingInformation}) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text("Upload BIO pic"),
          const SizedBox(
            height: 10,
          ),
          _firstImage == null
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
                      image:
                          FileImage(File(_firstImage!.path)) as ImageProvider),
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
          const SizedBox(
            height: 10,
          ),
          const Text(
              "*Upload main profile photo.Main image used for your profile image on adverts."),
          const SizedBox(
            height: 20,
          ),
          CustomWidgets.iconButton(
              width: sizingInformation.screenWidth / 3,
              text: "Next",
              fontSize: 14,
              width2: 40,
              asset: AssetValues.forwardIcon,
              onPressed: () {
                if (registrationController.text.isNotEmpty ||
                    licenceController.text.isNotEmpty) {
                  if (licenseKey.currentState!.validate()) {
                    breederServices.breederUpdateAdvertStepOne(
                      bio: bioController.text,
                      reg_number: registrationController.text,
                      kenney_club: kennyClubController.text,
                      filepath: _firstImage?.path,
                      behaviour: widget.behaviour,
                      id: widget.id,
                      context: context,
                      url: BaseUrl.getBaseUrl() + "breeder/profile/info/update",
                    );
                  }
                } else {
                  breederServices.breederUpdateAdvertStepOne(
                    bio: bioController.text,
                    reg_number: registrationController.text,
                    kenney_club: kennyClubController.text,
                    filepath: _firstImage?.path,
                    behaviour: widget.behaviour,
                    id: widget.id,
                    context: context,
                    url: BaseUrl.getBaseUrl() + "breeder/profile/info/update",
                  );
                }
              },
              buttonColor: ColorValues.loginBackground,
              sizingInformation: sizingInformation),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
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
                      builder: (context) => const BreederDashBoardScreen()));
            },
            buttonColor: Colors.white.withValues(alpha: 0.25),
            btnLable: "Overview"),
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
            },
            buttonColor: ColorValues.loginBackground,
            btnLable: "Sell a pet"),
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BreederProfileSetting()));
            },
            buttonColor: Colors.white.withValues(alpha: 0.25),
            btnLable: "Profile"),
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const BreederListedPets()));
            },
            buttonColor: Colors.white.withValues(alpha: 0.25),
            btnLable: "Listed pet"),
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const BreederMySale()));
            },
            buttonColor: Colors.white.withValues(alpha: 0.25),
            btnLable: "My Sales"),
        custom.DrawerButton(
          sizingInformation: sizingInformation,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BreederMessageList()));
          },
          buttonColor: Colors.white.withValues(alpha: 0.25),
          btnLable: "Advert Messages",
          showMessageCounter: true,
        ),
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BreederAccountSetting()));
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

