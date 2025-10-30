import 'package:flutter/material.dart';
import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'custom_widgets.dart';

class CustomPetsSaleContainer extends StatelessWidget {
  final String? name;
  final String? image;
  final String? dob;
  final String? price;
  final String? mother;
  final String? father;
  final String? paymentType;
  final String? petName;
  final dynamic remaining_amount;
  final SizingInformationModel sizingInformation;

  CustomPetsSaleContainer(
      {this.name,
      this.image,
      this.price,
      this.dob,
      this.mother,
      this.father,
      this.paymentType,
      this.petName,
      this.remaining_amount,
      required this.sizingInformation});

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
                    ? SizedBox()
                    : CustomWidgets.customNetworkImage(
                        imageUrl: BaseUrl.getImageBaseUrl() + image!,
                        height: sizingInformation.safeBlockHorizontal * 30,
                        sizingInformation: sizingInformation),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 0,
            ),
          ),
          // Expanded(
          //   flex: 2,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 8),
          //     child: Column(
          //       children: [
          //         Container(
          //           decoration: BoxDecoration(
          //               color: ColorValues.parrotColor,
          //               borderRadius: BorderRadius.all(Radius.circular(5))),
          //           height: 30,
          //           width: 30,
          //           child: Center(
          //             child: SvgPicture.asset(
          //               AssetValues.injectionIcon,
          //               height: 20,
          //             ),
          //           ),
          //         ),
          //         SizedBox(
          //           height: 8,
          //         ),
          //         Container(
          //           decoration: BoxDecoration(
          //               color: ColorValues.parrotColor,
          //               borderRadius: BorderRadius.all(Radius.circular(5))),
          //           height: 30,
          //           width: 30,
          //           child: Center(
          //             child: SvgPicture.asset(
          //               AssetValues.eyeIcon,
          //               height: 15,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Expanded(
            flex: 5,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (name != null)
                    Text(
                      "Advert Name: " + "$name",
                      overflow: TextOverflow.visible,
                      style:
                          TextStyle(color: ColorValues.fontColor, fontSize: 18),
                    ),
                  if (name != null)
                    Container(
                      height: 1.5,
                      width: sizingInformation.screenWidth / 2.3,
                      color: ColorValues.lightGreyColor,
                    ),
                  if (petName != null || petName != null)
                    SizedBox(
                      height: 8,
                    ),
                  if (petName != null || petName != null)
                    Text("Pet name : $petName"),
                  if (petName != null || petName != null)
                    Container(
                      height: 1.5,
                      width: sizingInformation.screenWidth / 2.3,
                      color: ColorValues.lightGreyColor,
                    ),
                  if (dob != null)
                    SizedBox(
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
                  // if (price != null) Text("Price : £${price}.00"),
                  // if (price != null)
                  //   Container(
                  //     height: 1.5,
                  //     width: sizingInformation.screenWidth / 2.3,
                  //     color: ColorValues.lightGreyColor,
                  //   ),
                  // if (petModel!.isNotEmpty)
                  //   SizedBox(
                  //     height: 5,
                  //   ),
                  // if (petModel!.isNotEmpty) Container(child: priceFrom),
                  // if (petModel!.isNotEmpty)
                  //   Container(
                  //     height: 1.5,
                  //     width: sizingInformation.screenWidth / 2.3,
                  //     color: ColorValues.lightGreyColor,
                  //   ),
                  if (mother != null)
                    SizedBox(
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
                    SizedBox(
                      height: 8,
                    ),
                  if (father != null) Text("Father : $father"),
                  if (father != null)
                    Container(
                      height: 1.5,
                      width: sizingInformation.screenWidth / 2.3,
                      color: ColorValues.lightGreyColor,
                    ),
                  if (paymentType != null)
                    SizedBox(
                      height: 8,
                    ),
                  if (paymentType != null)
                    Text(
                        "Payment Type : ${paymentType![0].toUpperCase()}${paymentType!.substring(1).toLowerCase()}"),
                  if (paymentType != null)
                    Container(
                      height: 1.5,
                      width: sizingInformation.screenWidth / 2.3,
                      color: ColorValues.lightGreyColor,
                    ),
                  if (remaining_amount != 0)
                    SizedBox(
                      height: 8,
                    ),
                  if (remaining_amount != 0)
                    Text("Remaining amount : £$remaining_amount"),
                  if (remaining_amount != 0)
                    Container(
                      height: 1.5,
                      width: sizingInformation.screenWidth / 2.3,
                      color: ColorValues.lightGreyColor,
                    ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
