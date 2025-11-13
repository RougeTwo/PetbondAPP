import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petbond_uk/core/utils/file_compat.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/widgets/custom_loader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/breeder/advert/pet.dart';

class Helper {
  static Future<void> _launch(Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      throw 'Could not launch $uri';
    }
  }
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

  static Future<File?> imagePicker({required ImageSource imageSource}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? x = await picker.pickImage(source: imageSource);
    if (x == null) return null;
    if (kIsWeb) {
      return null;
    }
    return File(x.path);
  }

  static void launchURL() async {
    await _launch(Uri.parse("https://dashboard.stripe.com/login"));
  }

  static void freeServicesLaunchURL() async {
    await _launch(Uri.parse("https://petbond.ie/app/freeservices"));
  }

  static void launchFacebook() async {
    await _launch(Uri.parse("https://www.facebook.com/petbondireland"));
  }

  static void launchInstagram() async {
    await _launch(Uri.parse("https://www.instagram.com/pet_bond/"));
  }

  static void launchTwitter() async {
    await _launch(Uri.parse("https://twitter.com/petbond_ireland"));
  }

  static void launchYoutube() async {
    await _launch(Uri.parse(
        "https://www.youtube.com/channel/UCjL7H8i0eZmDCDs21CbiWkQ"));
  }

  static void launchWhatsapp() async {
    await _launch(Uri.parse(
        "https://api.whatsapp.com/message/HXCBD4SYVI65H1?autoload=1&app_absent=0"));
  }

  static void launchPetbondWebApp() async {
    await _launch(Uri.parse("https://petbond.co.uk/"));
  }

  static void launchAdvertPetbondWebApp({required String advertUrl}) async {
    await _launch(Uri.parse("https://petbond.co.uk$advertUrl"));
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
        const Text("Price from : "),
        Flexible(
          child: Wrap(
            children: items,
          ),
        ),
      ],
    );
  }
}
