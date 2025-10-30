import 'package:flutter/material.dart';
import 'package:petbond_uk/core/routes/routes.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/utils/validator.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/models/veterinarian/breeder_search_result.dart';
import 'package:petbond_uk/models/veterinarian/connected_breeder_model.dart';
import 'package:petbond_uk/modules/auth/signup/widgets/signup_widgets.dart';
import 'package:petbond_uk/modules/veterinarian/vet_breeder_register.dart';
import 'package:petbond_uk/modules/veterinarian/vet_dashboard.dart';
import 'package:petbond_uk/modules/veterinarian/vet_edit_adverts/vet_adverts_main.dart';
import 'package:petbond_uk/modules/veterinarian/vet_profile.dart';
import 'package:petbond_uk/modules/veterinarian/vet_setting.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';
import 'package:petbond_uk/services/veterinarian/vet_services.dart';
import '../../core/widgets/base_widget.dart';
import '../../core/widgets/drawer_buttons.dart';
import '../../core/widgets/shared/header.dart';

class VetConnectedBreeders extends StatefulWidget {
  const VetConnectedBreeders({Key? key}) : super(key: key);

  @override
  State<VetConnectedBreeders> createState() => _VetConnectedBreedersState();
}

class _VetConnectedBreedersState extends State<VetConnectedBreeders> {
  TextEditingController emailController = TextEditingController();
  AuthServices authServices = AuthServices();
  final _formKey = GlobalKey<FormState>();
  SearchResultModel searchResultModel = SearchResultModel();
  VeterinarianServices veterinarianServices = VeterinarianServices();
  List<ConnectedBreederModel> connectedBreederList = [];
  Stream? getConnected;
  bool isLoaded = false;

  getConnectedBreeder() {
    setState(() {
      getConnected =
          veterinarianServices.getStreamConnectedBreederList(context: context);
    });
  }

