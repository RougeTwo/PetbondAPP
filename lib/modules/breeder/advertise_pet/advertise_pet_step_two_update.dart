import 'dart:io';
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/services/secure_storage.dart';
import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:petbond_uk/core/utils/helper.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/core/widgets/custom_radio_button.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/core/widgets/base_widget.dart';
import 'package:petbond_uk/core/widgets/drawer_buttons.dart';
import 'package:petbond_uk/core/widgets/shared/header.dart';
import 'package:petbond_uk/models/breeder/advert_sale/advert_id.dart';
import 'package:petbond_uk/models/breeder/edit_advert/get_edit_advert_model.dart';
import 'package:petbond_uk/models/shared/examinations.dart';
import 'package:petbond_uk/modules/auth/signup/widgets/signup_widgets.dart';
import 'package:petbond_uk/services/breeder/breeder_services.dart';
import 'package:petbond_uk/services/connect_account/connect_services.dart';
import 'package:petbond_uk/services/shared/shared_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../core/utils/validator.dart';
import '../../../models/breeder/edit_advert/edit_advert_pets.dart';
import '../../../models/breeder/view_model.dart';
import '../../../models/shared/breed_list_model.dart';
import '../../../services/auth/auth_services.dart';
import '../breeder-profile_setting.dart';
import '../breeder_account_setting.dart';
import '../breeder_dashboard.dart';
import '../breeder_listed_pets.dart';
import '../breeder_my_sale.dart';
import '../chat/breeder_message_list.dart';
import 'advertise_pet_step_one.dart';
import 'helper/puppet_form.dart';

class AdvertisePetStepTwoUpdate extends StatefulWidget {
  final String behaviour;
  final int? id;

  const AdvertisePetStepTwoUpdate({Key? key, required this.behaviour, this.id})
      : super(key: key);

  @override
  _AdvertisePetStepTwoUpdateState createState() =>
      _AdvertisePetStepTwoUpdateState();
}

class _AdvertisePetStepTwoUpdateState extends State<AdvertisePetStepTwoUpdate> {
  SecureStorage secureStorage = SecureStorage();
  bool showExaminationData = false;
  int motherHealth = 2;
  int? examinationId;
  int fatherHealth = 2;
  bool checked = false;
  List<ExaminationModel> userChecked = [];
  TextStyle style = const TextStyle(color: ColorValues.greyTextColor);
  TextEditingController breeIdController = TextEditingController();
  TextEditingController advertNameController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  SharedServices sharedServices = SharedServices();
  List<ExaminationModel>? examinationList;
  List<String> motherExaminations = List.empty(growable: true);
  List<String> fatherExaminations = List.empty(growable: true);
  GetEditAdvertModel getEditAdvertModel = GetEditAdvertModel();
  File? _coverImage;
  AdvertIdModel advertIdModel = AdvertIdModel();
  File? motherReportImage;
  List<File?> _motherReportsList = [];
  File? fatherReportImage;
  List<String> deleteMotherImages = [];
  List<BreedListModel> breedList = [];
  List<String> deleteFatherImages = [];
  final List<File?> _fatherReportsList = [];
  BreederServices breederServices = BreederServices();
  ConnectServices connectServices = ConnectServices();
  AuthServices authServices = AuthServices();
  String? qrImage;
  bool imageLoaded = false;
  ScrollController scrollController = ScrollController();
  int _valKennyClub = 2;
  int _valRegistration = 2;
  ViewModel? viewModel;
  XFile? _image;
  final _imagePicker = ImagePicker();
  TextEditingController kennyClubController = TextEditingController();
  TextEditingController registrationController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool viewModelLoading = false;
  int i = 2;
  DateTime? _thirdPickedDate;
  List<PuppetForm> pets = [];
  TextStyle style0 = TextStyle(color: ColorValues.greyTextColor, fontSize: 16);
  TextEditingController thirdDateController = TextEditingController();
  TextEditingController thirdMotherChipController = TextEditingController();
  bool thirdImageLoaded = false;
  bool thirdHasValue = false;
  int _thirdValMotherChipNumber = 2;

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
      if (viewModel!.detail!.bio != null) {
        bioController.text = viewModel!.detail!.bio!;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callApis();
  }

