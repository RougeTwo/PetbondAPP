// ignore_for_file: file_names
import 'package:flutter/material.dart' hide DrawerButton;
import 'package:petbond_uk/core/services/secure_storage.dart';
import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/utils/validator.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petbond_uk/core/widgets/custom_drop_down_widget.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/models/breeder/micro_summary_model.dart';
import 'package:petbond_uk/models/breeder/view_model.dart';
import 'package:petbond_uk/models/shared/breed_list_model.dart';
import 'package:petbond_uk/modules/auth/signup/widgets/signup_widgets.dart';
import 'package:petbond_uk/modules/breeder/breeder_dashboard.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';
import 'package:petbond_uk/services/breeder/breeder_services.dart';
import 'package:petbond_uk/services/shared/shared_services.dart';
import '../../core/values/styles.dart';
import '../../core/widgets/base_widget.dart';
import '../../core/widgets/drawer_buttons.dart' as custom;
import '../../core/widgets/shared/header.dart';
import 'advertise_pet/advertise_pet_step_two_create.dart';
import 'breeder_account_setting.dart';
import 'breeder_listed_pets.dart';
import 'breeder_my_sale.dart';
import 'chat/breeder_message_list.dart';
import 'edit_bio.dart';

class BreederProfileSetting extends StatefulWidget {
  const BreederProfileSetting({Key? key}) : super(key: key);

  @override
  State<BreederProfileSetting> createState() => _BreederProfileSettingState();
}

