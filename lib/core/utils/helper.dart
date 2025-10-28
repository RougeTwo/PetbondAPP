import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/widgets/custom_loader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/breeder/advert/pet.dart';

class Helper {
  static void showLoader(BuildContext context, GlobalKey key) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomLoaders.loader(context, key);
        });
  }

  static bool emailRegExp(String text) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return regex.hasMatch(text);
  }

  static void hideLoader(_keyLoader) {
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  static void showErrorAlert(context,
          {required String title,
          required String content,
          required VoidCallback onPressed}) =>
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomLoaders.customAlertDialog(
            content: content,
            title: title,
            onPressed: onPressed,
            context: context,
          );
        },
      );

  static Future<File> imagePicker({required ImageSource imageSource}) async {
    File? image;
    ImagePicker imagePicker = ImagePicker();
    // ignore: deprecated_member_use
    PickedFile? pickedFile = await imagePicker.getImage(source: imageSource);
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    return image!;
  }

  static void launchURL() async {
    if (!await launch("https://dashboard.stripe.com/login"))
      throw 'Could not launch https://dashboard.stripe.com';
  }

  static void freeServicesLaunchURL() async {
    if (!await launch("https://petbond.ie/app/freeservices"))
      throw 'Could not launch https://petbond.ie/app/freeservices';
  }

  static void launchFacebook() async {
    if (!await launch("https://www.facebook.com/petbondireland"))
      throw 'Could not launch https://www.facebook.com/petbondireland';
  }

  static void launchInstagram() async {
    if (!await launch("https://www.instagram.com/pet_bond/"))
      throw 'Could not launch https://www.instagram.com/pet_bond/';
  }

  static void launchTwitter() async {
    if (!await launch("https://twitter.com/petbond_ireland"))
      throw 'Could not launch https://twitter.com/petbond_ireland';
  }

  static void launchYoutube() async {
    if (!await launch(
        "https://www.youtube.com/channel/UCjL7H8i0eZmDCDs21CbiWkQ"))
      throw 'Could not launch https://dashboard.stripe.com';
  }

  static void launchWhatsapp() async {
    if (!await launch(
        "https://api.whatsapp.com/message/HXCBD4SYVI65H1?autoload=1&app_absent=0"))
      throw 'Could not launch https://dashboard.stripe.com';
  }

  static void launchPetbondWebApp() async {
    if (!await launch("https://petbond.co.uk/"))
      throw 'Could not launch https://dashboard.stripe.com';
  }

  static void launchAdvertPetbondWebApp({required String advertUrl}) async {
    if (!await launch("https://petbond.co.uk$advertUrl"))
      throw 'Could not launch https://dashboard.stripe.com';
  }


  static Widget priceList({
    required SizingInformationModel sizingInformation,
    List<PetModel>? list,
  }) {
    List<Widget> items = List.empty(growable: true);
    int index = 0;
    for (var language in list!) {
      items.add(
        Text(
          "£${language.price}.00" + (index == list.length - 1 ? "" : ", "),
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      );
      index++;
    }
    return Row(
      children: [
        Text("Price from : "),
        Flexible(
          child: Wrap(
            children: items,
          ),
        ),
      ],
    );
  }
}
