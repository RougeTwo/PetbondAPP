import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:petbond_uk/core/utils/helper.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/core/widgets/custom_pets_container.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/models/breeder/advert/advert_model.dart';
import 'package:petbond_uk/models/breeder/view_model.dart';
import 'package:petbond_uk/modules/advert_detail_view/advert_detail_view.dart';
import 'package:petbond_uk/modules/breeder/edit_bio.dart';
import 'package:petbond_uk/services/breeder/breeder_services.dart';
import 'package:petbond_uk/services/connect_account/connect_services.dart';
import '../../core/widgets/un_ordered_list.dart';
import '/core/widgets/globals.dart' as globals;
import 'advertise_pet/advertise_pet_step_two_create.dart';
import 'advertise_pet/advertise_pet_step_two_update.dart';

class BreederOverview extends StatefulWidget {
  final SizingInformationModel sizingInformation;

  const BreederOverview({Key? key, required this.sizingInformation})
      : super(key: key);

  @override
  State<BreederOverview> createState() => _BreederOverviewState();
}

class _BreederOverviewState extends State<BreederOverview> {
  BreederServices breederServices = BreederServices();
  ConnectServices connectServices = ConnectServices();
  ViewModel? viewModel;
  bool viewModelLoading = false;
  bool viewRecentListLoading = false;
  List<AdvertModel> recentList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callApis();
  }

  callApis() async {
    await breederServices.getRecent(context: context).then((value) {
      if (value.isNotEmpty) {
        setState(() {
          recentList = value;
          viewRecentListLoading = true;
        });
      }
    });
    await breederServices.getViewModel(context: context).then((value) {
      setState(() {
        viewModel = value;
        viewModelLoading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    breederServices.context = context;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: viewModelLoading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomWidgets.buttonWithoutFontFamily(
                    width: widget.sizingInformation.screenWidth,
                    text: "This is a Seller Account",
                    onPressed: () {
                      //connectServices.createStripeAccount(context: context);
                    },
                    verticalPadding: 12,
                    buttonColor: ColorValues.fontColor,
                    borderColor: ColorValues.fontColor,
                    sizingInformation: widget.sizingInformation),
                const SizedBox(
                  height: 10,
                ),
                _createAdvertSection(
                    sizingInformation: widget.sizingInformation),
                const SizedBox(
                  height: 10,
                ),
                _servicesSection(sizingInformation: widget.sizingInformation),
                const SizedBox(
                  height: 20,
                ),
                // CustomWidgets.cardTitle(title: "Welcome To Pet Bond"),
                // const Text(
                //   "Please complete your bio information to attract the most attention for your litter",
                //   style: CustomStyles.textStyle,
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Profile Picture",
                    style: TextStyle(
                        fontFamily: "NotoSans",
                        fontSize: 18,
                        color: ColorValues.fontColor),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _bodyWidget(sizingInformation: widget.sizingInformation)
              ],
            )
          : CustomWidgets.box(sizingInformation: widget.sizingInformation),
    );
  }

  _bodyWidget({required SizingInformationModel sizingInformation}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (viewModel != null)
          _profileContainer(sizingInformation: widget.sizingInformation),
        const SizedBox(
          height: 20,
        ),
        if (viewModel != null)
          _bioContainer(sizingInformation: widget.sizingInformation),
        const SizedBox(
          height: 30,
        ),
        _listedPetsContainer(sizingInformation: widget.sizingInformation),
        globals.GlobalData.showStripeAccountPopUp
            ? const SizedBox(
                height: 30,
              )
            : const SizedBox(),
        //_bottomContainer(sizingInformation: sizingInformation),
        globals.GlobalData.showStripeAccountPopUp
            ? _bottomContainer(sizingInformation: sizingInformation)
            : const SizedBox(),
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
                "Your Bio",
                style: TextStyle(
                    fontFamily: "NotoSans",
                    fontSize: 18,
                    color: ColorValues.fontColor),
              ),
            ),
            CustomWidgets.iconButton(
                text: "Edit Profile",
                width: widget.sizingInformation.safeBlockHorizontal * 35,
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
        if (viewModel!.detail != null)
          viewModel!.detail!.bio == null
              ? const Text(
                  "Add bio",
                  style: CustomStyles.textStyle,
                )
              : Text(
                  viewModel!.detail!.bio.toString(),
                  style: CustomStyles.textStyle,
                ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  _listedPetsContainer({required SizingInformationModel sizingInformation}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        viewRecentListLoading
            ? ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: recentList.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomPetsContainer(
                    sizingInformation: sizingInformation,
                    onEditPress: () {
                      // Navigator.push(
                      //     context,
                      // MaterialPageRoute(
                      //     builder: (context) => AdvertisePetStepTwoUpdate(
                      //           id: recentList[index].id,
                      //           behaviour: 'edit',
                      //         ))).then(callApis());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdvertisePetStepTwoUpdate(
                                  id: recentList[index].id,
                                  behaviour: 'edit',
                                )),
                      ).then((value) => callApis());
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => AdvertisePetStepTwoUpdate(
                      //               id: recentList[index].id,
                      //               behaviour: 'edit',
                      //             )));
                    },
                    image: recentList[index].cover_photo.toString(),
                    breed: recentList[index].name,
                    name: recentList[index].advert_name,
                    // price: recentList[index].price,
                    showDeleteButton: false,
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
                    onDeletePress: () {},
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
                })
            : const SizedBox(),
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
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  _createAdvertSection({required SizingInformationModel sizingInformation}) {
    return Container(
      width: sizingInformation.screenWidth,
      decoration: const BoxDecoration(
          color: ColorValues.loginBackground,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 10,
          ),
          Image.asset(
            AssetValues.logo,
            fit: BoxFit.cover,
            width: sizingInformation.safeBlockHorizontal * 50,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomWidgets.buttonWithoutFontFamily(
              text: "CREATE AN ADVERT",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdvertisePetStepTwoCreate(
                              behaviour: 'create',
                              id: null,
                            )));
              },
              width: widget.sizingInformation.blockSizeHorizontal * 60,
              verticalPadding: 12,
              buttonColor: ColorValues.fontColor,
              borderColor: Colors.white,
              sizingInformation: sizingInformation),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  _servicesSection({required SizingInformationModel sizingInformation}) {
    return Container(
      width: sizingInformation.screenWidth,
      decoration: const BoxDecoration(
          color: ColorValues.loginBackground,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Click here to found out more about our free vaccination services and free health test",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomWidgets.buttonWithoutFontFamily(
              text: "FREE SERVICES",
              onPressed: () {
                Helper.freeServicesLaunchURL();
                //connectServices.createStripeAccount(context: context);
              },
              width: widget.sizingInformation.blockSizeHorizontal * 60,
              verticalPadding: 12,
              buttonColor: ColorValues.fontColor,
              borderColor: Colors.white,
              sizingInformation: sizingInformation),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
