import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/widgets/custom_rating/rating_container.dart';
import 'package:petbond_uk/models/advert_model/advert__detail_view_pet_model.dart';
import 'package:petbond_uk/models/advert_model/advert_detail_model.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';
import 'package:petbond_uk/services/shared/shared_services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/services/secure_storage.dart';
import '../../core/utils/helper.dart';
import '../../core/utils/sizing_information_model.dart';
import '../../core/values/asset_values.dart';
import '../../core/widgets/base_widget.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../core/widgets/shared/footer.dart';

class AdvertDetailViewScreen extends StatefulWidget {
  final int? id;
  final String advertUrl;

  // ignore: use_key_in_widget_constructors
  const AdvertDetailViewScreen({this.id, required this.advertUrl});

  @override
  _AdvertDetailViewScreenState createState() => _AdvertDetailViewScreenState();
}

class _AdvertDetailViewScreenState extends State<AdvertDetailViewScreen> {
  int i = 0;
  SecureStorage secureStorage = SecureStorage();
  TextStyle style = const TextStyle(color: ColorValues.darkerGreyColor);
  TextStyle style1 = const TextStyle(
      color: ColorValues.fontColor, fontWeight: FontWeight.w500);
  bool isLoaded = false;
  bool showSize = false;
  bool showEnergy = false;
  bool showLifeSpan = false;
  bool showGrooming = false;
  bool showLivingSpace = false;
  String date = "";
  int count = 1;
  int length = 0;
  dynamic differenceInDays;
  dynamic reHome;
  AuthServices authServices = AuthServices();

