import 'package:flutter/material.dart' hide DrawerButton;
import 'package:petbond_uk/core/services/secure_storage.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/widgets/custom_pets_container.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/models/breeder/advert/advert_model.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';
import 'package:petbond_uk/services/breeder/breeder_services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../core/utils/helper.dart';
import '../../core/widgets/base_widget.dart';
import '../../core/widgets/drawer_buttons.dart' as custom;
import '../../core/widgets/shared/header.dart';
import '../../core/widgets/un_ordered_list.dart';
import '../../services/connect_account/connect_services.dart';
import '../advert_detail_view/advert_detail_view.dart';
import 'advertise_pet/advertise_pet_step_two_create.dart';
import 'advertise_pet/advertise_pet_step_two_update.dart';
import 'breeder-profile_setting.dart';
import 'breeder_account_setting.dart';
import 'breeder_dashboard.dart';
import 'breeder_my_sale.dart';
import '/core/widgets/globals.dart' as globals;
import 'chat/breeder_message_list.dart';

class BreederListedPets extends StatefulWidget {
  const BreederListedPets({Key? key}) : super(key: key);

  @override
  State<BreederListedPets> createState() => _BreederListedPetsState();
}

class _BreederListedPetsState extends State<BreederListedPets> {
  BreederServices breederServices = BreederServices();
  bool isLoaded = false;
  List<AdvertModel> recentList = [];
  SecureStorage secureStorage = SecureStorage();
  AuthServices authServices = AuthServices();
  ConnectServices connectServices = ConnectServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callApi();
  }

  callApi() async {
    await breederServices.getListedPets(context: context).then((value) {
      if (value.isEmpty) {
        if (mounted) {
          setState(() {
            isLoaded = true;
          });
        }
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
              sizingInformation: sizingInformation, context: context),
          globals.GlobalData.showStripeAccountPopUp
              ? const SizedBox(
                  height: 30,
                )
              : const SizedBox(),
          globals.GlobalData.showStripeAccountPopUp
              ? _bottomContainer(sizingInformation: sizingInformation)
              : const SizedBox(),
        ],
      ),
    );
  }

  _listedPetsContainer(
      {required SizingInformationModel sizingInformation,
      required BuildContext context}) {
    return FutureBuilder(
        future: breederServices.getListedPets(context: context),
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
                    onEditPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdvertisePetStepTwoUpdate(
                                  id: recentList[index].id,
                                  behaviour: 'edit',
                                )),
                      ).then((value) => callApi());
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => AdvertisePetStepTwoUpdate(
                      //               id: recentList[index].id,
                      //               behaviour: 'edit',
                      //             )));
                    },
                    sizingInformation: sizingInformation,
                    image: recentList[index].cover_photo.toString(),
                    breed: recentList[index].name,
                    name: recentList[index].advert_name,
                    price: recentList[index].price,
                    showDeleteButton: true,
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
                    onDeletePress: () {
                      breederServices
                          .deleteAdvertFromList(
                              context: context, advert_id: recentList[index].id)
                          .then((value) {
                        EasyLoading.showSuccess(value!);
                        Future.delayed(const Duration(seconds: 1), () {
                          setState(() {});
                        });
                      });
                    },
                    onViewPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdvertDetailViewScreen(
                                    id: recentList[index].id,
                                    advertUrl:
                                        recentList[index].advert_url.toString(),
                                  )));
                    },
                  );
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
            },
            buttonColor: ColorValues.loginBackground,
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

  _bottomContainer({required SizingInformationModel sizingInformation}) {
    return Container(
      decoration: const BoxDecoration(
          color: ColorValues.fontColor,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "How to get Paid",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 29,
                      fontFamily: "FredokaOne"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 6, vertical: 6),
                      child: Text(
                        "Option 1 Stripe: ",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    decoration: const BoxDecoration(
                        color: ColorValues.loginBackground,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("Stripe is the easiest",
                      style: TextStyle(color: Colors.white))
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Text("way to get paid online, to receive payments",
                  style: TextStyle(color: Colors.white)),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () {
                  connectServices.createStripeAccount(context: context);
                },
                child:
                    const Text("click here to create or connect your Stripe account",
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        )),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 6, vertical: 6),
                      child: Text(
                        "Option 2 Bank Transfer: ",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    decoration: const BoxDecoration(
                        color: ColorValues.loginBackground,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("If you are ", style: TextStyle(color: Colors.white))
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                  "having issues setting up your stripe account you can request a bank transfer by contacting us.",
                  style: TextStyle(color: Colors.white)),
              const SizedBox(
                height: 10,
              ),
              const Text("How to get bank transfer:",
                  style: TextStyle(color: Colors.white)),
              const SizedBox(
                height: 10,
              ),
              const UnorderedList([
                "You must email us from the same email that is used in your petbond account",
                "You must include you full details name,address,phone, and advert details so we can verify it is you",
                "You must include your bank details IBAN,BIC, Account Name",
                "Send email to info@petbond.ie",
                "Please allow up to 5 business days",
              ])
            ],
          )),
    );
  }
}

