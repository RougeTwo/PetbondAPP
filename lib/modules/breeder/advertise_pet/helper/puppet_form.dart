// ignore_for_file: no_logic_in_create_state
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/utils/base_url.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/widgets/base_widget.dart';
import 'package:petbond_uk/core/widgets/custom_drop_down_widget.dart';
import 'package:petbond_uk/core/widgets/custom_widgets.dart';
import 'package:petbond_uk/models/breeder/edit_advert/edit_advert_pets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petbond_uk/core/utils/file_universal.dart';

import '../../../../models/shared/sale_commission_tax_model.dart';
import '../../../../services/breeder/breeder_services.dart';
import '../../../../services/shared/sale_commission_tax_service.dart';

typedef OnDelete = Function();

class PuppetForm extends StatefulWidget {
  final EditAdvertPetModel petModel;
  final state = _PuppetFormState();
  final OnDelete? onDelete;
  final String advert_id;

  PuppetForm({
    Key? key,
    required this.petModel,
    required this.advert_id,
    this.onDelete,
  }) : super(key: key);

  @override
  _PuppetFormState createState() => state;

  bool isValid() => state.validate();
}

class _PuppetFormState extends State<PuppetForm> {
  final form = GlobalKey<FormState>();
  String? text;
  final _imagePicker = ImagePicker();
  bool isLoading = false;
  bool commisionValueLoading = false;

  ScrollController scrollController = ScrollController();
  TextEditingController priceController = TextEditingController();
  TextEditingController commissionController = TextEditingController();
  TextEditingController newChipNoController = TextEditingController();
  TextEditingController oldChipNoController = TextEditingController();
  SaleCommissionTaxModel saleCommissionTaxModel = SaleCommissionTaxModel();
  BreederServices breederServices = BreederServices();
  SaleCommissionTaxService saleCommissionTaxService =
      SaleCommissionTaxService();

  getCommissionValue() {
    saleCommissionTaxService.getComissionValue().then((value) {
      setState(() {
        saleCommissionTaxModel = value;
      });
      if (widget.petModel.isNew == false) {
        priceController.text = widget.petModel.price.toString();
        calculate();
      }
    });
  }

  calculate() {
    if (priceController.text.isNotEmpty) {
      var commision = (double.parse(priceController.text) / 100) *
          saleCommissionTaxModel.commissionInPercent;
      var taxAmount = (commision / 100) * saleCommissionTaxModel.taxInPercent;
      var customerValue = double.parse(priceController.text) +
          double.parse(commision.toStringAsFixed(2)) +
          double.parse(taxAmount.toStringAsFixed(2));
      commissionController.text = customerValue.toStringAsFixed(2);
      widget.petModel.price = priceController.text;
    } else {
      commissionController.clear();
    }
  }