  AdvertDetailViewModel advertDetailViewModel = AdvertDetailViewModel();
  SharedServices sharedServices = SharedServices();
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedServices
        .getAdvertDetailViewModel(context: context, id: widget.id)
        .then((value) {
      if (value != null) {
        setState(() {
          advertDetailViewModel = value;

          length = advertDetailViewModel.pets!.length;
          if (advertDetailViewModel.dob != null) {
            _calculateDays(advertDetailViewModel.dob.toString());
          }
          isLoaded = true;
        });
      }
    });
  }

  _calculateDays(String apiDate) {
    setState(() {
      DateTime dateTimeCreatedAt = DateTime.parse(apiDate);
      DateTime dateTimeNow = DateTime.now();
      differenceInDays = dateTimeNow.difference(dateTimeCreatedAt).inDays;
      reHome = 80 - differenceInDays;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, sizingInformation) {
        return Scaffold(
            backgroundColor: ColorValues.backgroundColor,
            body: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover, image: AssetImage(AssetValues.bgJpg))),
              child: SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Image(
                      image: const AssetImage(AssetValues.appBar_Image),
                      fit: BoxFit.fill,
                      width: sizingInformation.screenWidth,
                    ),
                    Positioned(
                      top: 65,
                      left: 20,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          backgroundColor: ColorValues.fontColor,
                          radius: 18,
                          child: GestureDetector(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 45,
                      right: 80,
                      child: Image(
                        image: AssetImage(
                          AssetValues.logo,
                        ),
                        fit: BoxFit.cover,
                        height: 50,
                      ),
                    ),
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 110, 12, 180),
                        child: GestureDetector(
                          onTap: () {},
                          child: Card(
                            //  color: Colors.white10,
                              shadowColor: Colors.black,
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              //  / clipBehavior: Clip.none,
                              child: _bodyWidget(
                                  sizingInformation: sizingInformation)),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        child: Footer(sizingInformation: sizingInformation))
                  ],
                ),
              ),
            ));
      },
    );
  }

  _bodyWidget({required SizingInformationModel sizingInformation}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: isLoaded
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _pageViewBuilder(sizingInformation: sizingInformation),
          _buttonContainer(sizingInformation: sizingInformation),
          const SizedBox(
            height: 20,
          ),
          _breederCharacteristics(sizingInformation: sizingInformation),
          if (advertDetailViewModel.mother_examinations!.isNotEmpty)
            _petBondHealthCheck(sizingInformation: sizingInformation),
          _breederInformation(sizingInformation: sizingInformation),
          const SizedBox(
            height: 30,
          ),
        ],
      )
          : CustomWidgets.box(
          sizingInformation: sizingInformation, txt: "No Data Found"),
    );
  }

  //------------------Slider--------------
  _pageViewBuilder({required SizingInformationModel sizingInformation}) {
    return SizedBox(
      height: sizingInformation.safeBlockHorizontal * 250,
      child: PageView.builder(
        itemCount: advertDetailViewModel.pets?.length,
        itemBuilder: (context, index) {
          return PageView(
            onPageChanged: (int index) {
              setState(() {
                count = index + 1;
              });
            },
            controller: _controller,
            children: advertDetailViewModel.pets!
                .map((e) => petPageViewBuilder(
                e,
                advertDetailViewModel.pets?.length,
                index,
                sizingInformation))
                .toList(),
          );
        },
      ),
    );
  }

  //-----------------Pet Data-------------------
  Widget petPageViewBuilder(AdvertDetailViewPetModel petModel, length, index,
      SizingInformationModel sizingInformation) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 7,
                child: Text(
                  "Name: ${petModel.name}",
                  style: const TextStyle(
                      color: ColorValues.fontColor,
                      fontSize: 20,
                      fontFamily: "FredokaOne"),
                ),
              ),
              Text(
                petModel.price != null ? "€${petModel.price}" : "€",
                style: const TextStyle(
                    color: ColorValues.fontColor,
                    fontSize: 20,
                    fontFamily: "FredokaOne"),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "$count of a litter of $length from a beautiful mother and father.",
            style: style,
          ),
          const SizedBox(
            height: 10,
          ),
          if (advertDetailViewModel.description != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                advertDetailViewModel.description!,
                overflow: TextOverflow.ellipsis,
                style:
                TextStyle(color: ColorValues.darkerGreyColor, fontSize: 16),
              ),
            ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
                child: const Text(
                  "View Pet",
                  style: TextStyle(
                    fontFamily: 'FredokaOne',
                    color: ColorValues.fontColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  //print("https://petbond.ie/pet-listing${widget.advertUrl}");
                  Helper.launchAdvertPetbondWebApp(
                      advertUrl: widget.advertUrl.toString());
                }),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AssetValues.breedSvg),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text("Breed: ${advertDetailViewModel.name}",
                              style: style1),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (differenceInDays != null && reHome != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(AssetValues.calenderSvg),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              "$differenceInDays days old: $reHome days left to rehome",
                              style: style1,
                            ),
                          )
                        ],
                      ),
                  ],
                ),
              ),
              if (advertDetailViewModel.user != null &&
                  advertDetailViewModel.user!.kenney_club != null)
                Column(
                  children: [
                    const Text(
                      "Irish Kennel Club\n        Member",
                      style: TextStyle(
                          color: ColorValues.kennyColor, fontSize: 12),
                    ),
                    Image.asset(
                      AssetValues.kennyJpg,
                      height: 70,
                    ),
                  ],
                ),
            ],
          ),
          CustomWidgets.customNetworkImageTwo(
              imageUrl: BaseUrl.getImageBaseUrl() + petModel.photo.toString(),
              sizingInformation: sizingInformation),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (petModel.gender != null)
                _textWithLabel(
                    lable: "Sex:", value: petModel.gender.toString()),
              _textWithLabel(
                  lable: "Location:",
                  value: advertDetailViewModel.user!.city!.name.toString()),
              if (petModel.color != null)
                _textWithLabel(
                    lable: "Color:", value: petModel.color.toString()),
              _textWithLabel(
                  lable: "From litter of:", value: length.toString()),
              if (advertDetailViewModel.mother_name != null)
                _textWithLabel(
                    lable: "Mother:",
                    value: advertDetailViewModel.mother_name.toString()),
              if (advertDetailViewModel.father_name != null)
                _textWithLabel(
                    lable: "Father:",
                    value: advertDetailViewModel.father_name.toString()),
              petModel.chip_number!.contains(RegExp(r'[a-z]'))
                  ? const SizedBox()
                  : _textWithLabel(
                  lable: "Microchip No:",
                  value: petModel.chip_number.toString()),
              if (advertDetailViewModel.user!.reg_number != null)
                _textWithLabel(
                    lable: "Dept Agriculture:",
                    value: advertDetailViewModel.user!.reg_number.toString()),
            ],
          ),
        ],
      ),
    );
  }

  //------------Next & Previous Button------------------

  _buttonContainer({required SizingInformationModel sizingInformation}) {
    return Row(
      children: [
        CustomWidgets.iconButtonNext(
            text: "Previous",
            onPressed: () {
              setState(() {
                int page = _controller.page!.toInt();
                _controller.animateToPage(
                  page - 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              });
            },
            sizingInformation: sizingInformation,
            showPrevious: true),
        const Spacer(),
        Text("$count / $length"),
        const Spacer(),
        CustomWidgets.iconButtonNext(
            text: "Next",
            onPressed: () {
              setState(() {
                int page = _controller.page!.toInt();
                _controller.animateToPage(
                  page + 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              });
            },
            sizingInformation: sizingInformation,
            showPrevious: false),
      ],
    );
  }

  _breederCharacteristics({required SizingInformationModel sizingInformation}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Breed Characteristics",
          style: TextStyle(
              fontFamily: "NotoSans",
              fontSize: 18,
              color: ColorValues.fontColor),
        ),
        const Divider(
          thickness: 2,
          color: ColorValues.fontColor,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            width: sizingInformation.screenWidth,
            decoration: BoxDecoration(
                color: ColorValues.lightGreyColor.withOpacity(0.4),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text("Size...")),
                      Expanded(
                          child: RatingContainer.getContainer(
                              advertDetailViewModel.size!)),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: showSize
                              ? GestureDetector(
                            onTap: () {
                              setState(() {
                                showSize = false;
                              });
                            },
                            child: const Icon(
                              Icons.minimize,
                              color: ColorValues.fontColor,
                            ),
                          )
                              : GestureDetector(
                              onTap: () {
                                setState(() {
                                  showSize = true;
                                });
                              },
                              child: const Icon(
                                Icons.add_circle_outline,
                                color: ColorValues.fontColor,
                              )),
                        ),
                      )
                    ],
                  ),
                  if (showSize == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        advertDetailViewModel.size_desc.toString(),
                        style: style1,
                      ),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Expanded(child: Text("Energy...")),
                      Expanded(
                          child: RatingContainer.getContainer(
                              advertDetailViewModel.energy!)),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: showEnergy
                              ? GestureDetector(
                            onTap: () {
                              setState(() {
                                showEnergy = false;
                              });
                            },
                            child: const Icon(
                              Icons.minimize,
                              color: ColorValues.fontColor,
                            ),
                          )
                              : GestureDetector(
                              onTap: () {
                                setState(() {
                                  showEnergy = true;
                                });
                              },
                              child: const Icon(
                                Icons.add_circle_outline,
                                color: ColorValues.fontColor,
                              )),
                        ),
                      )
                    ],
                  ),
                  if (showEnergy == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        advertDetailViewModel.energy_desc.toString(),
                        style: style1,
                      ),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Expanded(child: Text("Lifespan...")),
                      Expanded(
                          child: RatingContainer.getContainer(
                              advertDetailViewModel.life_span!)),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: showLifeSpan
                              ? GestureDetector(
                            onTap: () {
                              setState(() {
                                showLifeSpan = false;
                              });
                            },
                            child: const Icon(
                              Icons.minimize,
                              color: ColorValues.fontColor,
                            ),
                          )
                              : GestureDetector(
                              onTap: () {
                                setState(() {
                                  showLifeSpan = true;
                                });
                              },
                              child: const Icon(
                                Icons.add_circle_outline,
                                color: ColorValues.fontColor,
                              )),
                        ),
                      )
                    ],
                  ),
                  if (showLifeSpan == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        advertDetailViewModel.life_span_desc.toString(),
                        style: style1,
                      ),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Expanded(child: Text("Grooming...")),
                      Expanded(
                          child: RatingContainer.getContainer(
                              advertDetailViewModel.grooming!)),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: showGrooming
                              ? GestureDetector(
                            onTap: () {
                              setState(() {
                                showGrooming = false;
                              });
                            },
                            child: const Icon(
                              Icons.minimize,
                              color: ColorValues.fontColor,
                            ),
                          )
                              : GestureDetector(
                              onTap: () {
                                setState(() {
                                  showGrooming = true;
                                });
                              },
                              child: const Icon(
                                Icons.add_circle_outline,
                                color: ColorValues.fontColor,
                              )),
                        ),
                      )
                    ],
                  ),
                  if (showGrooming == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        advertDetailViewModel.grooming_desc.toString(),
                        style: style1,
                      ),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Expanded(child: Text("Living Space...")),
                      Expanded(
                          child: RatingContainer.getContainer(
                              advertDetailViewModel.living_space!)),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: showLivingSpace
                              ? GestureDetector(
                            onTap: () {
                              setState(() {
                                showLivingSpace = false;
                              });
                            },
                            child: const Icon(
                              Icons.minimize,
                              color: ColorValues.fontColor,
                            ),
                          )
                              : GestureDetector(
                              onTap: () {
                                setState(() {
                                  showLivingSpace = true;
                                });
                              },
                              child: const Icon(
                                Icons.add_circle_outline,
                                color: ColorValues.fontColor,
                              )),
                        ),
                      )
                    ],
                  ),
                  if (showLivingSpace == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        advertDetailViewModel.living_space_desc.toString(),
                        style: style1,
                      ),
                    ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  _petBondHealthCheck({required SizingInformationModel sizingInformation}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "PetBond Health Check",
          style: TextStyle(
              fontFamily: "NotoSans",
              fontSize: 18,
              color: ColorValues.fontColor),
        ),
        const Divider(
          thickness: 2,
          color: ColorValues.fontColor,
        ),
        const SizedBox(
          height: 20,
        ),
        GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: ColorValues.parrotColor,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  height: 30,
                  width: 30,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.network(
                        advertDetailViewModel.mother_examinations![index].icon
                            .toString(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                // Text(breedList![index].name),
                Text(
                    "${advertDetailViewModel.mother_examinations![index].name![0].toUpperCase()}${advertDetailViewModel.mother_examinations![index].name!.substring(1).toLowerCase()}",
                    style: style),
              ],
            );
          },
          itemCount: advertDetailViewModel.mother_examinations!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 4),
        ),
        const SizedBox(
          height: 20,
        ),
        if (advertDetailViewModel.pets != null &&
            advertDetailViewModel.pets![0].pet_verified_by != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: RichText(
              text: TextSpan(
                  text:
                  'This health check was performed by a Petbond Recommended Veterinarian practice: ',
                  style: const TextStyle(color: ColorValues.fontColor),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                        "${advertDetailViewModel.pets![0].pet_verified_by}",
                        style: const TextStyle(
                            color: ColorValues.fontColor,
                            fontWeight: FontWeight.bold))
                  ]),
            ),
          ),
      ],
    );
  }

  _breederInformation({required SizingInformationModel sizingInformation}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Breeder Information",
          style: TextStyle(
              fontFamily: "NotoSans",
              fontSize: 18,
              color: ColorValues.fontColor),
        ),
        const Divider(
          thickness: 2,
          color: ColorValues.fontColor,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: CustomWidgets.customNetworkImage(
                  imageUrl: BaseUrl.getImageBaseUrl() +
                      advertDetailViewModel.user!.avatar.toString(),
                  height: sizingInformation.safeBlockHorizontal * 28,
                  sizingInformation: sizingInformation),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  if (advertDetailViewModel.user! != null &&
                      advertDetailViewModel.user!.kenney_club != null)
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: SvgPicture.asset(
                            AssetValues.starSvg,
                            height: 25,
                          ),
                        ),
                        Flexible(
                            child: Text("Kennel Club Member", style: style))
                      ],
                    ),
                  if (advertDetailViewModel.pets != null &&
                      advertDetailViewModel.pets![0].pet_verified_by != null)
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: SvgPicture.asset(
                            AssetValues.plusSvg,
                            height: 25,
                          ),
                        ),
                        Flexible(
                            child: Text(
                              "Vet Approved Breeder",
                              style: style,
                            ))
                      ],
                    ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: SvgPicture.asset(
                          AssetValues.checkSvg,
                          height: 25,
                        ),
                      ),
                      Flexible(
                          child: Text("PetBond Authenticated Breeder",
                              style: style))
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          advertDetailViewModel.user!.bio.toString(),
          style: style,
        ),
      ],
    );
  }

  _textWithLabel({required String lable, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  lable,
                  style: const TextStyle(
                      color: ColorValues.darkerGreyColor, fontSize: 14),
                ),
              ),
              const Spacer(),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                      color: ColorValues.darkerGreyColor, fontSize: 14),
                ),
              )
            ],
          ),
          const Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }
}
