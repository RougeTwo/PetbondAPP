import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/core/widgets/custom_pets_container.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/models/breeder/advert/advert_model.dart';
import 'package:petbond_uk/models/charity/charity_view_model.dart';
import 'package:petbond_uk/services/charity/charity_services.dart';
import '../../core/utils/base_url.dart';
import '../../core/utils/helper.dart';
import '../advert_detail_view/advert_detail_view.dart';
import 'advertise_pet/charity_advert_create.dart';
import 'edit_charity_bio.dart';

class CharityOverview extends StatefulWidget {
  final SizingInformationModel sizingInformation;

  const CharityOverview({Key? key, required this.sizingInformation})
      : super(key: key);

  @override
  State<CharityOverview> createState() => _CharityOverviewState();
}

class _CharityOverviewState extends State<CharityOverview> {
  CharityServices charityServices = CharityServices();
  CharityViewModel? viewModel;
  bool viewModelLoading = false;
  bool viewRecentListLoading = false;
  List<AdvertModel> recentList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    charityServices.getViewModel(context: context).then((value) {
      setState(() {
        viewModel = value;
        viewModelLoading = true;
      });
    });
    charityServices.getRecent(context: context).then((value) {
      if (value.isNotEmpty) {
        setState(() {
          recentList = value;
          viewRecentListLoading = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    charityServices.context = context;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: viewModelLoading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomWidgets.cardTitle(title: "Welcome To Pet Bond"),
                const Text(
                  "Please complete your bio information to attract the most attention for your litter",
                  style: CustomStyles.textStyle,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Profile Picture", style: CustomStyles.textStyle),
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
      children: [
        _profileContainer(sizingInformation: widget.sizingInformation),
        const SizedBox(
          height: 20,
        ),
        _bioContainer(sizingInformation: widget.sizingInformation),
        const SizedBox(
          height: 30,
        ),
        _listedPetsContainer(sizingInformation: widget.sizingInformation)
      ],
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
                "Your bio",
                style: TextStyle(
                    fontFamily: "NotoSans",
                    fontSize: 18,
                    color: ColorValues.fontColor),
              ),
            ),
            CustomWidgets.iconButton(
                text: "Edit bio",
                width: widget.sizingInformation.safeBlockHorizontal * 30,
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CharityEditBio()))
                      .then((value) {
                    charityServices
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
        viewModel != null
            ? viewModel!.detail!.bio == null
                ? const Text("Add bio", style: CustomStyles.textStyle)
                : Text(viewModel!.detail!.bio.toString(),
                    style: CustomStyles.textStyle)
            : const Text("Add bio"),
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
        const Text(
          "Your recently added pets",
          style: TextStyle(
              fontFamily: "NotoSans",
              fontSize: 18,
              color: ColorValues.fontColor),
        ),
        const Divider(
          thickness: 2,
          color: ColorValues.fontColor,
        ),
        viewRecentListLoading
            ? ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: recentList.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomPetsContainer(
                    sizingInformation: sizingInformation,
                    image: recentList[index].cover_photo.toString(),
                    name: recentList[index].advert_name,
                    price: recentList[index].price,
                    showDeleteButton: false,
                    breed: recentList[index].advert_name,
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
                                    advertUrl:
                                        recentList[index].advert_url.toString(),
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
                    onDeletePress: () {},
                  );
                })
            : const SizedBox()
      ],
    );
  }

  _profileContainer({required SizingInformationModel sizingInformation}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        viewModel != null
            ? viewModel!.avatar == null
                ? SvgPicture.asset(
                    AssetValues.profileIcon,
                    width: sizingInformation.safeBlockHorizontal * 50,
                    height: sizingInformation.safeBlockHorizontal * 50,
                    fit: BoxFit.cover,
                  )
                : CustomWidgets.customNetworkImage(
                    imageUrl: BaseUrl.getImageBaseUrl() +
                        viewModel!.avatar.toString(),
                    sizingInformation: sizingInformation)
            : SvgPicture.asset(
                AssetValues.profileIcon,
                width: sizingInformation.safeBlockHorizontal * 50,
                height: sizingInformation.safeBlockHorizontal * 50,
                fit: BoxFit.cover,
              ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
