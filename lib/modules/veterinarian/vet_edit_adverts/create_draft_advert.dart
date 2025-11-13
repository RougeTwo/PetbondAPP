import 'package:flutter/material.dart';
import '../../../core/services/secure_storage.dart';
import '../../../core/utils/sizing_information_model.dart';
import '../../../core/utils/validator.dart';
import '../../../core/values/asset_values.dart';
import '../../../core/values/color_values.dart';
import '../../../core/values/styles.dart';
import '../../../core/widgets/base_widget.dart';
import '../../../core/widgets/custom_drop_down_widget.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../../../core/widgets/drawer_buttons.dart' as custom;
import '../../../core/widgets/shared/header.dart';
import '../../../models/shared/breed_list_model.dart';
import '../../../models/shared/chip_model.dart';
import '../../../services/auth/auth_services.dart';
import '../../../services/breeder/breeder_services.dart';
import '../../../services/shared/shared_services.dart';
import '../../../services/veterinarian/vet_services.dart';
import '../../auth/signup/widgets/signup_widgets.dart';
import '../vet_breeder_register.dart';
import '../vet_connected_breeder.dart';
import '../vet_dashboard.dart';
import '../vet_profile.dart';
import '../vet_setting.dart';
import 'puppy_form/draft_advert_puppy_form.dart';
import 'puppy_form/draft_advert_puppy_model.dart';

class CreateDraftAdvert extends StatefulWidget {
  final int? id;

  const CreateDraftAdvert({Key? key, this.id}) : super(key: key);

  @override
  _CreateDraftAdvertState createState() => _CreateDraftAdvertState();
}

class _CreateDraftAdvertState extends State<CreateDraftAdvert> {
  SecureStorage secureStorage = SecureStorage();
  final chipFormKey = GlobalKey<FormState>();
  TextEditingController advertNameController = TextEditingController();
  TextEditingController newChipController = TextEditingController();
  TextEditingController chipController = TextEditingController();
  SharedServices sharedServices = SharedServices();
  BreederServices breederServices = BreederServices();
  VeterinarianServices vetServices = VeterinarianServices();
  AuthServices authServices = AuthServices();
  List<ChipListModel> chipList = [];
  List<PuppyForm> puppies = [];
  List<BreedListModel> breedList = [];
  String _selectedBreed = "Select breed";
  String _selectedChipNumber = "Select chip number";
  bool showBreedError = false;
  bool showAddChipFields = false;
  TextStyle style = const TextStyle(color: ColorValues.greyTextColor);
  List<String> chipNumbers = ['Select chip number'];
  List<String> breedNames = ['Select breed'];

  @override
  void initState() {
    super.initState();
    loadDataFromAPI();
  }

  void loadDataFromAPI() async {
    _loadChipNumberFromAPI('');
    breedList = await sharedServices.getBreedList(context: context);
    breedNames =
        breedList.map<String>((breedModel) => breedModel.name).toList();
  }

  void _loadChipNumberFromAPI(String chipNumber) async {
    List<ChipListModel> res =
        await vetServices.getChipList(context: context, breederId: widget.id);
    chipNumbers = res.map<String>((breedModel) {
      return breedModel.chip_number;
    }).toList();
    setState(() {
      chipNumbers;
      if (chipNumber.isNotEmpty) {
        showAddChipFields = false;
        _selectedChipNumber = chipNumber;
        newChipController.text = '';
      }
    });
  }