class _BreederProfileSettingState extends State<BreederProfileSetting> {
  TextEditingController kenneyClubController = TextEditingController();
  TextEditingController registrationController = TextEditingController();
  TextEditingController licenceController = TextEditingController();
  TextEditingController chipController = TextEditingController();
  BreederServices breederServices = BreederServices();
  SharedServices sharedServices = SharedServices();
  ViewModel? viewModel;
  final key = GlobalKey<FormState>();
  final licenseKey = GlobalKey<FormState>();
  bool viewModelLoading = false;
  List<MicroChipSummaryModel> microchipSummaryList = [];
  List<BreedListModel> breedList = [];
  String _selectedBreed = "Select breed";
  SecureStorage secureStorage = SecureStorage();
  AuthServices authServices = AuthServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    breederServices.getViewModel(context: context).then((value) {
      if (mounted) {
        setState(() {
          viewModel = value;
          _assignValues();
          viewModelLoading = true;
        });
      }
    });
  }

  _assignValues() {
    if (viewModel!.detail != null) {
      if (viewModel!.detail!.reg_number != null) {
        registrationController.text = viewModel!.detail!.reg_number!;
      }
      if (viewModel!.detail!.local_council != null) {
        licenceController.text = viewModel!.detail!.local_council!;
      }
      if (viewModel!.detail!.kenney_club != null) {
        kenneyClubController.text = viewModel!.detail!.kenney_club!;
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
            //  appBar: CustomWidgets().appBarWidget(context),
            // key: scaffoldKey,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomWidgets.cardTitle(title: "Profile Information"),
            const Text(
              "Please complete your bio information to attract the most attention for your litter",
              style: TextStyle(fontFamily: "NotoSans"),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Profile Picture"),
            const SizedBox(
              height: 10,
            ),
            viewModelLoading
                ? loaded(sizingInformation: sizingInformation)
                : CustomWidgets.box(sizingInformation: sizingInformation),
          ],
        ));
  }

  loaded({required SizingInformationModel sizingInformation}) {
    return Column(
      children: [
        _profileContainer(sizingInformation: sizingInformation),
        const SizedBox(
          height: 10,
        ),
        _bioContainer(sizingInformation: sizingInformation),
        const SizedBox(
          height: 30,
        ),
        _licenseContainer(sizingInformation: sizingInformation),
        const SizedBox(
          height: 30,
        ),
        _breedBitchesContainer(sizingInformation: sizingInformation)
      ],
    );
  }

  _profileContainer({required SizingInformationModel sizingInformation}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        viewModel!.avatar == null
            ? SvgPicture.asset(
                AssetValues.profileIcon,
                width: sizingInformation.safeBlockHorizontal * 50,
                height: sizingInformation.safeBlockHorizontal * 50,
                fit: BoxFit.cover,
              )
            : CustomWidgets.customNetworkImage(
                imageUrl:
                    BaseUrl.getImageBaseUrl() + viewModel!.avatar.toString(),
                sizingInformation: sizingInformation),
      ],
    );
  }

  _bioContainer({required SizingInformationModel sizingInformation}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(
              child: Text(
                "Your bio",
                style: TextStyle(
                    fontFamily: "NotoSans",
                    fontSize: 18,
                    color: ColorValues.fontColor),
              ),
            ),
            CustomWidgets.iconButton(
                text: "Edit bio",
                width: sizingInformation.safeBlockHorizontal * 30,
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BreederEditBio()))
                      .then((value) {
                    breederServices
                        .getViewModel(context: context)
                        .then((value) {
                      if (mounted) {
                        setState(() {
                          viewModel = value;
                          viewModelLoading = true;
                        });
                      }
                    });
                  });
                },
                buttonColor: ColorValues.lightGreyColor,
                asset: AssetValues.editIcon,
                sizingInformation: sizingInformation),
          ],
        ),
        const Divider(
          thickness: 2,
          color: ColorValues.fontColor,
        ),
        const SizedBox(
          height: 10,
        ),
        viewModel!.detail != null
            ? viewModel!.detail!.bio == null
                ? const Text("Add bio")
                : Text(
                    viewModel!.detail!.bio.toString(),
                    style: const TextStyle(fontFamily: "NotoSans"),
                  )
            : const Text("Add bio"),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  _licenseContainer({required SizingInformationModel sizingInformation}) {
    return Form(
      key: licenseKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Licensing information",
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
          const Text("Animal activities license number"),
          const SizedBox(
            height: 10,
          ),
          SignUpWidgets.customtextField(
              textInputType: TextInputType.text,
              hintText: "Registration number...",
              textColor: ColorValues.fontColor,
              validator: Validator.validateEmptyFiled,
              textController: registrationController,
              sizingInformation: sizingInformation),
          const SizedBox(
            height: 5,
          ),
          const Text("Kennel Club Membership ID",
              style: CustomStyles.textStyle),
          const SizedBox(
            height: 10,
          ),
          SignUpWidgets.customtextField(
              textInputType: TextInputType.text,
              hintText: "Kennel Club id...",
              textColor: ColorValues.fontColor,
              textController: kenneyClubController,
              sizingInformation: sizingInformation),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: CustomWidgets.iconButton(
                text: "Save",
                onPressed: () {
                  if (registrationController.text.isNotEmpty ||
                      licenceController.text.isNotEmpty) {
                    if (licenseKey.currentState!.validate()) {
                      breederServices.breederUpdateLicenceInfo(
                          local_council: licenceController.text,
                          reg_number: registrationController.text,
                          kenney_club: kenneyClubController.text,
                          context: context);
                    }
                  } else {
                    breederServices.breederUpdateLicenceInfo(
                        local_council: licenceController.text,
                        reg_number: registrationController.text,
                        kenney_club: kenneyClubController.text,
                        context: context);
                  }
                },
                width: sizingInformation.safeBlockHorizontal * 30,
                buttonColor: ColorValues.fontColor,
                asset: AssetValues.saveIcon,
                sizingInformation: sizingInformation),
          )
        ],
      ),
    );
  }

  _breedBitchesContainer({required SizingInformationModel sizingInformation}) {
    return Form(
      key: key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Breeding Female Dogs attached to account",
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
          SignUpWidgets.customtextField(
              textInputType: TextInputType.number,
              hintText: "Chip number...",
              textController: chipController,
              maxLength: 15,
              validator: Validator.validateChipName,
              sizingInformation: sizingInformation),
          const SizedBox(
            height: 10,
          ),
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
          const SizedBox(
            height: 10,
          ),
          CustomWidgets.buttonWithoutFontFamily(
              text: "Add Breeding Female Dog chip number",
              onPressed: () {
                breederServices.breederAddMicroChipInfo(
                  chip_number: chipController.text,
                  breed_id: breedList
                      .where((element) => element.name == _selectedBreed)
                      .first
                      .id
                      .toString(),
                  context: context,
                );
                setState(() {});
              },
              buttonColor: ColorValues.fontColor,
              borderColor: ColorValues.fontColor,
              sizingInformation: sizingInformation),
          const SizedBox(
            height: 9,
          ),
          FutureBuilder(
              future: breederServices.getMicroChipList(context: context),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: SizedBox());
                } else {
                  microchipSummaryList =
                      snapshot.data as List<MicroChipSummaryModel>;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${snapshot.data.length}" " Breeding Female Dogs added to account",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorValues.fontColor),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                "${microchipSummaryList[index].chip_number}" " has had " " ${microchipSummaryList[index].breeding_count}" " out of 3 liters",
                                style: TextStyle(
                                    color: microchipSummaryList[index]
                                                .breeding_count ==
                                            3
                                        ? Colors.red
                                        : ColorValues.darkerGreyColor),
                              ),
                            );
                          }),
                    ],
                  );
                }
              }),
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdvertisePetStepTwoCreate(
                            behaviour: 'create',
                            id: null,
                          )));
            },
            buttonColor: Colors.white.withValues(alpha: 0.25),
            btnLable: "Sell a pet"),
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

