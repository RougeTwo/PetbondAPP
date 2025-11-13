import 'package:flutter/material.dart';
﻿// ignore_for_file: non_constant_identifier_names
import 'package:petbond_uk/core/utils/file_universal.dart';
import 'package:flutter/material.dart' hide DrawerButton;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:petbond_uk/core/services/secure_storage.dart';
import 'package:petbond_uk/core/utils/helper.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/utils/validator.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/core/widgets/custom_drop_down_widget.dart';
import 'package:petbond_uk/core/widgets/custom_radio_button.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/core/widgets/base_widget.dart';
import 'package:petbond_uk/core/widgets/drawer_buttons.dart' as custom;
import 'package:petbond_uk/core/widgets/shared/header.dart';
import 'package:petbond_uk/models/breeder/advert_sale/advert_id.dart';
import 'package:petbond_uk/models/shared/breed_list_model.dart';
import 'package:petbond_uk/models/shared/chip_model.dart';
import 'package:petbond_uk/models/shared/examinations.dart';
import 'package:petbond_uk/modules/auth/signup/widgets/signup_widgets.dart';
import 'package:petbond_uk/modules/breeder/breeder_dashboard.dart';
import 'package:petbond_uk/services/breeder/breeder_services.dart';
import 'package:petbond_uk/services/connect_account/connect_services.dart';
import 'package:petbond_uk/services/shared/shared_services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/base_url.dart';
import '../../../models/breeder/edit_advert/edit_advert_pets.dart';
import '../../../models/breeder/view_model.dart';
import '../../../services/auth/auth_services.dart';
import '../breeder-profile_setting.dart';
import '../breeder_account_setting.dart';
import '../breeder_listed_pets.dart';
import '../breeder_my_sale.dart';
import '../chat/breeder_message_list.dart';
import 'helper/puppet_form.dart';

class AdvertisePetStepTwoCreate extends StatefulWidget {
  final String behaviour;
  final int? id;

  const AdvertisePetStepTwoCreate({Key? key, required this.behaviour, this.id})
      : super(key: key);

  @override
  _AdvertisePetStepTwoCreateState createState() =>
      _AdvertisePetStepTwoCreateState();
}

class _AdvertisePetStepTwoCreateState extends State<AdvertisePetStepTwoCreate> {
  int i = 2;
  bool showExaminationData = false;
  int motherHealth = 2;
  int fatherHealth = 2;
  final chipFormKey = GlobalKey<FormState>();
  final advertNameKey = GlobalKey<FormState>();
  List<ExaminationModel> userChecked = [];
  TextStyle style = const TextStyle(color: ColorValues.greyTextColor);
  TextEditingController newChipController = TextEditingController();
  TextEditingController advertNameController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  SharedServices sharedServices = SharedServices();
  BreederServices breederServices = BreederServices();
  List<ExaminationModel>? examinationList;
  List<BreedListModel> breedList = [];
  List<ChipListModel> chipList = [];
  String _selectedBreed = "Select breed";
  List<PuppetForm> pets = [];

  // String _selectedChipNumber = "Select chip number";
  bool showAddChipFields = false;
  File? _coverImage;
  List<String> motherExaminations = List.empty(growable: true);
  List<String> fatherExaminations = List.empty(growable: true);
  AdvertIdModel advertIdModel = AdvertIdModel();
  File? mother_report_image;
  List<File?> mother_reports = [];
  File? father_report_image;
  Future<List<ChipListModel>>? updateChipList;
  List<File?> father_reports = [];
  SecureStorage secureStorage = SecureStorage();
  XFile? _fatherCertificate;
  AuthServices authServices = AuthServices();
  ConnectServices connectServices = ConnectServices();
  String? qrImage;
  bool imageLoaded = false;
  bool showBreedError = false;
  ScrollController scrollController = ScrollController();
  int _valKennyClub = 2;
  int _valRegistration = 2;
  ViewModel? viewModel;
  bool viewModelLoading = false;
  TextEditingController kennyClubController = TextEditingController();
  TextEditingController registrationController = TextEditingController();
  TextEditingController licenceController = TextEditingController();
  TextStyle style0 = const TextStyle(color: ColorValues.greyTextColor, fontSize: 16);
  TextEditingController thirdDateController = TextEditingController();
  TextEditingController thirdMotherChipController = TextEditingController();
  bool thirdImageLoaded = false;
  bool thirdHasValue = false;
  int _thirdValMotherChipNumber = 2;
  DateTime? _thirdPickedDate;

