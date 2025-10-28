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
import 'package:petbond_uk/models/veterinarian/advert/adverts_model.dart';
import 'package:petbond_uk/modules/veterinarian/advert_puppies_list/adverts_puppies_list_main.dart';
import 'package:petbond_uk/modules/veterinarian/vet_breeder_register.dart';
import 'package:petbond_uk/modules/veterinarian/vet_connected_breeder.dart';
import 'package:petbond_uk/modules/veterinarian/vet_profile.dart';
import 'package:petbond_uk/modules/veterinarian/vet_setting.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';
import 'package:petbond_uk/services/veterinarian/vet_services.dart';
import 'package:petbond_uk/core/widgets/shared/header.dart';
import '../vet_dashboard.dart';
import 'create_draft_advert.dart';

class VetEditAdvertsMain extends StatefulWidget {
  final int? id;

  const VetEditAdvertsMain({Key? key, this.id}) : super(key: key);

  @override
  _VetEditAdvertsMainState createState() => _VetEditAdvertsMainState();
}

class _VetEditAdvertsMainState extends State<VetEditAdvertsMain> {
  int i = 3;
  SecureStorage secureStorage = SecureStorage();
  VeterinarianServices veterinarianServices = VeterinarianServices();
  List<AdvertsModel> advertsList = [];
  AuthServices authServices = AuthServices();

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
                  child: _formWidgte(sizingInformation: sizingInformation)),
              sizingInformation: sizingInformation,
            ));
      },
    );
  }

  _formWidgte({required SizingInformationModel sizingInformation}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upload/Edit Breeder Adverts",
          style: CustomStyles.cardTitleStyle,
        ),
        const SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => CreateDraftAdvert(
                  id: widget.id,
                ),
              ))
                  .then((value) {
                setState(() {});
              });
            },
            child: const Text(
              "Create Advert",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: ColorValues.fontColor),
            ),
          ),
        ),
        FutureBuilder(
            future: veterinarianServices.getAdvertsList(
                context: context, breeder_id: widget.id),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Text("No data found");
              } else {
                advertsList = snapshot.data as List<AdvertsModel>;
                return ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "${advertsList[index].name}",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: ColorValues.darkerGreyColor),
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: CustomWidgets.buttonWithoutFontFamily(
                                    text: "Edit Adverts",
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdvertsPuppiesListMain(
                                                    breeder_advert_id:
                                                        advertsList[index].id,
                                                    breeder_advert_name:
                                                        advertsList[index].name,
                                                    connected_breeder_id:
                                                        widget.id,
                                                  )));
                                    },
                                    widthSizedBox:
                                        sizingInformation.screenWidth / 2.5,
                                    buttonColor: ColorValues.lightGreyColor,
                                    borderColor: ColorValues.lightGreyColor,
                                    sizingInformation: sizingInformation),
                              ),
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
            future: veterinarianServices.getAdvertsList(
                context: context, breeder_id: widget.id),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return SizedBox(height: sizingInformation.screenHeight / 3.5);
              } else {
                advertsList = snapshot.data;
                return SizedBox(
                  height: sizingInformation.screenHeight / 16,
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
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: const [
                  Icon(Icons.arrow_back, color: Colors.white),
                  SizedBox(
                    width: 25,
                  ),
                  Text("Back to Breeders List",
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
                child:const Align(
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
