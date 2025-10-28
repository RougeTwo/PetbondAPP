// import 'package:flutter/material.dart';
// import 'package:petbond_uk/core/services/secure_storage.dart';
// import 'package:petbond_uk/core/utils/sizing_information_model.dart';
// import 'package:petbond_uk/modules/breeder/advertise_pet/advertise_pet_step_one.dart';
// import 'package:petbond_uk/modules/breeder/advertise_pet/advertise_pet_step_two_create.dart';
// import 'package:petbond_uk/modules/breeder/advertise_pet/advertise_pet_step_two_update.dart';
// import 'package:petbond_uk/services/breeder/breeder_services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../../../core/utils/base_url.dart';
// import '../../../core/values/asset_values.dart';
// import '../../../core/values/color_values.dart';
// import '../../../core/widgets/base_widget.dart';
// import '../../../core/widgets/shared/header.dart';
// import '../breeder_overview.dart';
//
// class AdvertSaleOverview extends StatefulWidget {
//   final SizingInformationModel sizingInformation;
//   final String behaviour;
//   final int? id;
//
//   const AdvertSaleOverview(
//       {Key? key,
//       required this.sizingInformation,
//       required this.behaviour,
//       this.id})
//       : super(key: key);
//
//   @override
//   State<AdvertSaleOverview> createState() => _AdvertSaleOverviewState();
// }
//
// class _AdvertSaleOverviewState extends State<AdvertSaleOverview> {
//   BreederServices breederServices = BreederServices();
//   SecureStorage secureStorage = SecureStorage();
//   String? qrImage;
//   bool imageLoaded = false;
//
//   readQR() async {
//     qrImage = await secureStorage.readStore('qr_code');
//     if (qrImage != null) {
//       setState(() {
//         imageLoaded = true;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     breederServices.getAdvertValidate(context: context).then((value) {
//       if (value == 1) {
//         Future.delayed(Duration.zero, () {
//           Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => AdvertisePetStepOne(
//                       behaviour: widget.behaviour, id: widget.id)));
//         });
//       } else if (value == 2) {
//         if (widget.behaviour == "create") {
//           Future.delayed(Duration.zero, () {
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => AdvertisePetStepTwoCreate(
//                         behaviour: widget.behaviour)));
//           });
//         } else if (widget.behaviour == "edit") {
//           Future.delayed(Duration.zero, () {
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => AdvertisePetStepTwoUpdate(
//                         behaviour: widget.behaviour, id: widget.id)));
//           });
//         }
//       } else {
//         Future.delayed(Duration.zero, () {
//           Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => AdvertisePetStepOne(
//                       behaviour: widget.behaviour, id: widget.id)));
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseWidget(
//       builder: (context, sizingInformation) {
//         return Scaffold(
//             drawer: Theme(
//                 data: Theme.of(context).copyWith(
//                   canvasColor: ColorValues
//                       .fontColor, //This will change the drawer background to blue.
//                   //other styles
//                 ),
//                 child: Align(
//                   alignment: Alignment.topLeft,
//                   child: ClipRRect(
//                     // borderRadius: BorderRadius.only(
//                     //     topRight: Radius.circular(12),
//                     // ),
//                     child: Drawer(
//                       elevation: 10,
//                       child: SingleChildScrollView(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(
//                               height: 42,
//                             ),
//                             Material(
//                               elevation: 5,
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 15, vertical: 8),
//                                 child: Row(
//                                   children: [
//                                     const Text(
//                                       "Breeder DashBoard",
//                                       style: TextStyle(
//                                           color: Colors.white, fontSize: 16),
//                                     ),
//                                     const Spacer(),
//                                     IconButton(
//                                         onPressed: () => Navigator.pop(context),
//                                         icon: const Icon(
//                                           Icons.close,
//                                           color: Colors.white,
//                                           size: 25,
//                                         ))
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             // _drawerItems(sizingInformation: sizingInformation)
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 )),
//             backgroundColor: ColorValues.backgroundColor,
//             body: AuthorizedHeader(
//               showHeader: true,
//               onTap: () {
//                 readQR();
//                 showGeneralDialog(
//                     context: context,
//                     barrierDismissible: true,
//                     barrierLabel: MaterialLocalizations.of(context)
//                         .modalBarrierDismissLabel,
//                     barrierColor: Colors.black45,
//                     transitionDuration: const Duration(milliseconds: 200),
//                     pageBuilder: (BuildContext buildContext,
//                         Animation animation, Animation secondaryAnimation) {
//                       return Center(
//                         child: Container(
//                           height: sizingInformation.safeBlockHorizontal * 60,
//                           width: sizingInformation.safeBlockHorizontal * 60,
//                           padding: EdgeInsets.all(20),
//                           color: Colors.white,
//                           child: Container(
//                             child: imageLoaded == true
//                                 ? SvgPicture.network(
//                                     BaseUrl.getImageBaseUrl() + qrImage!,
//                                     width:
//                                         sizingInformation.safeBlockHorizontal *
//                                             20,
//                                     height:
//                                         sizingInformation.safeBlockHorizontal *
//                                             20,
//                                   )
//                                 : Container(),
//                           ),
//                         ),
//                       );
//                     });
//               },
//               dashBoardTitle: "BREEDER",
//               drawerIcon: Builder(builder: (context) {
//                 return GestureDetector(
//                   onTap: () => Scaffold.of(context).openDrawer(),
//                   child: SvgPicture.asset(
//                     AssetValues.menuIcon,
//                     height: 30,
//                   ),
//                 );
//               }),
//               widget: BreederOverview(
//                 sizingInformation: sizingInformation,
//               ),
//               sizingInformation: sizingInformation,
//             ));
//       },
//     );
//   }
// }