  // reverseCalculation() {
  //   if (commissionController.text.isNotEmpty) {
  //     var actualPrice = (int.parse(commissionController.text) /
  //         (1 +
  //             ((saleCommissionTaxModel.commissionInPercent +
  //                     (saleCommissionTaxModel.taxInPercent /
  //                         saleCommissionTaxModel.commissionInPercent)) /
  //                 100)));
  //     priceController.text = actualPrice.round().toString();
  //   } else {
  //     priceController.clear();
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCommissionValue();
    if (widget.petModel.isNew == false) {
      if (widget.petModel.chip_number != null) {
        oldChipNoController.text = widget.petModel.chip_number!;
      }
    }
  }

  decoration({required String hint, required String label}) {
    return InputDecoration(
      // fillColor: fillColor,
      // filled: filled,
      contentPadding: const EdgeInsets.all(8),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: ColorValues.fontColor, width: 2.0),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: ColorValues.lightGreyColor, width: 2.0),
      ),
      hintText: hint,
      labelText: label,
      // label: Text("Something"),
      labelStyle: const TextStyle(color: ColorValues.darkerGreyColor),
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: ColorValues.lightGreyColor)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, sizingInformation) {
        return Form(
          key: form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Puppy ${widget.petModel.index}"),
              if (widget.petModel.isNew == true && widget.petModel.index != 1)
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: widget.onDelete,
                  ),
                ),
              // Text("Puppy no 1"),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                  initialValue: widget.petModel.name,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value) {
                    widget.petModel.name = value;
                  },
                  validator: (val) => val!.length > 1 || val.isEmpty
                      ? null
                      : 'Puppy name is invalid',
                  style: const TextStyle(
                      fontSize: 15.0, color: ColorValues.fontColor),
                  decoration: decoration(
                      hint: "Enter puppy name here", label: "Puppy Name")),
              const SizedBox(
                height: 20,
              ),
              widget.petModel.isNew == true
                  ? newMicroChipNumberTextFied()
                  : editableTextField(),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        style: const TextStyle(color: ColorValues.fontColor),
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: priceController,
                        onSaved: (val) => widget.petModel.price = val,
                        onChanged: (val) {
                          calculate();
                        },
                        validator: (val) =>
                            val!.isNotEmpty ? null : 'Price is invalid',
                        decoration: decoration(
                            hint: "Price you want", label: "Puppy Price")),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                        style: const TextStyle(color: ColorValues.fontColor),
                        initialValue: widget.petModel.color,
                        onChanged: (value) {
                          widget.petModel.color = value;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val) => val!.length > 1 || val.isEmpty
                            ? null
                            : 'Color is invalid',
                        decoration: decoration(
                            hint: "puppy color", label: "Puppy Color")),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  style: const TextStyle(color: ColorValues.fontColor),
                  keyboardType: TextInputType.number,
                  initialValue: widget.petModel.commision,
                  enabled: true,
                  readOnly: true,
                  controller: commissionController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // onChanged: (val) {
                  //   reverseCalculation();
                  // },
                  decoration: InputDecoration(
                    fillColor: ColorValues.lightGreyColor.withValues(alpha: 0.4),
                    filled: true,
                    contentPadding: const EdgeInsets.all(8),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide:
                          BorderSide(color: ColorValues.fontColor, width: 2.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                          color: ColorValues.lightGreyColor, width: 2.0),
                    ),
                    hintText: "Price buyer pay for puppy",
                    labelText: "Price buyer pay for puppy",
                    suffix: tooltip(),
                    // label: Text("Something"),
                    labelStyle:
                        const TextStyle(color: ColorValues.darkerGreyColor),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                            width: 1, color: ColorValues.lightGreyColor)),
                  )),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomDropdownWidget(
                        defaultValue: "Select Gender",
                        selectedValue:
                            widget.petModel.gender?.toString() == null
                                ? "Select Gender"
                                : widget.petModel.gender.toString(),
                        selectedColor: ColorValues.fontColor,
                        onValueChanged: (value) {
                          setState(() {
                            widget.petModel.gender = value!;
                          });
                        },
                        itemList: const ['Select Gender', 'Male', 'Female'],
                        validator: () {}),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (isLoading == true)
                widget.petModel.puppyPhoto != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                          6,
                        ),
                        child: Stack(
                          children: [
                            Image(
                                width:
                                    sizingInformation.safeBlockHorizontal * 25,
                                height:
                                    sizingInformation.safeBlockHorizontal * 40,
                                fit: BoxFit.cover,
                                image: FileImage(File(widget
                                    .petModel.puppyPhoto!.path
                                    .toString()))),
                            Positioned(
                              right: 3,
                              top: 3,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.petModel.puppyPhoto = null;
                                  });
                                },
                                child: const Icon(
                                  Icons.cancel,
                                  color: ColorValues.redColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : widget.petModel.photo != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                              6,
                            ),
                            child: Image(
                                width:
                                    sizingInformation.safeBlockHorizontal * 25,
                                height:
                                    sizingInformation.safeBlockHorizontal * 40,
                                fit: BoxFit.cover,
                                image: NetworkImage(BaseUrl.getImageBaseUrl() +
                                    widget.petModel.photo.toString())),
                          )
                        : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: CustomWidgets.iconButton(
                    text: "UPLOAD PUPPY PHOTO",
                    onPressed: () {
                      _showPicker(context: context, role: "puppy");
                    },
                    buttonColor: ColorValues.lighBlueButton,
                    asset: AssetValues.uploadSvg,
                    fontColor: ColorValues.fontColor,
                    sizingInformation: sizingInformation),
              ),
              const SizedBox(
                height: 5,
              ),
              if (isLoading == true)
                _puppyCertificateWidget(sizingInformation: sizingInformation),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  _puppyCertificateWidget({required SizingInformationModel sizingInformation}) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        _addNewPuppyCertificateImageWidget(
            sizingInformation: sizingInformation),
        if (widget.petModel.certificateImage != null)
          SizedBox(
            height: sizingInformation.safeBlockHorizontal * 5,
          ),
        if (widget.petModel.certificateImage != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomWidgets.buttonWithoutFontFamily(
                sizingInformation: sizingInformation,
                text: 'Cancel',
                width: sizingInformation.safeBlockHorizontal * 25,
                onPressed: () =>
                    setState(() => widget.petModel.certificateImage = null),
                buttonColor: ColorValues.redColor,
                borderColor: ColorValues.redColor,
              ),
              SizedBox(
                width: sizingInformation.safeBlockHorizontal * 5,
              ),
              CustomWidgets.buttonWithoutFontFamily(
                sizingInformation: sizingInformation,
                buttonColor: ColorValues.lightGreyColor,
                borderColor: ColorValues.lightGreyColor,
                text: 'Ok',
                width: sizingInformation.safeBlockHorizontal * 25,
                onPressed: () => setState(() {
                  widget.petModel.newCertificateList
                      .insert(0, widget.petModel.certificateImage);
                  widget.petModel.certificateImage = null;
                }),
              ),
            ],
          ),
        if (widget.petModel.newCertificateList.isNotEmpty ||
            widget.petModel.certificate_details != null)
          if ((widget.petModel.newCertificateList.isNotEmpty ||
                  widget.petModel.certificate_details!.isNotEmpty) &&
              widget.petModel.certificateImage == null)
            SizedBox(
              height: sizingInformation.safeBlockHorizontal * 7,
            ),
        if (widget.petModel.newCertificateList.isNotEmpty ||
            widget.petModel.certificate_details != null)
          if ((widget.petModel.newCertificateList.isNotEmpty ||
                  widget.petModel.certificate_details != null) &&
              widget.petModel.certificateImage == null)
            Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              radius: const Radius.circular(10),
              child: SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    for (XFile? image in widget.petModel.newCertificateList)
                      _buildMotherImageBox(
                          sizingInformation: sizingInformation,
                          image: image,
                          isNetworkImage: false),
                    if (widget.petModel.certificate_details != null)
                      for (String imageUrl
                          in widget.petModel.certificate_details!)
                        _buildMotherImageBox(
                            sizingInformation: sizingInformation,
                            image: imageUrl,
                            isNetworkImage: true),
                  ],
                ),
              ),
            ),
        SizedBox(
          height: sizingInformation.safeBlockHorizontal * 5,
        ),
      ],
    );
  }

  Widget _addNewPuppyCertificateImageWidget(
      {required SizingInformationModel sizingInformation}) {
    return Center(
      child: GestureDetector(
        onTap: () => widget.petModel.certificateImage != null
            ? null
            : _showPicker(context: context, role: "cover"),
        child: widget.petModel.certificateImage != null
            ? Container(
                width: sizingInformation.safeBlockHorizontal * 40,
                height: sizingInformation.safeBlockHorizontal * 60,
                padding:
                    EdgeInsets.all(sizingInformation.safeBlockHorizontal * 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    6,
                  ),
                  child: Image(
                    image:
                        FileImage(File(widget.petModel.certificateImage!.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(
                decoration: const BoxDecoration(
                    color: ColorValues.lighBlueButton,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text("VET VACCINATIONS",
                          style: TextStyle(
                            color: ColorValues.fontColor,
                            fontWeight: FontWeight.normal,
                          )),
                      const Spacer(),
                      SvgPicture.asset(
                        AssetValues.uploadSvg,
                        height: 15,
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildMotherImageBox(
      {required SizingInformationModel sizingInformation,
      dynamic image,
      required bool isNetworkImage}) {
    return Stack(
      children: [
        Row(
          children: [
            SizedBox(
              width: sizingInformation.safeBlockHorizontal * 2.5,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                6,
              ),
              child: SizedBox(
                width: sizingInformation.safeBlockHorizontal * 25,
                height: sizingInformation.safeBlockHorizontal * 40,
                child: isNetworkImage
                    ? Image(
                        image: NetworkImage(image),
                        fit: BoxFit.cover,
                      )
                    : Image(
                        image: FileImage(File(image.path)),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ],
        ),
        Positioned(
          right: sizingInformation.safeBlockHorizontal * 2,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isNetworkImage
                    ? widget.petModel.certificate_details!.remove(image)
                    : widget.petModel.newCertificateList.remove(image);
              });
              if (isNetworkImage == true) {
                String str = image.toString();
                var arr = str.split(BaseUrl.getImageBaseUrl());
                widget.petModel.deletePuppiesImages.add(arr[1]);
              }
            },
            child: Icon(
              Icons.cancel,
              color: ColorValues.redColor,
              size: sizingInformation.fontSize.twentySix,
            ),
          ),
        ),
      ],
    );
  }

  void _showPicker({required BuildContext context, required String role}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery(role: role);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera(role: role);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> _imgFromGallery({required String role}) async {
    _imagePicker
        .pickImage(
      source: ImageSource.gallery,
    )
        .then((pickedFile) {
      if (pickedFile != null) {
        if (role == "cover") {
          setState(() {
            widget.petModel.certificateImage = pickedFile;
            isLoading = true;
          });
        } else if (role == "puppy") {
          setState(() {
            widget.petModel.puppyPhoto = pickedFile;
            isLoading = true;
          });
        }
      }
    });
  }

  Future<void> _imgFromCamera({required String role}) async {
    _imagePicker
        .pickImage(
      source: ImageSource.camera,
    )
        .then((pickedFile) {
      if (pickedFile != null) {
        if (role == "cover") {
          setState(() {
            widget.petModel.certificateImage = pickedFile;
            isLoading = true;
          });
        } else if (role == "puppy") {
          setState(() {
            widget.petModel.puppyPhoto = pickedFile;
            isLoading = true;
          });
        }
      }
    });
  }

  editableTextField() {
    return TextFormField(
        style: const TextStyle(color: ColorValues.fontColor),
        // initialValue: widget.petModel.chip_number,
        maxLength: 15,
        readOnly: true,
        enabled: true,
        controller: oldChipNoController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          fillColor: ColorValues.lightGreyColor.withValues(alpha: 0.4),
          filled: true,
          suffixIcon: onEditChipNumber(),
          //suffix: onEditChipNumber(),
          contentPadding: const EdgeInsets.all(8),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide:
            BorderSide(color: ColorValues.lightGreyColor, width: 2.0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide:
            BorderSide(color: ColorValues.lightGreyColor, width: 2.0),
          ),
          hintText: "000000000000",
          labelText: "Microchip No",
          // label: Text("Something"),
          labelStyle: const TextStyle(color: ColorValues.darkerGreyColor),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide:
              BorderSide(width: 1, color: ColorValues.lightGreyColor)),
        ));
  }

  newMicroChipNumberTextFied() {
    return TextFormField(
        style: const TextStyle(color: ColorValues.fontColor),
        initialValue: widget.petModel.chip_number,
        maxLength: 15,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {
          widget.petModel.chip_number = value;
        },
        decoration: decoration(hint: "00000000000000", label: "Microchip No"));
  }


  tooltip() {
    return Tooltip(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: ColorValues.fontColor, width: 2)),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      waitDuration: const Duration(seconds: 1),
      showDuration: const Duration(seconds: 15),
      triggerMode: TooltipTriggerMode.tap,
      textStyle: const TextStyle(color: ColorValues.fontColor),
      message:
          "A 10% administration fee + VAT is added to the sales price of the puppy. This ensures the service can continue to operate. All our puppies and adverts are vetted by fully qualified vets. Once the puppy is sold, you will recieve the amount requested, plus the vaccination costs.",
      child: Container(
          width: 25,
          // color: Colors.orange,
          child: const Text(
            "?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0),
          ),
          //  width: 50,
          decoration: BoxDecoration(
            //color: Colors.orangeAccent,
            border: Border.all(width: 2),
            shape: BoxShape.circle,
          )),
    );
  }

  ///form validator
  bool validate() {
    var valid = form.currentState!.validate();
    if (valid) form.currentState!.save();
    return valid;
  }

  onEditChipNumber() {
    return GestureDetector(
      onTap: () {
        _displayTextInputDialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SvgPicture.asset(
          AssetValues.editIcon,
          color: ColorValues.fontColor,
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Update Chip Number',
              style: TextStyle(
                  color: ColorValues.fontColor,
                  fontSize: 20,
                  fontFamily: "FredokaOne"),
            ),
            content: TextFormField(
              maxLength: 15,
              controller: newChipNoController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: const TextStyle(fontSize: 15.0, color: ColorValues.fontColor),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide:
                  BorderSide(color: ColorValues.fontColor, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide:
                  BorderSide(color: ColorValues.lightGreyColor, width: 2.0),
                ),
                hintText: "Enter new chip number here",
                labelText: "Microchip No",
                // label: Text("Something"),
                labelStyle: TextStyle(color: ColorValues.darkerGreyColor),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                        width: 1, color: ColorValues.lightGreyColor)),
              ),
            ),
            actions: <Widget>[
              Center(
                child: MaterialButton(
                  color: ColorValues.loginBackground,
                  onPressed: () {
                    breederServices
                        .updatePuppyMicroChipNo(
                        chip_number: newChipNoController.text,
                        pet_id: widget.petModel.pet_id.toString(),
                        context: context,
                        advert_id: widget.advert_id.toString())
                        .then((value) {
                      if (value == 200) {
                        Navigator.pop(context);
                        setState(() {
                          oldChipNoController.text = newChipNoController.text;
                          newChipNoController.clear();
                        });
                      }
                    });
                  },
                  child: const Text("Save chip number",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'FredokaOne')),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              // MaterialButton(
              //   color: Colors.red,
              //   textColor: Colors.white,
              //   child: Text('CANCEL'),
              //   onPressed: () {
              //     setState(() {
              //       Navigator.pop(context);
              //     });
              //   },
              // ),
              // MaterialButton(
              //   color: Colors.green,
              //   textColor: Colors.white,
              //   child: Text('OK'),
              //   onPressed: () {
              //     setState(() {
              //       // codeDialog = valueText;
              //       Navigator.pop(context);
              //     });
              //   },
              // ),
            ],
          );
        });
  }
}