  callApis() async {
    await breederServices.getViewModel(context: context).then((value) {
      setState(() {
        viewModel = value;
        _assignFirstStepValues();
      });
    });
    await sharedServices.getExaminationList(context: context).then((value) {
      if (value != null) {
        setState(() {
          examinationList = value;
          showExaminationData = true;
        });
      }
    });
    await breederServices
        .getEditAdvertList(context: context, advert_id: widget.id)
        .then((value) {
      if (value != null) {
        setState(() {
          getEditAdvertModel = value;
          _assignValue();
        });
      }
    });
    await breederServices
        .getEditAdvertList(context: context, advert_id: widget.id)
        .then((value) {
      if (value != null) {
        setState(() {
          viewModelLoading = true;
          getEditAdvertModel = value;
          if (getEditAdvertModel.dob != null) {
            thirdDateController.text = getEditAdvertModel.dob.toString();
          }
          if (getEditAdvertModel.chip_number != null) {
            thirdMotherChipController.text =
                getEditAdvertModel.chip_number.toString();
            _thirdValMotherChipNumber = 1;
            thirdHasValue = true;
          }
          if (getEditAdvertModel.pets != null) {
            getEditAdvertModel.pets!.forEach((element) {
              EditAdvertPetModel _pet = element;
              _pet.isNew = false;
              _pet.index = pets.length + 1;
              pets.add(PuppetForm(
                petModel: _pet,
                onDelete: () => onDelete(_pet),
                advert_id: widget.id.toString(),
              ));
            });
          }
          if (pets.isEmpty) {
            onAddForm();
          }
        });
      }
    });
  }

  _assignValue() {
    if (getEditAdvertModel != null) {
      if (getEditAdvertModel.advert_name != null) {
        advertNameController.text = getEditAdvertModel.advert_name!;
      }
      if (getEditAdvertModel.description != null) {
        descriptionController.text = getEditAdvertModel.description!;
      }
      if (getEditAdvertModel.mother_name != null) {
        motherNameController.text = getEditAdvertModel.mother_name!;
      }
      if (getEditAdvertModel.father_name != null) {
        fatherNameController.text = getEditAdvertModel.father_name!;
      }
      if (getEditAdvertModel.breed_id != null) {
        sharedServices.getBreedList(context: context).then((value) {
          breedList = value;

          breeIdController.text = breedList
              .where((element) => element.id == getEditAdvertModel.breed_id)
              .first
              .name;
        });
      }
      if (getEditAdvertModel.mother_advert_examinations!.isNotEmpty ||
          (getEditAdvertModel.test_report_detail != null &&
              getEditAdvertModel
                  .test_report_detail!.mother_reports!.isNotEmpty)) {
        setState(() {
          motherHealth = 1;
        });
      }
      if (getEditAdvertModel.father_advert_examinations!.isNotEmpty ||
          (getEditAdvertModel.test_report_detail != null &&
              getEditAdvertModel
                  .test_report_detail!.father_reports!.isNotEmpty)) {
        setState(() {
          fatherHealth = 1;
        });
      }

      if (getEditAdvertModel.mother_advert_examinations != null) {
        List<String> temp = List.empty(growable: true);
        getEditAdvertModel.mother_advert_examinations?.forEach((element) {
          temp.add(element.examination_id.toString());
        });
        setState(() {
          motherExaminations = temp;
        });
      }
      if (getEditAdvertModel.father_advert_examinations != null) {
        List<String> temp2 = List.empty(growable: true);
        getEditAdvertModel.father_advert_examinations?.forEach((element) {
          temp2.add(element.examination_id.toString());
        });
        setState(() {
          fatherExaminations = temp2;
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
              widget: viewModelLoading
                  ? Column(
                      children: [
                        _introductionSection(
                            sizingInformation: sizingInformation),
                        SizedBox(
                          height: 20,
                        ),
                        _firstStepUpdate(sizingInformation: sizingInformation),
                        SizedBox(
                          height: 20,
                        ),
                        _secondStepUpdate(sizingInformation: sizingInformation),
                        SizedBox(
                          height: 20,
                        ),
                        _thirdStepUpdate(sizingInformation: sizingInformation)
                      ],
                    )
                  : _loadingSection(sizingInformation: sizingInformation),
              sizingInformation: sizingInformation,
            ));
      },
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
                  Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  _secondformContainer(sizingInformation: sizingInformation)
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
                  Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Text(
                          "To create your advert fill out the next three steps, after you complete each section press save and continue."),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            AssetValues.purpleLogo,
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(" Step 1: Others Details"),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            AssetValues.purpleLogo,
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(" Step 2: Advert Details"),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            AssetValues.purpleLogo,
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(" Step 3: Puppy Liters Details"),
                        ],
                      ),
                      SizedBox(
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

  _loadingSection({required SizingInformationModel sizingInformation}) {
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
                  Center(
                    child: Row(
                      children: [
                        const Text(
                          "No Data Found.",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 300,
                  ),
                ],
              ),
            ),
          )),
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
                  Divider(),
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

