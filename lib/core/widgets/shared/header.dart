import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/routes/routes.dart';
import 'package:petbond_uk/core/services/secure_storage.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/core/widgets/globals.dart' as Globals;
import 'package:petbond_uk/core/widgets/shared/footer.dart';
import 'package:petbond_uk/modules/createStripe/webview_stripe.dart';
import 'package:petbond_uk/services/auth/auth_services.dart';
import 'package:petbond_uk/services/connect_account/connect_services.dart';
import '../../utils/base_url.dart';
import '../../utils/helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthorizedHeader extends StatefulWidget {
  final SizingInformationModel sizingInformation;
  final String dashBoardTitle;
  final Widget widget;
  final bool? showHeader;
  final bool? showCardWidget;
  // final VoidCallback? onTap;
  final double? titleWidth;
  // final Widget drawerIcon;

  AuthorizedHeader({
    required this.sizingInformation,
    // required this.drawerIcon,
    this.titleWidth,
    this.showCardWidget = false,
    this.showHeader = false,
    // this.onTap,
    required this.dashBoardTitle,
    required this.widget,
  });

  @override
  State<AuthorizedHeader> createState() => _AuthorizedHeaderState();
}

class _AuthorizedHeaderState extends State<AuthorizedHeader> {
  SecureStorage _secureStorage = SecureStorage();
  AuthServices authServices = AuthServices();
  ConnectServices connectServices = ConnectServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.sizingInformation.screenHeight,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage(AssetValues.bgJpg))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: <Widget>[
                Image(
                  image: AssetImage(AssetValues.appBar_Image),
                  fit: BoxFit.fill,
                  height: 180,
                  width: widget.sizingInformation.screenWidth,
                ),
                // Positioned(right: 20, top: 60, child: widget.drawerIcon),
                Positioned(
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
                  bottom: 10,
                  left: 20,
                  child: SizedBox(
                    width: widget.sizingInformation.screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            child: Container(
                              height:
                                  widget.sizingInformation.safeBlockHorizontal *
                                      11,
                              width: widget.titleWidth ??
                                  widget.sizingInformation.safeBlockHorizontal *
                                      50,
                              decoration: BoxDecoration(
                                  color: ColorValues.fontColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: const [
                                      Text("Open Menu",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          )),
                                      Spacer(),
                                      Icon(
                                        Icons.settings,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          //  ----------------  Scanner Button-------------------------?>>>>>>

                          Spacer(
                            flex: 10,
                          ),
                          if (widget.showHeader == true)
                            GestureDetector(
                              onTap: () {
                                showGeneralDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierLabel:
                                    MaterialLocalizations.of(context)
                                        .modalBarrierDismissLabel,
                                    barrierColor: Colors.black45,
                                    transitionDuration:
                                    const Duration(milliseconds: 200),
                                    pageBuilder: (BuildContext buildContext,
                                        Animation animation,
                                        Animation secondaryAnimation) {
                                      return Center(
                                          child: FutureBuilder(
                                              future: _secureStorage
                                                  .readStore('qr_code'),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return Container(
                                                    height: widget
                                                        .sizingInformation
                                                        .safeBlockHorizontal *
                                                        80,
                                                    width: widget
                                                        .sizingInformation
                                                        .safeBlockHorizontal *
                                                        80,
                                                    padding:
                                                    const EdgeInsets.all(
                                                        20),
                                                    color: Colors.white,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        SvgPicture.network(
                                                          BaseUrl.getImageBaseUrl() +
                                                              snapshot.data
                                                                  .toString(),
                                                          width: widget
                                                              .sizingInformation
                                                              .safeBlockHorizontal *
                                                              40,
                                                          height: widget
                                                              .sizingInformation
                                                              .safeBlockHorizontal *
                                                              40,
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                          "This QR code is used to connect your Petbond account to a Vet practice enrolled with Petbond, this will allow your Vet to upload and verify puppies in your adverts.",
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                              }));
                                    });
                              },
                              child: Container(
                                height: widget
                                        .sizingInformation.safeBlockHorizontal *
                                    11,
                                decoration: BoxDecoration(
                                    color: ColorValues.fontColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Icon(
                                      Icons.qr_code,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            if (Globals.GlobalData.showVerifyPopUp == true)
              CustomWidgets.verifyPopUp(
                  sizingInformation: widget.sizingInformation,
                  onTap: () {
                    authServices
                        .resendVerificationEmail(context: context)
                        .then((value) {
                      if (value == 200) {
                        Helper.showErrorAlert(context,
                            title: "Success",
                            content:
                                "Email Verification Link Sent Successfully",
                            onPressed: () {});
                      } else if (value == 208) {
                        Helper.showErrorAlert(context,
                            title: "Success",
                            content: "Email is already verified",
                            onPressed: () {
                          setState(() {
                            Globals.GlobalData.showVerifyPopUp = false;
                            _secureStorage.setStore(
                                'email_verified', "verified");
                          });
                        });
                      }
                    });
                  }),
            // if (Globals.GlobalData.showVerifyPopUp == false &&
            //     widget.dashBoardTitle == "BREEDER" &&
            //     Globals.GlobalData.showStripeAccountPopUp == true)
            //   CustomWidgets.createStripePopUp(
            //       sizingInformation: widget.sizingInformation,
            //       onTap: () {
            //         connectServices.createStripeAccount(context: context);
            //       }),
            if (Globals.GlobalData.showVerifyPopUp == false &&
                widget.dashBoardTitle == "BREEDER" &&
                Globals.GlobalData.showStripeAccountPopUp == false &&
                Globals.GlobalData.showTransferUnablePopUp == true)
              CustomWidgets.transferUnablePopUp(
                  sizingInformation: widget.sizingInformation,
                  onTap: () {
                    Helper.launchURL();
                  }),
            widget.showCardWidget == false
                ? Padding(
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
                    child: widget.widget,
                  )),
            )
                : widget.widget,
            const SizedBox(
              height: 25,
            ),
            Align(
                alignment: FractionalOffset.bottomCenter,
                child: Footer(sizingInformation: widget.sizingInformation))
          ],
        ),
      ),
    );
  }
}
