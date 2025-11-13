import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petbond_uk/models/breeder/advert/pet.dart';
import 'custom_widgets.dart';

class CustomPetsContainer extends StatelessWidget {
  final String? name;
  final String? breed;
  final String? image;
  final String? dob;
  final int? soldCount;
  final int? petCount;
  final dynamic price;
  final String? mother;
  final String? father;
  final bool showDeleteButton;
  final String? status;
  final VoidCallback onEditPress;
  final VoidCallback onViewPress;
  final VoidCallback onDeletePress;
  final Widget? priceFrom;
  final List<PetModel>? petModel;
  final SizingInformationModel sizingInformation;

  const CustomPetsContainer(
      {Key? key, this.name,
      this.breed,
      this.image,
      this.soldCount,
      this.petCount,
      this.price,
      this.dob,
      this.mother,
      this.father,
      this.petModel,
      this.status,
      this.priceFrom,
      required this.onEditPress,
      required this.onViewPress,
      required this.onDeletePress,
      required this.showDeleteButton,
      required this.sizingInformation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                image == null
                    ? const SizedBox()
                    : CustomWidgets.customNetworkImage(
                        imageUrl: BaseUrl.getImageBaseUrl() + image!,
                        height: sizingInformation.safeBlockHorizontal * 30,
                        sizingInformation: sizingInformation),
                const SizedBox(
                  height: 10,
                ),
                if (!(status == "approved" && petCount == soldCount))
                  CustomWidgets.iconButton(
                      text: "Edit",
                      onPressed: onEditPress,
                      buttonColor: ColorValues.lightGreyColor,
                      asset: AssetValues.editIcon,
                      sizingInformation: sizingInformation),
                if (showDeleteButton == true)
                  if (!(status == "approved" && petCount == soldCount))
                    CustomWidgets.buttonWithoutFontFamily(
                        text: "Delete                   ",
                        onPressed: onDeletePress,
                        buttonColor: ColorValues.redColor,
                        borderColor: ColorValues.redColor,
                        sizingInformation: sizingInformation)
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  if (!(status == "approved" && petCount == soldCount))
                    GestureDetector(
                      onTap: onEditPress,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: ColorValues.parrotColor,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        height: 30,
                        width: 30,
                        child: Center(
                          child: SvgPicture.asset(
                            AssetValues.injectionIcon,
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: onViewPress,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: ColorValues.parrotColor,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      height: 30,
                      width: 30,
                      child: Center(
                        child: SvgPicture.asset(
                          AssetValues.eyeIcon,
                          height: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (name != null)
                    Text(
                      "$name",
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: ColorValues.fontColor, fontSize: 18),
                    ),
                  if (name != null)
                    Container(
                      height: 1.5,
                      width: sizingInformation.screenWidth / 2.3,
                      color: ColorValues.lightGreyColor,
                    ),
                  if (breed != null)
                    const SizedBox(
                      height: 8,
                    ),
                  if (breed != null) Text("Breed : $breed"),
                  if (breed != null)
                    Container(
                      height: 1.5,
                      width: sizingInformation.screenWidth / 2.3,
                      color: ColorValues.lightGreyColor,
                    ),
                  if (petCount != null || soldCount != null)
                    const SizedBox(
                      height: 8,
                    ),
                  if (petCount != 0 || soldCount != 0)
                    Text("Puppies sold: $soldCount of $petCount"),
                  if (petCount != 0 || soldCount != 0)
                    Container(
                      height: 1.5,
                      width: sizingInformation.screenWidth / 2.3,
                      color: ColorValues.lightGreyColor,
                    ),
                  if (dob != null)
                    const SizedBox(
                      height: 8,
                    ),
                  if (dob != null) Text("dob : $dob"),
                  if (dob != null)
                    Container(
                      height: 1.5,
                      width: sizingInformation.screenWidth / 2.3,
                      color: ColorValues.lightGreyColor,
                    ),
                  // if (price != null)
                  //   SizedBox(
                  //     height: 8,
                  //   ),
                  // price != null ? Text("Price : £${price}.00") : SizedBox(),
                  // if (price != null)
                  //   Container(
                  //     height: 1.5,
                  //     width: sizingInformation.screenWidth / 2.3,
                  //     color: ColorValues.lightGreyColor,
                  //   ),
                  if (petModel!.isNotEmpty)
                    const SizedBox(
                      height: 5,
                    ),
                  if (petModel!.isNotEmpty && priceFrom != null) priceFrom!,
                  if (petModel!.isNotEmpty)
                    Container(
                      height: 1.5,
                      width: sizingInformation.screenWidth / 2.3,
                      color: ColorValues.lightGreyColor,
                    ),
                  if (mother != null)
                    const SizedBox(
                      height: 8,
                    ),
                  if (mother != null) Text("Mother : $mother"),
                  if (mother != null)
                    Container(
                      height: 1.5,
                      width: sizingInformation.screenWidth / 2.3,
                      color: ColorValues.lightGreyColor,
                    ),
                  if (father != null)
                    const SizedBox(
                      height: 8,
                    ),
                  if (father != null) Text("Father : $father"),
                  if (father != null)
                    Container(
                      height: 1.5,
                      width: sizingInformation.screenWidth / 2.3,
                      color: ColorValues.lightGreyColor,
                    ),
                  if (status != null)
                    const SizedBox(
                      height: 8,
                    ),
                  if (status != null)
                    Text(
                        "Status : ${status![0].toUpperCase()}${status!.substring(1).toLowerCase()}"),
                  if (status != null)
                    Container(
                      height: 1.5,
                      width: sizingInformation.screenWidth / 2.3,
                      color: ColorValues.lightGreyColor,
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
          )
        ],
      ),
    );
  }
}
