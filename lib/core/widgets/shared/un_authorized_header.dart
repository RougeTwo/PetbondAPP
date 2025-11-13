import 'package:flutter/material.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/widgets/shared/footer.dart';

class UnAuthorizedHeader extends StatelessWidget {
  final SizingInformationModel sizingInformation;
  final Widget widget;

  const UnAuthorizedHeader({Key? key, 
    required this.sizingInformation,
    required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage(AssetValues.bgJpg))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: <Widget>[
                const Image(
                  image: AssetImage(AssetValues.appBarImage),
                  height: 180,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  top: 40.0,
                  left: 100.0,
                  child: Image.asset(
                    AssetValues.logo,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.55,
                  ),
                ),
                Positioned(
                  top: 55.0,
                  left: 10.0,
                  child: InkWell(
                    onTap: () => {Navigator.pop(context)},
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: Colors.transparent,
                      ),
                      child: const Icon(Icons.arrow_back,
                          color: ColorValues.fontColor, size: 30),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Card(
                  //  color: Colors.white10,
                  shadowColor: Colors.black,
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  //  / clipBehavior: Clip.none,
                  child: SingleChildScrollView(
                    child: widget,
                  )),
            ),
            Footer(
              sizingInformation: sizingInformation,
            )
          ],
        ),
      ),
    );
  }
}
