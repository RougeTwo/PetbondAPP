import 'package:flutter/material.dart';
import 'package:petbond_uk/core/services/secure_storage.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/core/widgets/base_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/core/widgets/drawer_buttons.dart';
import 'package:petbond_uk/models/veterinarian/advert_puppies_model/advert_puppies_model.dart';
import 'package:petbond_uk/modules/veterinarian/edit_advert_puppies/edit_advert_puppies_main.dart';
import 'package:petbond_uk/modules/veterinarian/vet_breeder_register.dart';
import 'package:petbond_uk/modules/veterinarian/vet_connected_breeder.dart';
import 'package:petbond_uk/modules/veterinarian/vet_profile.dart';
import 'package:petbond_uk/modules/veterinarian/vet_setting.dart';
import 'package:petbond_uk/core/widgets/shared/header.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';
import 'package:petbond_uk/services/shared/shared_services.dart';
import 'package:petbond_uk/services/veterinarian/vet_services.dart';
import '../vet_dashboard.dart';

class AdvertsPuppiesListMain extends StatefulWidget {
  final int? breeder_advert_id;
  final int? connected_breeder_id;
  final String? breeder_advert_name;

  const AdvertsPuppiesListMain(
      {Key? key,
      this.breeder_advert_id,
      this.breeder_advert_name,
      this.connected_breeder_id})
      : super(key: key);

  @override
  _AdvertsPuppiesListMainState createState() => _AdvertsPuppiesListMainState();
}

class _AdvertsPuppiesListMainState extends State<AdvertsPuppiesListMain> {
  int i = 3;
  SecureStorage secureStorage = SecureStorage();
  VeterinarianServices veterinarianServices = VeterinarianServices();
  AdvertPuppiesModel advertsList = AdvertPuppiesModel();
  SharedServices sharedServices = SharedServices();
  AuthServices authServices = AuthServices();

  _body({required SizingInformationModel sizingInformation}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Advert Puppie's List",
          style: CustomStyles.cardTitleStyle,
        ),
        const SizedBox(
          height: 20,
        ),
        FutureBuilder(
            future: veterinarianServices.getAdvertPuppyList(
                context: context, breeder_id: widget.breeder_advert_id),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Text("No data found");
              } else {
                advertsList = snapshot.data;
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: advertsList.pets!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "${advertsList.pets![index].name}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: ColorValues.darkerGreyColor),
                              ),
                              const Spacer(),
                              CustomWidgets.buttonWithoutFontFamily(
                                  text: "Edit Puppy",
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          EditAdvertsPuppiesListMain(
                                        id: advertsList.pets![index].id,
                                        name: widget.breeder_advert_name,
                                        puppyModel: advertsList.pets![index],
                                        connect_breeder_id:
                                            widget.connected_breeder_id,
                                      ),
                                    ))
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                  widthSizedBox:
                                      sizingInformation.screenWidth / 3,
                                  buttonColor: ColorValues.lightGreyColor,
                                  borderColor: ColorValues.lightGreyColor,
                                  sizingInformation: sizingInformation),
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                          )
                        ],
                      );
                    });
              }
            }),
        FutureBuilder(
            future: veterinarianServices.getAdvertPuppyList(
                context: context, breeder_id: widget.breeder_advert_id),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return SizedBox(
                  height: sizingInformation.screenHeight / 3,
                );
              } else {
                return SizedBox(
                  height: sizingInformation.screenHeight / 6,
                );
              }
            }),
        ButtonTheme(
          minWidth: double.infinity,
          child: MaterialButton(
            color: ColorValues.loginBackground,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: const [
                  Icon(Icons.arrow_back, color: Colors.white),
                  SizedBox(
                    width: 25,
                  ),
                  Text("Back to Advert List",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
            ),
            textColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
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
                  child: _body(sizingInformation: sizingInformation)),
              sizingInformation: sizingInformation,
            ));
      },
    );
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VetConnectedBreeders()));
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