  _secondformContainer({required SizingInformationModel sizingInformation}) {
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
          TextFormField(
            controller: descriptionController,
            minLines: 4,
            maxLines: 10,
            textAlignVertical: TextAlignVertical.top,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style:
                const TextStyle(fontSize: 15.0, color: ColorValues.fontColor),
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
          // Text(
          //   "Microchip number of mother of litter...",
          //   style: style,
          // ),
          const SizedBox(
            height: 12,
          ),
          SignUpWidgets.customtextField(
              textInputType: TextInputType.text,
              filled: true,
              fillColor: ColorValues.lightGreyColor.withOpacity(0.4),
              hintText: "Select Breed",
              enabled: false,
              suffixIcon: Icon(Icons.arrow_drop_down),
              textController: breeIdController,
              sizingInformation: sizingInformation),
          // const SizedBox(
          //   height: 12,
          // ),
          // Center(
          //   child: Text(
          //     "(OR)",
          //     style: style,
          //   ),
          // ),
          // const SizedBox(
          //   height: 12,
          // ),
          // Align(
          //   alignment: Alignment.center,
          //   child: CustomWidgets.buttonWithoutFontFamily(
          //       text: "*Add New Chip Number",
          //       onPressed: () {},
          //       buttonColor: ColorValues.loginBackground.withOpacity(0.7),
          //       borderColor: ColorValues.loginBackground.withOpacity(0.7),
          //       sizingInformation: sizingInformation),
          // ),
          const SizedBox(
            height: 15,
          ),
          CustomRadioButton(
              onYesTap: () {
                setState(() {
                  motherHealth = 1;
                });
              },
              onNoTap: () {
                if (getEditAdvertModel.test_report_detail != null) {
                  for (var i in getEditAdvertModel
                      .test_report_detail!.mother_reports) {
                    var arr = i.split(BaseUrl.getImageBaseUrl());
                    deleteMotherImages.add(arr[1]);
                  }
                }
                setState(() {
                  motherHealth = 2;
                  motherExaminations = [];
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
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              String id = examinationList![index].id.toString();
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
                                    BorderRadius.all(Radius.circular(6)),
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 4),
                  )
                : const SizedBox(),
          const SizedBox(
            height: 10,
          ),
          if (motherHealth == 1)
            _motherReportWidget(sizingInformation: sizingInformation),
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
                if (getEditAdvertModel.test_report_detail != null) {
                  for (var i in getEditAdvertModel
                      .test_report_detail!.father_reports) {
                    var arr = i.split(BaseUrl.getImageBaseUrl());
                    deleteFatherImages.add(arr[1]);
                  }
                }

                setState(() {
                  fatherHealth = 2;
                  fatherExaminations = [];
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
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              String id = examinationList![index].id.toString();
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
                                    BorderRadius.all(Radius.circular(6)),
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 4),
                  )
                : const SizedBox(),
          const SizedBox(
            height: 10,
          ),
          if (fatherHealth == 1)
            _fatherReportWidget(sizingInformation: sizingInformation),
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
              //     breederServices
              //         .updateBreederAdvert(
              //             advert_name: advertNameController.text,
              //             mother_name: motherNameController.text,
              //             father_name: fatherNameController.text,
              //             description: descriptionController.text,
              //             delete_mother_report_details: deleteMotherImages,
              //             coverImage:
              //                 _coverImage != null ? _coverImage!.path : null,
              //             is_publish: null,
              //             context: context,
              //             id: widget.id,
              //             mother_reports: _motherReportsList.length > 0
              //                 ? _motherReportsList
              //                 : [],
              //             father_reports: _fatherReportsList.length > 0
              //                 ? _fatherReportsList
              //                 : [],
              //             delete_father_report_details: deleteFatherImages,
              //             father_test: fatherExaminations,
              //             mother_test: motherExaminations)
              //         .then((value) {
              //       if (value != null) {
              //         EasyLoading.showError(value);
              //       } else {
              //         EasyLoading.showSuccess(CustomStyles.save_text);
              //         Future.delayed(Duration(seconds: 1), () {
              //           Navigator.pushReplacement(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => AdvertisePetStepOne(
              //                         behaviour: widget.behaviour,
              //                         id: widget.id,
              //                       )));
              //         });
              //       }
              //     }).catchError((e) {
              //       EasyLoading.showError(e.toString());
              //     });
              //   },
              //   icon: const Icon(
              //     Icons.arrow_back,
              //     color: ColorValues.loginBackground,
              //     size: 28,
              //   ),
              // ),
              CustomWidgets.iconButton(
                  text: "Save as Draft",
                  fontSize: 14,
                  width: sizingInformation.safeBlockHorizontal * 45,
                  asset: AssetValues.saveIcon,
                  onPressed: () {
                    breederServices
                        .updateBreederAdvert(
                            advert_name: advertNameController.text,
                            mother_name: motherNameController.text,
                            father_name: fatherNameController.text,
                            description: descriptionController.text,
                            delete_mother_report_details: deleteMotherImages,
                            coverImage:
                                _coverImage != null ? _coverImage!.path : null,
                            is_publish: false,
                            context: context,
                            id: widget.id,
                            mother_reports: _motherReportsList.length > 0
                                ? _motherReportsList
                                : [],
                            father_reports: _fatherReportsList.length > 0
                                ? _fatherReportsList
                                : [],
                            delete_father_report_details: deleteFatherImages,
                            father_test: fatherExaminations,
                            mother_test: motherExaminations)
                        .then((value) {
                      if (value != null) {
                        EasyLoading.showError(value);
                      } else {
                        EasyLoading.showSuccess(CustomStyles.save_text);
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) =>
                                      BreederDashBoardScreen()));
                        });
                      }
                    }).catchError((e) {
                      EasyLoading.showError(e.toString());
                    });
                  },
                  buttonColor: ColorValues.greyButtonColor,
                  sizingInformation: sizingInformation),
              Spacer(),
              CustomWidgets.buttonWithoutFontFamily(
                  text: "Save & C.",
                  width: 30,
                  onPressed: () {
                    breederServices
                        .updateBreederAdvert(
                            advert_name: advertNameController.text,
                            mother_name: motherNameController.text,
                            father_name: fatherNameController.text,
                            description: descriptionController.text,
                            delete_mother_report_details: deleteMotherImages,
                            coverImage:
                                _coverImage != null ? _coverImage!.path : null,
                            is_publish: null,
                            context: context,
                            id: widget.id,
                            mother_reports: _motherReportsList.length > 0
                                ? _motherReportsList
                                : [],
                            father_reports: _fatherReportsList.length > 0
                                ? _fatherReportsList
                                : [],
                            delete_father_report_details: deleteFatherImages,
                            father_test: fatherExaminations,
                            mother_test: motherExaminations)
                        .then((value) {
                      if (value != null) {
                        EasyLoading.showError(value);
                      } else {
                        EasyLoading.showSuccess(CustomStyles.save_text);
                      }
                    }).catchError((e) {
                      EasyLoading.showError(e.toString());
                    });
                  },
                  buttonColor: ColorValues.loginBackground,
                  sizingInformation: sizingInformation,
                  borderColor: ColorValues.loginBackground),
            ],
          )
        ],
      ),
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
              title: "Do you have a Irish Kennel Club Membership ID",
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
                    url: "${BaseUrl.getBaseUrl()}" +
                        "breeder/profile/info/update",
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

  _profileContainer({required SizingInformationModel sizingInformation}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "Upload main advert image",
            style: style,
          ),
          const SizedBox(
            height: 10,
          ),
          _coverImage == null
              ? getEditAdvertModel.cover_photo == null
                  ? SvgPicture.asset(
                      AssetValues.profileIcon,
                      width: sizingInformation.safeBlockHorizontal * 50,
                      height: sizingInformation.safeBlockHorizontal * 50,
                      fit: BoxFit.cover,
                    )
                  : CustomWidgets.customNetworkImage(
                      imageUrl: BaseUrl.getImageBaseUrl() +
                          getEditAdvertModel.cover_photo!,
                      sizingInformation: sizingInformation)
              : ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Image(
                      width: sizingInformation.safeBlockHorizontal * 50,
                      height: sizingInformation.safeBlockHorizontal * 45,
                      fit: BoxFit.cover,
                      image: FileImage(File(_coverImage!.path))),
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

  //================mother image section=========================
  _motherReportWidget({required SizingInformationModel sizingInformation}) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        _addNewMotherImageWidget(sizingInformation: sizingInformation),
        if (motherReportImage != null)
          SizedBox(
            height: sizingInformation.safeBlockHorizontal * 5,
          ),
        if (motherReportImage != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomWidgets.buttonWithoutFontFamily(
                sizingInformation: sizingInformation,
                text: 'Cancel',
                width: sizingInformation.safeBlockHorizontal * 25,
                onPressed: () => setState(() => motherReportImage = null),
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
                  _motherReportsList.insert(0, motherReportImage);
                  motherReportImage = null;
                }),
              ),
            ],
          ),
        if (_motherReportsList.length > 0 ||
            (getEditAdvertModel.test_report_detail != null))
          if ((_motherReportsList.length > 0 ||
                  (getEditAdvertModel
                              .test_report_detail!.mother_reports.length ??
                          0) >
                      0) &&
              motherReportImage == null)
            SizedBox(
              height: sizingInformation.safeBlockHorizontal * 7,
            ),
        if (_motherReportsList.length > 0 ||
            (getEditAdvertModel.test_report_detail != null))
          if ((_motherReportsList.length > 0 ||
                  (getEditAdvertModel
                              .test_report_detail!.mother_reports.length ??
                          0) >
                      0) &&
              motherReportImage == null)
            Scrollbar(
              controller: scrollController,
              isAlwaysShown: true,
              radius: Radius.circular(10),
              child: SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  children: [
                    for (File? image in _motherReportsList)
                      _buildMotherImageBox(
                          sizingInformation: sizingInformation,
                          image: image,
                          isNetworkImage: false),
                    if (getEditAdvertModel.test_report_detail != null)
                      for (String imageUrl in getEditAdvertModel
                          .test_report_detail!.mother_reports)
                        _buildMotherImageBox(
                            sizingInformation: sizingInformation,
                            image: imageUrl,
                            isNetworkImage: true),
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
      {required SizingInformationModel sizingInformation}) {
    return Center(
      child: GestureDetector(
        onTap: () => motherReportImage != null
            ? null
            : _showBottomModalPicker(context, sizingInformation, "mother"),
        child: motherReportImage != null
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
                    image: FileImage(File(motherReportImage!.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    color: ColorValues.lighBlueButton,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text("UPLOAD MOTHER REPORTS",
                          style: TextStyle(
                            color: ColorValues.fontColor,
                            fontWeight: FontWeight.normal,
                          )),
                      Spacer(),
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

  Widget _buildMotherImageBox(
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
              child: Container(
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
                    ? getEditAdvertModel.test_report_detail!.mother_reports!
                        .remove(image)
                    : _motherReportsList.remove(image);
              });
              if (isNetworkImage == true) {
                String str = image.toString();

                //split string
                var arr = str.split(BaseUrl.getImageBaseUrl());
                deleteMotherImages.add(arr[1]);
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

  //================Father image section===============
  _fatherReportWidget({required SizingInformationModel sizingInformation}) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        _addNewFatherImageWidget(sizingInformation: sizingInformation),
        if (fatherReportImage != null)
          SizedBox(
            height: sizingInformation.safeBlockHorizontal * 5,
          ),
        if (fatherReportImage != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomWidgets.buttonWithoutFontFamily(
                sizingInformation: sizingInformation,
                text: 'Cancel',
                width: sizingInformation.safeBlockHorizontal * 25,
                onPressed: () => setState(() => fatherReportImage = null),
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
                  _fatherReportsList.insert(0, fatherReportImage);
                  fatherReportImage = null;
                }),
              ),
            ],
          ),
        if (_fatherReportsList.isNotEmpty ||
            (getEditAdvertModel.test_report_detail != null))
          if ((_fatherReportsList.isNotEmpty ||
                  (getEditAdvertModel
                              .test_report_detail!.father_reports?.length ??
                          0) >
                      0) &&
              fatherReportImage == null)
            SizedBox(
              height: sizingInformation.safeBlockHorizontal * 7,
            ),
        if (_fatherReportsList.isNotEmpty ||
            (getEditAdvertModel.test_report_detail != null))
          if ((_fatherReportsList.isNotEmpty ||
                  (getEditAdvertModel
                              .test_report_detail!.father_reports?.length ??
                          0) >
                      0) &&
              fatherReportImage == null)
            Scrollbar(
              controller: scrollController,
              isAlwaysShown: true,
              radius: Radius.circular(10),
              child: SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  children: [
                    for (File? image in _fatherReportsList)
                      _buildFatherImageBox(
                          sizingInformation: sizingInformation,
                          image: image,
                          isNetworkImage: false),
                    if (getEditAdvertModel.test_report_detail != null)
                      for (String imageUrl in getEditAdvertModel
                          .test_report_detail!.father_reports!)
                        _buildFatherImageBox(
                            sizingInformation: sizingInformation,
                            image: imageUrl,
                            isNetworkImage: true),
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
      {required SizingInformationModel sizingInformation}) {
    return Center(
      child: GestureDetector(
        onTap: () => fatherReportImage != null
            ? null
            : _showBottomModalPicker(context, sizingInformation, "father"),
        child: fatherReportImage != null
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
                    image: FileImage(File(fatherReportImage!.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(
                decoration: const BoxDecoration(
                    color: ColorValues.lighBlueButton,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text("UPLOAD FATHER REPORTS",
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

  Widget _buildFatherImageBox(
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
              child: Container(
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
                    ? getEditAdvertModel.test_report_detail!.father_reports!
                        .remove(image)
                    : _fatherReportsList.remove(image);
              });
              if (isNetworkImage == true) {
                String str = image.toString();
                var arr = str.split(BaseUrl.getImageBaseUrl());
                deleteFatherImages.add(arr[1]);
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

  void _showBottomModalPicker(BuildContext context,
      SizingInformationModel sizingInformationModel, String role) {
    showModalBottomSheet(
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
          motherReportImage = file;
        });
        return motherReportImage;
      }
      if (role == "father") {
        setState(() {
          fatherReportImage = file;
        });
        return fatherReportImage;
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
            },
            buttonColor: ColorValues.loginBackground,
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
                  Divider(),
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
                      focusedBorder: const OutlineInputBorder(
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
                        fillColor: ColorValues.lightGreyColor.withOpacity(0.4),
                        filled: thirdHasValue,
                        enabled: !thirdHasValue,
                        textColor: ColorValues.fontColor,
                        textController: thirdMotherChipController,
                        sizingInformation: sizingInformation),
                  // _formContainer(sizingInformation: sizingInformation),
                  Text("Puppies", style: style),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        AssetValues.yellowLogo,
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Text(
                          " You must \"Add a Puppy\" for each individual pup in the litter",
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        AssetValues.yellowLogo,
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  pets.isEmpty
                      ? SizedBox()
                      : ListView.builder(
                          shrinkWrap: true,
                          controller: ScrollController(),
                          physics: ScrollPhysics(),
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
            text: "Add a Puppy",
            onPressed: () => onAddForm(),
            buttonColor: ColorValues.fontColor,
            borderColor: ColorValues.fontColor,
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
      if (find != null) pets.removeAt(pets.indexOf(find));
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
    pets.forEach((form) => allValid = allValid && form.isValid());
    if (allValid) {
      var data = pets.map((it) => it.petModel).toList();
      breederServices
          .updateStepThree(
              is_publish: is_publish,
              id: widget.id,
              hasChipNumber: thirdHasValue,
              dob: thirdDateController.text,
              motherChipNumber: thirdMotherChipController.text,
              pets: data)
          .then((value) {
        if (value != null) {
          EasyLoading.showError(value);
        } else {
          EasyLoading.showSuccess(CustomStyles.save_text);
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (contex) => BreederDashBoardScreen()));
          });
        }
      }).catchError((e) {
        EasyLoading.showError(e.toString());
      });
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
