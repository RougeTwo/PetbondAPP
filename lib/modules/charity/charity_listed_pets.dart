import 'package:flutter/material.dart' hide DrawerButton;
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/widgets/custom_pets_container.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/models/breeder/advert/advert_model.dart';
import 'package:petbond_uk/modules/charity/advertise_pet/charity_advert_create.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';
import 'package:petbond_uk/services/charity/charity_services.dart';
import '../../core/utils/helper.dart';
import '../../core/widgets/base_widget.dart';
import '../../core/widgets/drawer_buttons.dart' as custom;
import '../../core/widgets/shared/header.dart';
import '../advert_detail_view/advert_detail_view.dart';
import 'charity_account_setting.dart';
import 'charity_dashboard.dart';
import 'chat/charity_message_list.dart';

class CharityListedPets extends StatefulWidget {
  const CharityListedPets({Key? key}) : super(key: key);

  @override
  State<CharityListedPets> createState() => _CharityListedPetsState();
}

class _CharityListedPetsState extends State<CharityListedPets> {
  CharityServices charityServices = CharityServices();
  bool isLoaded = false;
  List<AdvertModel> recentList = [];
  AuthServices authServices = AuthServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    charityServices.getListedPets(context: context).then((value) {
      if (value.isEmpty) {
        setState(() {
          isLoaded = true;
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
                                      "Charity DashBoard",
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
          CustomWidgets.cardTitle(title: "Your Listed Pets"),
          isLoaded
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "No data found",
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
    return FutureBuilder(
        future: charityServices.getListedPets(context: context),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(height: sizingInformation.screenHeight);
          } else {
            recentList = snapshot.data as List<AdvertModel>;
            return ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomPetsContainer(
                      sizingInformation: sizingInformation,
                      image: recentList[index].cover_photo.toString(),
                      name: recentList[index].advert_name,
                      price: recentList[index].price,
                      showDeleteButton: true,
                      breed: recentList[index].name,
                      priceFrom: Helper.priceList(
                        sizingInformation: sizingInformation,
                        list: recentList[index].pets,
                      ),
                      petModel: recentList[index].pets,
                      mother: recentList[index].mother_name,
                      father: recentList[index].father_name,
                      soldCount: recentList[index].sold_count ?? 0,
                      petCount: recentList[index].pet_count ?? 0,
                      dob: recentList[index].dob,
                      status: recentList[index].status,
                      onViewPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdvertDetailViewScreen(
                                      id: recentList[index].id,
                                      advertUrl: recentList[index]
                                          .advert_url
                                          .toString(),
                                    )));
                      },
                      onEditPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CharityAdvertCreate(
                                      id: recentList[index].id,
                                    )));
                      },
                      onDeletePress: () {
                        charityServices
                            .deleteCharityAdvertFromList(
                                context: context,
                                advert_id: recentList[index].id)
                            .then((value) {
                          EasyLoading.showSuccess(value!);
                          Future.delayed(const Duration(seconds: 1), () {
                            setState(() {});
                          });
                        });
                      });
                });
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
                      builder: (context) => const CharityDashBoardScreen()));
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
                      builder: (context) => const CharityAdvertCreate(
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
            btnLable: "Listed pet"),
        custom.DrawerButton(
          sizingInformation: sizingInformation,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CharityMessageList()));
          },
          buttonColor: Colors.white.withValues(alpha: 0.25),
          btnLable: "Advert Messages",
          showMessageCounter: true,
          role: 'charity',
        ),
        custom.DrawerButton(
            sizingInformation: sizingInformation,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CharityAccountSetting()));
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