  TextStyle style = const TextStyle(
    color: ColorValues.fontColor,
  );

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
              widget: _body(sizingInformation: sizingInformation),
              sizingInformation: sizingInformation,
            ));
      },
    );
  }

  _body({required SizingInformationModel sizingInformation}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Connect to Breeder/Seller",
            style: CustomStyles.cardTitleStyle,
          ),
          const Divider(
            thickness: 2,
            color: ColorValues.fontColor,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "To connect to Breeder account simply scan QR code from Breeder PetBond app or search for breeder by email. Once connected to Breeder account you can upload Pet examination info to Breeder adverts. ",
          ),
          const SizedBox(
            height: 10,
          ),
          CustomWidgets.iconButton(
              text: "SCAN QR CODE TO CONNECT TO BREEDER",
              onPressed: () => Navigator.pushNamed(context, scannerScreen),
              fontSize: 12,
              fontColor: ColorValues.fontColor,
              buttonColor: ColorValues.lighBlueButton,
              asset: AssetValues.scanIcon,
              sizingInformation: sizingInformation),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Or search for breeder by email",
            style: style,
          ),
          const SizedBox(
            height: 10,
          ),
          _form(sizingInformation: sizingInformation, context: context),
          const Text(
            "Search Results",
            style: TextStyle(
                color: ColorValues.fontColor, fontFamily: "FredokaOne"),
          ),
          const SizedBox(
            height: 10,
          ),
          if (isLoaded == true)
            Text(
              "${searchResultModel.first_name} - ${searchResultModel.last_name} - ${searchResultModel.email}  - ${searchResultModel.phone_number} ",
              style: const TextStyle(
                  color: ColorValues.darkerGreyColor, fontSize: 12),
            ),
          const SizedBox(
            height: 10,
          ),
          if (isLoaded == true)
            connectedBreederList
                    .where(
                        (element) => element.email == searchResultModel.email)
                    .isNotEmpty
                ? Row(
                    children: [
                      CustomWidgets.buttonWithoutFontFamily(
                          text: "Remove",
                          widthSizedBox: sizingInformation.screenWidth / 2.5,
                          onPressed: () {
                            setState(() {
                              veterinarianServices
                                  .deleteConnection(
                                      breeder_id: searchResultModel.id,
                                      context: context)
                                  .then((value) {
                                setState(() {
                                  getConnected = veterinarianServices
                                      .getStreamConnectedBreederList(
                                          context: context);

                                  EasyLoading.showSuccess(
                                      "Connection Deleted Successfully!");
                                  isLoaded = false;
                                });
                              });
                            });
                          },
                          buttonColor: ColorValues.redColor,
                          borderColor: ColorValues.redColor,
                          sizingInformation: sizingInformation),
                      const Spacer(),
                      CustomWidgets.buttonWithoutFontFamily(
                          text: "View Adverts",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VetEditAdvertsMain(
                                          id: searchResultModel.id,
                                        )));
                          },
                          widthSizedBox: sizingInformation.screenWidth / 2.5,
                          buttonColor: ColorValues.lightGreyColor,
                          borderColor: ColorValues.lightGreyColor,
                          sizingInformation: sizingInformation),
                    ],
                  )
                : CustomWidgets.buttonWithoutFontFamily(
                    text: "Connect to Breeder/Seller",
                    width: double.infinity,
                    onPressed: () {
                      veterinarianServices
                          .connectToBreederByEmail(
                              context: context,
                              breeder_id: searchResultModel.id.toString())
                          .then((value) {
                        if (value != null) {
                          return EasyLoading.showError(value.toString());
                        } else {
                          EasyLoading.showSuccess("Connected Successfully!");
                          Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              getConnected = veterinarianServices
                                  .getStreamConnectedBreederList(
                                      context: context);
                            });
                          });
                        }
                      });
                    },
                    buttonColor: ColorValues.lightGreyColor,
                    borderColor: ColorValues.lightGreyColor,
                    sizingInformation: sizingInformation),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Connected Breeders/Sellers",
            style: CustomStyles.cardTitleStyle,
          ),
          const Divider(
            thickness: 2,
            color: ColorValues.fontColor,
          ),
          StreamBuilder(
              stream: getConnected ??
                  veterinarianServices.getStreamConnectedBreederList(
                      context: context),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: SizedBox());
                } else {
                  connectedBreederList =
                      snapshot.data as List<ConnectedBreederModel>;
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${connectedBreederList[index].first_name} - ${connectedBreederList[index].last_name} - ${connectedBreederList[index].email}  - ${connectedBreederList[index].phone_number} ",
                              style: const TextStyle(
                                  color: ColorValues.darkerGreyColor,
                                  fontSize: 12),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                CustomWidgets.buttonWithoutFontFamily(
                                    text: "Remove",
                                    widthSizedBox:
                                        sizingInformation.screenWidth / 2.5,
                                    onPressed: () {
                                      setState(() {
                                        veterinarianServices
                                            .deleteConnection(
                                                breeder_id:
                                                    connectedBreederList[index]
                                                        .id,
                                                context: context)
                                            .then((value) {
                                          setState(() {
                                            getConnected = veterinarianServices
                                                .getStreamConnectedBreederList(
                                                    context: context);
                                            EasyLoading.showSuccess(
                                                "Connection Deleted Successfully!");
                                          });
                                        });
                                      });
                                    },
                                    buttonColor: ColorValues.redColor,
                                    borderColor: ColorValues.redColor,
                                    sizingInformation: sizingInformation),
                                const Spacer(),
                                CustomWidgets.buttonWithoutFontFamily(
                                    text: "View Adverts",
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VetEditAdvertsMain(
                                                    id: connectedBreederList[
                                                            index]
                                                        .id,
                                                  )));
                                    },
                                    widthSizedBox:
                                        sizingInformation.screenWidth / 2.5,
                                    buttonColor: ColorValues.lightGreyColor,
                                    borderColor: ColorValues.lightGreyColor,
                                    sizingInformation: sizingInformation),
                              ],
                            )
                          ],
                        );
                      });
                }
              }),
        ],
      ),
    );
  }

  _form(
      {required SizingInformationModel sizingInformation,
      required BuildContext context}) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _emailTextField(sizingInformation: sizingInformation),
          const SizedBox(
            height: 10,
          ),
          CustomWidgets.buttonWithoutFontFamily(
              text: "Search for Breeder/Seller",
              width: double.infinity,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  veterinarianServices
                      .getSearchResult(
                          email: emailController.text, context: context)
                      .then((value) {
                    if (value != null) {
                      setState(() {
                        searchResultModel = value;
                        isLoaded = true;
                      });
                    }
                  });
                }
              },
              buttonColor: ColorValues.lightGreyColor,
              borderColor: ColorValues.lightGreyColor,
              sizingInformation: sizingInformation),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  _emailTextField({required SizingInformationModel sizingInformation}) {
    return SignUpWidgets.customtextField(
        textInputType: TextInputType.emailAddress,
        hintText: "Email...",
        validator: Validator.validateEmail,
        textController: emailController,
        sizingInformation: sizingInformation);
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
                      builder: (context) => VetDashBoardScreen()));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "Overview"),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VetBreederRegistration()));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "Register Breeder"),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
            },
            buttonColor: ColorValues.loginBackground,
            btnLable: "Connected Breeders"),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => VetProfile()));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "Profile"),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => VetSettings()));
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
