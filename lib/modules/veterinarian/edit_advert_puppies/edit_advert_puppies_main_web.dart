import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/widgets/base_widget.dart';
import 'package:petbond_uk/core/widgets/shared/header.dart';

class EditAdvertsPuppiesListMain extends StatelessWidget {
  final int? id;
  final int? connect_breeder_id;
  final String? name;
  final dynamic puppyModel; // Unused in web placeholder

  const EditAdvertsPuppiesListMain({
    super.key,
    this.id,
    this.name,
    this.puppyModel,
    this.connect_breeder_id,
  });

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, sizingInformation) {
        return Scaffold(
          backgroundColor: ColorValues.backgroundColor,
          body: AuthorizedHeader(
            titleWidth: sizingInformation.safeBlockHorizontal * 68,
            dashBoardTitle: 'VETERINARIAN DASHBOARD',
            sizingInformation: sizingInformation,
            widget: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
              child: _body(context: context, sizingInformation: sizingInformation),
            ),
          ),
        );
      },
    );
  }

  Widget _body({required BuildContext context, required SizingInformationModel sizingInformation}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name ?? 'Edit Puppy',
          style: const TextStyle(
            color: ColorValues.fontColor,
            fontSize: 18,
            fontFamily: 'FredokaOne',
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Editing adverts and scanning are not available on web.\n'
          'Please use the mobile app for this action.',
          style: TextStyle(color: ColorValues.fontColor),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(ColorValues.loginBackground),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back, color: Colors.white),
                SizedBox(width: 8),
                Text('Back'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