  void _addChipNumber() async {
    if (chipFormKey.currentState!.validate()) {
      setState(() {
        showBreedError = false;
      });

      if (_selectedBreed != "Select breed") {
        vetServices
            .breederAddMicroChipInfo(
          chip_number: newChipController.text,
          breed_id: breedList
              .where((element) => element.name == _selectedBreed)
              .first
              .id
              .toString(),
          breeder_id: widget.id,
          context: context,
        )
            .then((value) {
          _loadChipNumberFromAPI(newChipController.text);
        });
      } else {
        setState(() {
          showBreedError = true;
        });
      }
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
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
                  child: SingleChildScrollView(
                  keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Create Advert",
                        style: CustomStyles.cardTitleStyle,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SignUpWidgets.customtextField(
                          textInputType: TextInputType.text,
                          hintText: "Advert Name",
                          textColor: ColorValues.fontColor,
                          validator: Validator.validateEmptyFiled,
                          textController: advertNameController,
                          sizingInformation: sizingInformation),
                      CustomDropdownWidget(
                        defaultValue: "Select chip number",
                        selectedValue: _selectedChipNumber,
                        itemList: chipNumbers,
                        onValueChanged: (newValue) {
                          setState(() {
                            _selectedChipNumber = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == "Select chip number") {
                            return 'Please select chip no';
                          }
                          if (value == null) {
                            return 'Please select chip no';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Center(
                        child: Text(
                          "(OR)",
                          style: style,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: CustomWidgets.buttonWithoutFontFamily(
                            text: "*Add New Chip Number",
                            onPressed: () {
                              setState(() {
                                showAddChipFields = !showAddChipFields;
                                newChipController.clear();
                                _selectedBreed = "Select breed";
                              });
                            },
                            buttonColor: ColorValues.loginBackground,
                            borderColor: ColorValues.loginBackground,
                            sizingInformation: sizingInformation),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (showAddChipFields == true)
                        GestureDetector(
                          child: const Text(
                            "hide",
                            style: TextStyle(
                                color: ColorValues.fontColor,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          ),
                          onTap: () {
                            setState(() {
                              showAddChipFields = false;
                            });
                          },
                        ),
                      if (showAddChipFields == true)
                        const SizedBox(
                          height: 15,
                        ),
                      if (showAddChipFields == true)
                        _addChipFields(sizingInformation: sizingInformation),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Add Puppies",
                              style: TextStyle(
                                  color: ColorValues.fontColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "FredokaOne"),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              onAddForm();
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: ColorValues.fontColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                        puppies.isEmpty
                          ? const SizedBox()
                          : ListView.builder(
                            shrinkWrap: true,
                            physics:
                              const NeverScrollableScrollPhysics(),
                            // addAutomaticKeepAlives: true,
                            itemCount: puppies.length,
                            itemBuilder: (_, i) => puppies[i],
                          ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomWidgets.iconButton(
                          text: "Save",
                          onPressed: () {
                            onSave();
                          },
                          width: sizingInformation.safeBlockHorizontal * 30,
                          buttonColor: ColorValues.loginBackground,
                          asset: AssetValues.saveIcon,
                          sizingInformation: sizingInformation)
                    ],
                  )),
                ),
              sizingInformation: sizingInformation,
            ));
      },
    );
  }

  void onSave() {
    var allValid = true;
    for (var form in puppies) {
      allValid = allValid && form.isValid();
    }
    if (allValid) {
      var data = puppies.map((it) => it.puppyModel).toList();
      vetServices.addDraftAdvert(
        advertName: advertNameController.text,
        breederId: widget.id,
        chipNumber: _selectedChipNumber,
        puppies: data,
        context: context,
      );
    }
  }

  _addChipFields({required SizingInformationModel sizingInformation}) {
    return Form(
      key: chipFormKey,
      child: Column(
        children: [
          SignUpWidgets.customtextField(
              textInputType: TextInputType.number,
              hintText: "Chip number...",
              textController: newChipController,
              maxLength: 15,
              errorStyle: TextStyle(color: Colors.red[800], fontSize: 12),
              validator: Validator.validateChipName,
              sizingInformation: sizingInformation),
          const SizedBox(
            height: 10,
          ),
          CustomDropdownWidget(
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
          ),
          const SizedBox(
            height: 10,
          ),
          showBreedError
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "   This field is required",
                    style: TextStyle(color: Colors.red[800], fontSize: 12),
                  ),
                )
              : const SizedBox(),
          CustomWidgets.buttonWithoutFontFamily(
              text: "Add New Chip Number",
              onPressed: () => _addChipNumber(),
              buttonColor: ColorValues.fontColor,
              borderColor: ColorValues.fontColor,
              sizingInformation: sizingInformation),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  void onDelete(DraftAdvertPuppyModel puppy) {
    setState(() {
      var find = puppies.firstWhere(
        (it) => it.puppyModel.index == puppy.index,
      );
      puppies.removeAt(puppies.indexOf(find));
    });
  }

  ///on add form
  void onAddForm() {
    setState(() {
      var _pet = DraftAdvertPuppyModel();
      _pet.isNew = true;
      _pet.index = puppies.length + 1;
      puppies.add(PuppyForm(
        onDelete: () => onDelete(_pet),
        puppyModel: _pet,
      ));
    });
  }

  //
  // _bodyWidget({required SizingInformationModel sizingInformation}) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //
  //       MyForm(
  //         sizingInformationModel: sizingInformation,
  //       ),
  //
  //     ],
  //   );
  // }

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