  readQR() async {
    qrImage = await secureStorage.readStore('qr_code');
    if (qrImage != null) {
      setState(() {
        imageLoaded = true;
      });
    }
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
    }
  }

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
    sharedServices.getExaminationList(context: context).then((value) {
      setState(() {
        examinationList = value;
        showExaminationData = true;
      });
        });
    onAddForm();
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
              showCardWidget: true,
              widget: Column(
                children: [
                  _introductionSection(sizingInformation: sizingInformation),
                  const SizedBox(
                    height: 20,
                  ),
                  _firstStepUpdate(sizingInformation: sizingInformation),
                  const SizedBox(
                    height: 20,
                  ),
                  _secondStepUpdate(sizingInformation: sizingInformation),
                  const SizedBox(
                    height: 20,
                  ),
                  _thirdStepUpdate(sizingInformation: sizingInformation)
                ],
              ),
              sizingInformation: sizingInformation,
            ));
      },
    );
  }

  _firstStepUpdate({required SizingInformationModel sizingInformation}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Card(
          //  color: Colors.white10,
          shadowColor: Colors.black,
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          //  / clipBehavior: Clip.none,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Step 1: Others Details",
                    style: CustomStyles.cardTitleStyleTwo,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  _firstformContainer(sizingInformation: sizingInformation)
                ],
              ),
            ),
          )),
    );
  }

  _firstformContainer({required SizingInformationModel sizingInformation}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
              title: "If you sell more than 6 pets per year then",
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
                textController: registrationController,
                sizingInformation: sizingInformation),
          const SizedBox(
            height: 12,
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: CustomWidgets.buttonWithoutFontFamily(
                text: "Save & Continue",
                width: 50,
                onPressed: () {
                  breederServices.breederUpdateAdvertStepOne(
                    bio: bioController.text,
                    reg_number: registrationController.text,
                    kenney_club: kennyClubController.text,
                    // filepath: _firstImage == null ? null : _firstImage!.path,
                    behaviour: widget.behaviour,
                    id: widget.id,
                    context: context,
                    url: BaseUrl.getBaseUrl() + "breeder/profile/info/update",
                  );
                },
                buttonColor: ColorValues.loginBackground,
                sizingInformation: sizingInformation,
                borderColor: ColorValues.loginBackground),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  _secondStepUpdate({required SizingInformationModel sizingInformation}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Card(
          //  color: Colors.white10,
          shadowColor: Colors.black,
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          //  / clipBehavior: Clip.none,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Step 2: Advert Details",
                    style: CustomStyles.cardTitleStyleTwo,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  _formContainer(sizingInformation: sizingInformation)
                ],
              ),
            ),
          )),
    );
  }

  _introductionSection({required SizingInformationModel sizingInformation}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Card(
          //  color: Colors.white10,
          shadowColor: Colors.black,
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          //  / clipBehavior: Clip.none,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Create an advert",
                    style: CustomStyles.cardTitleStyleTwo,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      const Text(
                          "To create your advert fill out the next three steps, after you complete each section press save and continue."),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            AssetValues.purpleLogo,
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(" Step 1: Others Details"),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            AssetValues.purpleLogo,
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(" Step 2: Advert Details"),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            AssetValues.purpleLogo,
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(" Step 3: Puppy Liters Details"),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }

  

  _formContainer({required SizingInformationModel sizingInformation}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Form(
        key: advertNameKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SignUpWidgets.customtextField(
                textInputType: TextInputType.text,
                hintText: "Advert Name",
                textColor: ColorValues.fontColor,
                validator: Validator.validateEmptyFiled,
                textController: advertNameController,
                sizingInformation: sizingInformation),
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
                    borderSide: BorderSide(
                        width: 1, color: ColorValues.lightGreyColor)),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Mother & father details:",
              style: TextStyle(
                  color: ColorValues.greyTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 15,
            ),
            SignUpWidgets.customtextField(
                textInputType: TextInputType.text,
                hintText: "Mother Name",
                textColor: ColorValues.fontColor,
                textController: motherNameController,
                sizingInformation: sizingInformation),
            SignUpWidgets.customtextField(
                textInputType: TextInputType.text,
                hintText: "Father Name",
                textColor: ColorValues.fontColor,
                textController: fatherNameController,
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
            // Text(
            //   "Microchip number of mother of litter...",
            //   style: style,
            // ),
            // SizedBox(
            //   height: 12,
            // ),
            // FutureBuilder(
            //   future: updateChipList ??
            //       sharedServices.getChipList(context: context),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       chipList = snapshot.data as List<ChipListModel>;
            //       List<String> chipname = chipList
            //           .map<String>((breedModel) => breedModel.chip_number)
            //           .toList();
            //       return CustomDropdownWidget(
            //         defaultValue: "Select chip number",
            //         selectedValue: _selectedChipNumber,
            //         itemList: chipname,
            //         onValueChanged: (newValue) {
            //           setState(() {
            //             _selectedChipNumber = newValue!;
            //           });
            //         },
            //         validator: (value) {
            //           if (value == "Select chip number") {
            //             return 'Please select chip no';
            //           }
            //           if (value == null) {
            //             return 'Please select chip no';
            //           }
            //         },
            //       );
            //     }
            //     return Container();
            //   },
            // ),
            // SizedBox(
            //   height: 12,
            // ),
            // Center(
            //   child: Text(
            //     "(OR)",
            //     style: style,
            //   ),
            // ),
            // SizedBox(
            //   height: 12,
            // ),
            // Align(
            //   alignment: Alignment.center,
            //   child: CustomWidgets.buttonWithoutFontFamily(
            //       text: "*Add New Chip Number",
            //       onPressed: () {
            //         setState(() {
            //           showAddChipFields = !showAddChipFields;
            //           newChipController.clear();
            //           _selectedBreed = "Select breed";
            //         });
            //       },
            //       buttonColor: ColorValues.loginBackground,
            //       borderColor: ColorValues.loginBackground,
            //       sizingInformation: sizingInformation),
            // ),
            // SizedBox(
            //   height: 15,
            // ),
            // if (showAddChipFields == true)
            //   GestureDetector(
            //     child: Text(
            //       "hide",
            //       style: TextStyle(
            //           color: ColorValues.fontColor,
            //           decoration: TextDecoration.underline,
            //           fontWeight: FontWeight.w700,
            //           fontSize: 14),
            //     ),
            //     onTap: () {
            //       setState(() {
            //         showAddChipFields = false;
            //       });
            //     },
            //   ),
            // if (showAddChipFields == true)
            const SizedBox(
              height: 15,
            ),
            // if (showAddChipFields == true)
            //   _addChipFields(sizingInformation: sizingInformation),
            CustomRadioButton(
                onYesTap: () {
                  setState(() {
                    motherHealth = 1;
                  });
                },
                onNoTap: () {
                  setState(() {
                    motherHealth = 2;
                  });
                },
                title: "Is the mother of puppies health tested",
                value: motherHealth),
            const SizedBox(
              height: 12,
            ),
            if (motherHealth == 1)
              Text(
                "Tests carried out",
                style: style,
              ),
            if (motherHealth == 1)
              const SizedBox(
                height: 12,
              ),
            if (motherHealth == 1)
              showExaminationData
                  ? GridView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                String id =
                                    examinationList![index].id.toString();
                                if (motherExaminations.contains(id)) {
                                  setState(() {
                                    motherExaminations.remove(id);
                                  });
                                } else {
                                  setState(() {
                                    motherExaminations.add(id);
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(6)),
                                  border: Border.all(
                                      width: 2,
                                      color: ColorValues.lightGreyColor),
                                ),
                                child: motherExaminations.contains(
                                            examinationList![index]
                                                .id
                                                .toString()) ==
                                        true
                                    ? CustomWidgets.checkedBox()
                                    : CustomWidgets.unCheckedBox(),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            // Text(breedList![index].name),
                            Text(
                                "${examinationList![index].name[0].toUpperCase()}${examinationList![index].name.substring(1).toLowerCase()}"),
                          ],
                        );
                      },
                      itemCount: examinationList!.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 4),
                    )
                  : const SizedBox(),
            const SizedBox(
              height: 10,
            ),
            //==============Image Section==

            if (motherHealth == 1)
              _motherImageWidget(sizingInformation: sizingInformation),
            const SizedBox(
              height: 10,
            ),
            CustomRadioButton(
                onYesTap: () {
                  setState(() {
                    fatherHealth = 1;
                  });
                },
                onNoTap: () {
                  setState(() {
                    fatherHealth = 2;
                  });
                },
                title: "Is the father of puppies health tested",
                value: fatherHealth),
            const SizedBox(
              height: 12,
            ),
            if (fatherHealth == 1)
              Text(
                "Tests carried out",
                style: style,
              ),
            if (fatherHealth == 1)
              const SizedBox(
                height: 12,
              ),
            if (fatherHealth == 1)
              showExaminationData
                  ? GridView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                String id =
                                    examinationList![index].id.toString();
                                if (fatherExaminations.contains(id)) {
                                  setState(() {
                                    fatherExaminations.remove(id);
                                  });
                                } else {
                                  setState(() {
                                    fatherExaminations.add(id);
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(6)),
                                  border: Border.all(
                                      width: 2,
                                      color: ColorValues.lightGreyColor),
                                ),
                                child: fatherExaminations.contains(
                                            examinationList![index]
                                                .id
                                                .toString()) ==
                                        true
                                    ? CustomWidgets.checkedBox()
                                    : CustomWidgets.unCheckedBox(),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            // Text(breedList![index].name),
                            Text(
                                "${examinationList![index].name[0].toUpperCase()}${examinationList![index].name.substring(1).toLowerCase()}"),
                          ],
                        );
                      },
                      itemCount: examinationList!.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 4),
                    )
                  : const SizedBox(),
            const SizedBox(
              height: 10,
            ),
            _fatherCertificate == null
                ? const SizedBox()
                : Stack(
                    children: [
                      Image(
                          width: sizingInformation.safeBlockHorizontal * 35,
                          height: sizingInformation.safeBlockHorizontal * 45,
                          fit: BoxFit.cover,
                          image: FileImage(File(_fatherCertificate!.path))
                              as ImageProvider),
                      Positioned(
                        right: 3,
                        top: 3,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _fatherCertificate = null;
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
            if (fatherHealth == 1)
              _fatherImageWidget(sizingInformation: sizingInformation),
            const SizedBox(
              height: 10,
            ),
            _profileContainer(sizingInformation: sizingInformation),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                // IconButton(
                //   onPressed: () {
                //     if (advertNameKey.currentState!.validate()) {
                //       breederServices
                //           .createBreederAdvert(
                //               advert_name: advertNameController.text,
                //               mother_name: motherNameController.text,
                //               father_name: fatherNameController.text,
                //               coverImage: _coverImage != null
                //                   ? _coverImage!.path
                //                   : null,
                //               is_publish: null,
                //               breed_id: breedList
                //                   .where((element) =>
                //                       element.name == _selectedBreed)
                //                   .first
                //                   .id
                //                   .toString(),
                //               mother_reports: mother_reports.length > 0
                //                   ? mother_reports
                //                   : [],
                //               mother_test: motherExaminations,
                //               father_reports: father_reports.length > 0
                //                   ? father_reports
                //                   : [],
                //               father_test: fatherExaminations,
                //               context: context,
                //               description: bioController.text)
                //           .then((value) {
                //         if (value != null) {
                //           advertIdModel = value;
                //           EasyLoading.showSuccess(CustomStyles.save_text);
                //           Future.delayed(Duration(seconds: 1), () {
                //             Navigator.pushReplacement(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) => AdvertisePetStepOne(
                //                           behaviour: "edit",
                //                           id: advertIdModel.advert_id,
                //                         )));
                //           });
                //         }
                //       }).catchError((e) {
                //         EasyLoading.showError(e);
                //       });
                //     }
                //   },
                //   icon: Icon(
                //     Icons.arrow_back,
                //     color: ColorValues.loginBackground,
                //     size: 28,
                //   ),
                // ),
                // Spacer(),
                CustomWidgets.iconButton(
                    text: "Save Progress",
                    fontSize: 14,
                    width: sizingInformation.safeBlockHorizontal * 45,
                    asset: AssetValues.saveIcon,
                    onPressed: () {
                      if (advertNameKey.currentState!.validate()) {
                        if (_selectedBreed != "Select breed") {
                          breederServices
                              .createBreederAdvert(
                                  advert_name: advertNameController.text,
                                  mother_name: motherNameController.text,
                                  father_name: fatherNameController.text,
                                  breed_id: breedList
                                      .where((element) =>
                                          element.name == _selectedBreed)
                                      .first
                                      .id
                                      .toString(),
                                  coverImage: _coverImage?.path,
                                  is_publish: false,
                                  mother_reports: mother_reports.isNotEmpty
                                      ? mother_reports
                                      : [],
                                  mother_test: motherExaminations,
                                  father_reports: father_reports.isNotEmpty
                                      ? father_reports
                                      : [],
                                  father_test: fatherExaminations,
                                  context: context,
                                  description: bioController.text)
                              .then((value) {
                            if (value != null) {
                              EasyLoading.showSuccess(CustomStyles.saveText);
                              Future.delayed(const Duration(seconds: 1), () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (contex) =>
                                            const BreederDashBoardScreen()));
                              });
                            }
                          }).catchError((e) {
                            EasyLoading.showError(e);
                          });
                        } else {
                          EasyLoading.showInfo("Select Breed");
                        }
                      } else {
                        EasyLoading.showInfo("Advert name is required");
                      }
                    },
                    buttonColor: ColorValues.greyButtonColor,
                    sizingInformation: sizingInformation),
                const Spacer(),
                CustomWidgets.buttonWithoutFontFamily(
                    text: "Save & C.",
                    width: 30,
                    onPressed: () {
                      if (advertNameKey.currentState!.validate()) {
                        if (_selectedBreed != "Select breed") {
                          breederServices
                              .createBreederAdvert(
                                  advert_name: advertNameController.text,
                                  mother_name: motherNameController.text,
                                  father_name: fatherNameController.text,
                                  breed_id: breedList
                                      .where((element) =>
                                          element.name == _selectedBreed)
                                      .first
                                      .id
                                      .toString(),
                                  description: bioController.text,
                                  coverImage: _coverImage?.path,
                                  is_publish: null,
                                  mother_reports: mother_reports.isNotEmpty
                                      ? mother_reports
                                      : [],
                                  mother_test: motherExaminations,
                                  father_reports: father_reports.isNotEmpty
                                      ? father_reports
                                      : [],
                                  father_test: fatherExaminations,
                                  context: context)
                              .then((value) {
                            if (value != null) {
                              advertIdModel = value;
                              EasyLoading.showSuccess(CustomStyles.saveText);
                            }
                          }).catchError((e) {
                            EasyLoading.showError(e);
                          });
                        } else {
                          EasyLoading.showInfo("Select Breed");
                        }
                      } else {
                        EasyLoading.showInfo("Advert name is required");
                      }
                    },
                    buttonColor: ColorValues.loginBackground,
                    sizingInformation: sizingInformation,
                    borderColor: ColorValues.loginBackground),
                // IconButton(
                //   onPressed: () {
                //     if (advertNameKey.currentState!.validate()) {
                //       breederServices
                //           .createBreederAdvert(
                //               advert_name: advertNameController.text,
                //               mother_name: motherNameController.text,
                //               father_name: fatherNameController.text,
                //               breed_id: breedList
                //                   .where((element) =>
                //                       element.name == _selectedBreed)
                //                   .first
                //                   .id
                //                   .toString(),
                //               description: bioController.text,
                //               coverImage: _coverImage != null
                //                   ? _coverImage!.path
                //                   : null,
                //               is_publish: null,
                //               mother_reports: mother_reports.length > 0
                //                   ? mother_reports
                //                   : [],
                //               mother_test: motherExaminations,
                //               father_reports: father_reports.length > 0
                //                   ? father_reports
                //                   : [],
                //               father_test: fatherExaminations,
                //               context: context)
                //           .then((value) {
                //         if (value != null) {
                //           advertIdModel = value;
                //           EasyLoading.showSuccess(CustomStyles.save_text);
                //           Future.delayed(Duration(seconds: 1), () {
                //             Navigator.pushReplacement(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) => AdvertisePetStepThree(
                //                           behaviour: widget.behaviour,
                //                           id: advertIdModel.advert_id,
                //                         )));
                //           });
                //         }
                //       }).catchError((e) {
                //         EasyLoading.showError(e);
                //       });
                //     }
                //   },
                //   icon: Icon(
                //     Icons.arrow_forward,
                //     color: ColorValues.loginBackground,
                //     size: 28,
                //   ),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }

  _profileContainer({required SizingInformationModel sizingInformation}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "Upload main advert Image",
            style: style,
          ),
          const SizedBox(
            height: 10,
          ),
          _coverImage == null
              ? SvgPicture.asset(
                  AssetValues.profileIcon,
                  width: sizingInformation.safeBlockHorizontal * 50,
                  height: sizingInformation.safeBlockHorizontal * 50,
                  fit: BoxFit.cover,
                )
              : ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: Container(
                    color: Colors.grey.shade300,
                    child: Image(
                        width: sizingInformation.safeBlockHorizontal * 50,
                        height: sizingInformation.safeBlockHorizontal * 45,
                        fit: BoxFit.cover,
                        image: FileImage(File(_coverImage!.path))
                            as ImageProvider),
                  ),
                ),
          const SizedBox(
            height: 10,
          ),
          CustomWidgets.iconButton(
              text: "UPLOAD",
              onPressed: () {
                _showBottomModalPicker(context, sizingInformation, "cover");
              },
              buttonColor: ColorValues.lighBlueButton,
              asset: AssetValues.uploadSvg,
              width: sizingInformation.safeBlockHorizontal * 30,
              fontColor: ColorValues.fontColor,
              sizingInformation: sizingInformation),
          Text(
            "*Image of mother with puppies is recommended for better sales.",
            style: style,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  //==================mother image section====================
  _motherImageWidget({required SizingInformationModel sizingInformation}) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        _addNewMotherImageWidget(
          sizingInformation: sizingInformation,
          role: 'mother',
        ),
        if (mother_report_image != null)
          SizedBox(
            height: sizingInformation.safeBlockHorizontal * 5,
          ),
        if (mother_report_image != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomWidgets.buttonWithoutFontFamily(
                sizingInformation: sizingInformation,
                text: 'Cancel',
                width: sizingInformation.safeBlockHorizontal * 25,
                onPressed: () => setState(() => mother_report_image = null),
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
                  mother_reports.insert(0, mother_report_image);
                  mother_report_image = null;
                }),
              ),
            ],
          ),
        if (mother_reports.isNotEmpty && mother_report_image == null)
          SizedBox(
            height: sizingInformation.safeBlockHorizontal * 7,
          ),
        if (mother_reports.isNotEmpty && mother_report_image == null)
          Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            radius: const Radius.circular(10),
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  for (File? image in mother_reports)
                    _buildImageBox(
                        sizingInformation: sizingInformation, image: image),
                ],
              ),
            ),
          ),
        SizedBox(
          height: sizingInformation.safeBlockHorizontal * 5,
        ),
      ],
    );
  }

  Widget _addNewMotherImageWidget(
      {required SizingInformationModel sizingInformation,
      required String role}) {
    return Center(
      child: GestureDetector(
        onTap: () => mother_report_image != null
            ? null
            : _showBottomModalPicker(context, sizingInformation, role),
        child: mother_report_image != null
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
                    image: FileImage(File(mother_report_image!.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(
                width: sizingInformation.safeBlockHorizontal * 45,
                decoration: const BoxDecoration(
                    color: ColorValues.lighBlueButton,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text("UPLOAD RESULT",
                          style: TextStyle(
                            color: ColorValues.fontColor,
                            fontWeight: FontWeight.normal,
                          )),
                      const Spacer(),
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

//===========father image section=============]
  _fatherImageWidget({required SizingInformationModel sizingInformation}) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        _addNewFatherImageWidget(
          sizingInformation: sizingInformation,
          role: 'father',
        ),
        if (father_report_image != null)
          SizedBox(
            height: sizingInformation.safeBlockHorizontal * 5,
          ),
        if (father_report_image != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomWidgets.buttonWithoutFontFamily(
                sizingInformation: sizingInformation,
                text: 'Cancel',
                width: sizingInformation.safeBlockHorizontal * 25,
                onPressed: () => setState(() => father_report_image = null),
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
                  father_reports.insert(0, father_report_image);
                  father_report_image = null;
                }),
              ),
            ],
          ),
        if (father_reports.isNotEmpty && father_report_image == null)
          SizedBox(
            height: sizingInformation.safeBlockHorizontal * 7,
          ),
        if (father_reports.isNotEmpty && father_report_image == null)
          Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            radius: const Radius.circular(10),
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  for (File? image in father_reports)
                    _buildImageBox(
                        sizingInformation: sizingInformation, image: image),
                ],
              ),
            ),
          ),
        SizedBox(
          height: sizingInformation.safeBlockHorizontal * 5,
        ),
      ],
    );
  }

  Widget _addNewFatherImageWidget(
      {required SizingInformationModel sizingInformation,
      required String role}) {
    return Center(
      child: GestureDetector(
        onTap: () => father_report_image != null
            ? null
            : _showBottomModalPicker(context, sizingInformation, role),
        child: father_report_image != null
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
                    image: FileImage(File(father_report_image!.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(
                width: sizingInformation.safeBlockHorizontal * 45,
                decoration: const BoxDecoration(
                    color: ColorValues.lighBlueButton,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text("UPLOAD RESULT",
                          style: TextStyle(
                            color: ColorValues.fontColor,
                            fontWeight: FontWeight.normal,
                          )),
                      const Spacer(),
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

  Widget _buildImageBox(
      {required SizingInformationModel sizingInformation, dynamic image}) {
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
                child: Image(
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
                father_reports.remove(image);
              });
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

  // ===================image picker==========
  void _showBottomModalPicker(BuildContext context,
      SizingInformationModel sizingInformationModel, String role) {
    showModalBottomSheet(
        // backgroundColor: ColorValues.loginBackground,
        context: context,
        builder: (BuildContext modalContext) {
          return SafeArea(
              child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                  ),
                  title: const Text(
                    'Photo Library',
                  ),
                  onTap: () {
                    _getFile(ImageSource.gallery, role);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_camera,
                  ),
                  title: const Text(
                    'Camera',
                  ),
                  onTap: () {
                    _getFile(ImageSource.camera, role);
                    Navigator.pop(context);
                  },
                ),
              ],
          ));
        });
  }

  void _getFile(ImageSource imageSource, String role) {
    Helper.imagePicker(imageSource: imageSource).then((file) async {
      if (role == "mother") {
        setState(() {
          mother_report_image = file;
        });
        return mother_report_image;
      }
      if (role == "father") {
        setState(() {
          father_report_image = file;
        });
        return father_report_image;
      }
      if (role == "cover") {
        setState(() {
          _coverImage = file;
        });
        return _coverImage;
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

  _thirdStepUpdate({required SizingInformationModel sizingInformation}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Card(
          //  color: Colors.white10,
          shadowColor: Colors.black,
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          //  / clipBehavior: Clip.none,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Step 3: Puppy Litter Details",
                    style: CustomStyles.cardTitleStyleTwo,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Date of Birth", style: style),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    autocorrect: false,
                    controller: thirdDateController,
                    style: const TextStyle(
                        fontSize: 15.0, color: ColorValues.fontColor),
                    decoration: const InputDecoration(
                      suffixIcon: Icon(
                        Icons.date_range,
                        color: ColorValues.fontColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                            color: ColorValues.fontColor, width: 2.0),
                      ),
                      contentPadding: EdgeInsets.all(8),
                      hintText: "_ _ - _ _ - _ _ ",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                              width: 1, color: ColorValues.lightGreyColor)),
                    ),
                    onTap: () => _showDatePicker(),
                    readOnly: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please choose valid date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (thirdHasValue == false)
                    CustomRadioButton(
                        title: "Do you have Mother Chip Number?",
                        onYesTap: () {
                          setState(() {
                            _thirdValMotherChipNumber = 1;
                          });
                        },
                        onNoTap: () {
                          setState(() {
                            _thirdValMotherChipNumber = 2;
                          });
                        },
                        value: _thirdValMotherChipNumber),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_thirdValMotherChipNumber == 1)
                    SignUpWidgets.customtextField(
                        textInputType: TextInputType.text,
                        hintText: "Add Chip Number",
                        maxLength: 15,
                        fillColor: ColorValues.lightGreyColor.withValues(alpha: 0.4),
                        filled: thirdHasValue,
                        enabled: !thirdHasValue,
                        textColor: ColorValues.fontColor,
                        textController: thirdMotherChipController,
                        sizingInformation: sizingInformation),
                  // _formContainer(sizingInformation: sizingInformation),
                  pets.isEmpty
                      ? const SizedBox()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          // addAutomaticKeepAlives: true,
                          itemCount: pets.length,
                          itemBuilder: (_, i) => pets[i],
                        ),
                  _bottom(sizingInformation: sizingInformation),
                ],
              ),
            ),
          )),
    );
  }

  _bottom({required SizingInformationModel sizingInformation}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomWidgets.buttonWithoutFontFamily(
            text: "ADD ANOTHER PUPPY",
            onPressed: () => onAddForm(),
            buttonColor: ColorValues.lightGreyColor,
            borderColor: ColorValues.lightGreyColor,
            sizingInformation: sizingInformation),
        const SizedBox(
          height: 40,
        ),
        Row(
          children: [
            CustomWidgets.iconButton(
                text: "Save as Draft",
                fontSize: 14,
                width: sizingInformation.safeBlockHorizontal * 45,
                asset: AssetValues.saveIcon,
                onPressed: () {
                  onSave(is_publish: false);
                },
                buttonColor: ColorValues.greyButtonColor,
                sizingInformation: sizingInformation),
            const Spacer(),
            CustomWidgets.buttonWithoutFontFamily(
                text: "Save & Finish",
                width: sizingInformation.safeBlockHorizontal * 30,
                onPressed: () {
                  onSave(is_publish: true);
                },
                buttonColor: ColorValues.loginBackground,
                sizingInformation: sizingInformation,
                borderColor: ColorValues.loginBackground),
          ],
        ),
      ],
    );
  }

  ///on form user deleted
  void onDelete(EditAdvertPetModel pet) {
    setState(() {
      var find = pets.firstWhere(
        (it) => it.petModel.index == pet.index,
      );
      pets.removeAt(pets.indexOf(find));
      int index = 0;
      pets = pets.map((e) {
        e.petModel.index = ++index;
        return e;
      }).toList();
    });
  }

  ///on add form
  void onAddForm() {
    setState(() {
      var _pet = EditAdvertPetModel();
      _pet.isNew = true;
      _pet.index = pets.length + 1;
      pets.add(PuppetForm(
        petModel: _pet,
        onDelete: () => onDelete(_pet),
        advert_id: widget.id.toString(),
      ));
    });
  }

  ///on save forms
  void onSave({required bool is_publish}) {
    var allValid = true;
    for (var form in pets) {
      allValid = allValid && form.isValid();
    }
    if (allValid) {
      var data = pets.map((it) => it.petModel).toList();
      if (advertIdModel.advert_id != null) {
        breederServices
            .updateStepThree(
                is_publish: is_publish,
                id: advertIdModel.advert_id,
                hasChipNumber: thirdHasValue,
                dob: thirdDateController.text,
                motherChipNumber: thirdMotherChipController.text,
                pets: data)
            .then((value) {
          if (value != null) {
            EasyLoading.showError(value);
          } else {
            EasyLoading.showSuccess(CustomStyles.saveText);
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (contex) => const BreederDashBoardScreen()));
            });
          }
        }).catchError((e) {
          EasyLoading.showError(e.toString());
        });
      } else {
        EasyLoading.showInfo("Save step 2 info first");
      }
    }
  }

  Future<void> _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _thirdPickedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorValues.loginBackground, // <-- SEE HERE
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      _thirdPickedDate = pickedDate;
      setState(() {
        thirdDateController.text = pickedDate.year.toString() +
            '-' +
            pickedDate.month.toString() +
            '-' +
            pickedDate.day.toString();
      });
    }
  }
}

