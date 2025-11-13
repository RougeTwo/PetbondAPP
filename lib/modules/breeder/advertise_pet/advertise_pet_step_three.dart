// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart' hide DrawerButton;
import 'package:petbond_uk/core/services/secure_storage.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/core/widgets/base_widget.dart';
import 'package:petbond_uk/core/widgets/shared/header.dart';
import 'package:petbond_uk/models/breeder/edit_advert/edit_advert_pets.dart';
import 'package:petbond_uk/models/breeder/edit_advert/get_edit_advert_model.dart';
import 'package:petbond_uk/modules/breeder/breeder_dashboard.dart';
import 'package:petbond_uk/services/breeder/breeder_services.dart';
import 'package:petbond_uk/services/connect_account/connect_services.dart';
import '../../../core/widgets/custom_radio_button.dart';
import '../../../services/auth/auth_services.dart';
import '../../auth/signup/widgets/signup_widgets.dart';
import '../chat/breeder_message_list.dart';
import 'advertise_pet_step_two_update.dart';
import 'helper/puppet_form.dart';
import '../breeder-profile_setting.dart';
import '../breeder_account_setting.dart';
import 'package:petbond_uk/core/widgets/drawer_buttons.dart' as custom;
import '../breeder_listed_pets.dart';
import '../breeder_my_sale.dart';

class AdvertisePetStepThree extends StatefulWidget {
  final String behaviour;
  final int? id;

  const AdvertisePetStepThree({Key? key, required this.behaviour, this.id})
      : super(key: key);

  @override
  _AdvertisePetStepThreeState createState() => _AdvertisePetStepThreeState();
}

class _AdvertisePetStepThreeState extends State<AdvertisePetStepThree> {
  int i = 2;
  DateTime? _thirdPickedDate;
  SecureStorage secureStorage = SecureStorage();
  ConnectServices connectServices = ConnectServices();
  AuthServices authServices = AuthServices();
  List<PuppetForm> pets = [];
  GetEditAdvertModel getEditAdvertModel = GetEditAdvertModel();
  BreederServices breederServices = BreederServices();
  TextStyle style = const TextStyle(color: ColorValues.greyTextColor);
  TextStyle style0 = const TextStyle(color: ColorValues.greyTextColor, fontSize: 16);
  TextEditingController thirdDateController = TextEditingController();
  TextEditingController thirdMotherChipController = TextEditingController();
  String? qrImage;
  bool thirdImageLoaded = false;
  bool thirdHasValue = false;
  int _thirdValMotherChipNumber = 2;

  readQR() async {
    qrImage = await secureStorage.readStore('qr_code');
    if (qrImage != null) {
      setState(() {
        thirdImageLoaded = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    breederServices
        .getEditAdvertList(context: context, advert_id: widget.id)
        .then((value) {
      if (value != null) {
        setState(() {
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
            for (var element in getEditAdvertModel.pets!) {
              EditAdvertPetModel _pet = element;
              _pet.isNew = false;
              _pet.index = pets.length + 1;
              pets.add(PuppetForm(
                petModel: _pet,
                onDelete: () => onDelete(_pet),
                advert_id: widget.id.toString(),
              ));
            }
          }
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
          Text("Puppy litter details:", style: style0),
          const SizedBox(
            height: 8,
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
            style:
                const TextStyle(fontSize: 15.0, color: ColorValues.fontColor),
            decoration: const InputDecoration(
              suffixIcon: Icon(
                Icons.date_range,
                color: ColorValues.fontColor,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide:
                    BorderSide(color: ColorValues.fontColor, width: 2.0),
              ),
              contentPadding: EdgeInsets.all(8),
              hintText: "_ _ - _ _ - _ _ ",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide:
                      BorderSide(width: 1, color: ColorValues.lightGreyColor)),
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
    );
  }

  _bioContainer({required SizingInformationModel sizingInformation}) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Step 3 of 3",
              style: TextStyle(
                  fontFamily: "NotoSans",
                  fontSize: 16,
                  color: ColorValues.fontColor),
            ),
            Spacer(),
            Row(
              children: [
                CircleAvatar(
                  radius: 4,
                  backgroundColor: ColorValues.fontColor,
                ),
                SizedBox(
                  width: 3,
                ),
                CircleAvatar(
                  radius: 4,
                  backgroundColor: ColorValues.fontColor,
                ),
                SizedBox(
                  width: 3,
                ),
                CircleAvatar(
                  radius: 4,
                  backgroundColor: ColorValues.fontColor,
                ),
                SizedBox(
                  width: 2,
                ),
              ],
            )
          ],
        ),
        Divider(
          thickness: 2,
          color: ColorValues.fontColor,
        ),
        SizedBox(
          height: 10,
        ),
      ],
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
            IconButton(
              onPressed: () {
                onBack();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: ColorValues.loginBackground,
                size: 28,
              ),
            ),
            const Spacer(),
            CustomWidgets.iconButton(
                text: "Save",
                fontSize: 14,
                width: sizingInformation.safeBlockHorizontal * 30,
                asset: AssetValues.saveIcon,
                onPressed: () {
                  onSave(is_publish: false);
                },
                buttonColor: ColorValues.greyButtonColor,
                sizingInformation: sizingInformation),
            const Spacer(),
            CustomWidgets.buttonWithoutFontFamily(
                text: "Finish",
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
    }
  }

  void onBack() {
    if (pets.isNotEmpty) {
      var data = pets.map((it) => it.petModel).toList();
      breederServices
          .updateStepThree(
              is_publish: null,
              hasChipNumber: thirdHasValue,
              id: widget.id,
              dob: thirdDateController.text,
              motherChipNumber: thirdMotherChipController.text,
              pets: data)
          .then((value) {
        if (value != null) {
          EasyLoading.showError(value);
        } else {
          EasyLoading.showSuccess(CustomStyles.saveText);
          Future.delayed(Duration.zero, () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AdvertisePetStepTwoUpdate(
                        behaviour: "edit", id: widget.id)));
          });
        }
      }).catchError((e) {
        EasyLoading.showError(e.toString());
      });
    } else {
      breederServices
          .updateStepThreeDate(
        is_publish: false,
        id: widget.id,
        dob: thirdDateController.text,
      )
          .then((value) {
        if (value != null) {
          EasyLoading.showError(value);
        } else {
          EasyLoading.showSuccess(CustomStyles.saveText);
          Future.delayed(Duration.zero, () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AdvertisePetStepTwoUpdate(
                        behaviour: "edit", id: widget.id)));
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

