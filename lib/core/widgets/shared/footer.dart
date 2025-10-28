import 'package:flutter/material.dart';
import 'package:petbond_uk/core/utils/helper.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';

class Footer extends StatelessWidget {
  final SizingInformationModel sizingInformation;

  Footer({required this.sizingInformation});

  @override
  Widget build(BuildContext context) {
    return Align(
      heightFactor: 1.7,
      alignment: Alignment.bottomCenter,
      child: Container(
        height: sizingInformation.safeBlockHorizontal * 40,
        width: sizingInformation.screenWidth,
        decoration: BoxDecoration(color: ColorValues.bottomContainerColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AssetValues.orangeLogoSvg,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.4,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => Helper.launchFacebook(),
                  child: CircleAvatar(
                    radius: 15,
                    child: SvgPicture.asset(
                      AssetValues.facebookSvg,
                      width: 15,
                      height: 15,
                      color: ColorValues.fontColor,
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => Helper.launchInstagram(),
                  child: CircleAvatar(
                    radius: 15,
                    child: SvgPicture.asset(
                      AssetValues.instaSvg,
                      width: 15,
                      height: 15,
                      color: ColorValues.fontColor,
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => Helper.launchTwitter(),
                  child: CircleAvatar(
                    radius: 15,
                    child: SvgPicture.asset(
                      AssetValues.twitterSvg,
                      width: 15,
                      height: 15,
                      color: ColorValues.fontColor,
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => Helper.launchYoutube(),
                  child: CircleAvatar(
                    radius: 15,
                    child: SvgPicture.asset(
                      AssetValues.youtubeSvg,
                      width: 12,
                      height: 15,
                      color: ColorValues.fontColor,
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
                child: const Text(
                  "Go to PetBond Website",
                  style: TextStyle(
                    // fontFamily: 'FredokaOne',
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  Helper.launchPetbondWebApp();
                }),
          ],
        ),
      ),
    );
  }
}
