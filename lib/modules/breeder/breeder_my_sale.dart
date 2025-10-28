import 'package:flutter/material.dart';
import 'package:petbond_uk/core/services/secure_storage.dart';
import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/core/widgets/base_widget.dart';
import 'package:petbond_uk/core/widgets/custom_pets_sale_container.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/models/breeder/advert_sale/sale_model.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';
import 'package:petbond_uk/services/breeder/breeder_services.dart';
import '../../core/widgets/drawer_buttons.dart';
import '../../core/widgets/shared/header.dart';
import 'advertise_pet/advert_pet_overview.dart';
import 'advertise_pet/advertise_pet_step_two_create.dart';
import 'breeder-profile_setting.dart';
import 'breeder_account_setting.dart';
import 'breeder_dashboard.dart';
import 'breeder_listed_pets.dart';
import 'chat/breeder_message_list.dart';

class BreederMySale extends StatefulWidget {
  const BreederMySale({Key? key}) : super(key: key);

  @override
  State<BreederMySale> createState() => _BreederMySaleState();
}

class _BreederMySaleState extends State<BreederMySale> {
  BreederServices breederServices = BreederServices();
  List<AdvertSale> saleList = [];
  SecureStorage secureStorage = SecureStorage();
  bool isLoaded = false;
  AuthServices authServices = AuthServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    breederServices.getSaleList(context: context).then((value) {
      if (value.isEmpty) {
        if (mounted) {
          setState(() {
            isLoaded = true;
          });
        }
      }
    });
  }

  String? qrImage;
  bool imageLoaded = false;
  readQR() async {
    qrImage = await secureStorage.readStore('qr_code');
    if (qrImage != null) {
      setState(() {
        imageLoaded = true;
      });
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
          const Text(
            "Advert Deposit and Sales",
            style: CustomStyles.cardTitleStyle,
          ),
          const SizedBox(
            height: 20,
          ),
          isLoaded
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sales not found",
                      style: TextStyle(color: ColorValues.darkerGreyColor),
                    ),
                    CustomWidgets.box(sizingInformation: sizingInformation),
                  ],
                )
              : const SizedBox(),
          _listedPetsContainer(
              sizingInformation: sizingInformation, context: context)
        ],
      ),
    );
  }

  _listedPetsContainer(
      {required SizingInformationModel sizingInformation,
      required BuildContext context}) {
    return Column(
      children: [
        FutureBuilder(
            future: breederServices.getSaleList(context: context),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return SizedBox(
                  height: sizingInformation.screenHeight,
                );
              } else {
                saleList = snapshot.data as List<AdvertSale>;
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CustomPetsSaleContainer(
                        sizingInformation: sizingInformation,
                        image: saleList[index].pet!.photo.toString(),
                        name: saleList[index].pet!.adverts![0].advert_name,
                        price: saleList[index]
                            .total_transactions_price!
                            .total_amount
                            .toString(),
                        petName: saleList[index].pet!.name,
                        // priceFrom: _priceList(
                        //   sizingInformation: sizingInformation,
                        //   list: recentList[index].pets,
                        // ),
                        // petModel: recentList[index].pets,
                        mother: saleList[index].pet!.adverts![0].mother_name,
                        father: saleList[index].pet!.adverts![0].father_name,
                        dob: saleList[index].pet!.adverts![0].dob,
                        paymentType: saleList[index].type,
                        remaining_amount: saleList[index].remaining_amount,
                      );
                    });
              }
            }),
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
                      builder: (context) => BreederDashBoardScreen()));
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
                      builder: (context) => const AdvertisePetStepTwoCreate(
                        behaviour: 'create',
                        id: null,
                      )));
            },
            buttonColor: Colors.white.withOpacity(0.25),
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
            },
            buttonColor: ColorValues.loginBackground,
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
}
