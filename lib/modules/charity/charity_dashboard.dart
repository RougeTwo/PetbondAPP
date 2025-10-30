import 'package:flutter/material.dart';
import 'package:petbond_uk/core/services/secure_storage.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/widgets/base_widget.dart';
import 'package:petbond_uk/core/widgets/drawer_buttons.dart';
import 'package:petbond_uk/core/widgets/shared/header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petbond_uk/modules/charity/charity_account_setting.dart';
import 'package:petbond_uk/modules/charity/charity_listed_pets.dart';
import 'package:petbond_uk/modules/charity/charity_overview.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';
import 'advertise_pet/charity_advert_create.dart';
import 'chat/charity_message_list.dart';

class CharityDashBoardScreen extends StatefulWidget {
  const CharityDashBoardScreen({Key? key}) : super(key: key);

  @override
  _CharityDashBoardScreenState createState() => _CharityDashBoardScreenState();
}

class _CharityDashBoardScreenState extends State<CharityDashBoardScreen> {
  int i = 1;
  String role = "";
  SecureStorage secureStorage = SecureStorage();
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
                            SizedBox(
                              height: 42,
                            ),
                            Material(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Row(
                                  children: [
                                    Text(
                                      "Charity DashBoard",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    Spacer(),
                                    IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 25,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
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
              // drawerIcon: Builder(builder: (context) {
              //   return GestureDetector(
              //     onTap: () => Scaffold.of(context).openDrawer(),
              //     child: SvgPicture.asset(
              //       AssetValues.menuIcon,
              //       height: 30,
              //     ),
              //   );
              // }),
              dashBoardTitle: "CHARITY",
              widget: CharityOverview(
                sizingInformation: sizingInformation,
                // editCharityPetPress: () {
                //   changeWidget(CharityAdvertOverview(
                //     behaviour: 'edit',
                //     sizingInformation: sizingInformation,
                //   ));
                // },
              ),
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
                      builder: (context) => CharityAdvertCreate(
                            id: null,
                          )));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "Sell a pet"),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CharityListedPets()));
            },
            buttonColor: Colors.white.withOpacity(0.25),
            btnLable: "Listed pet"),
        DrawerButton(
          sizingInformation: sizingInformation,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CharityMessageList()));
          },
          buttonColor: Colors.white.withOpacity(0.25),
          btnLable: "Advert Messages",
          showMessageCounter: true,
          role: 'charity',
        ),
        DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CharityAccountSetting()));
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
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
