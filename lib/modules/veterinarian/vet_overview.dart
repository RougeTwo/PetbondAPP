import 'package:flutter/material.dart';
import 'package:petbond_uk/core/utils/sizing_information_model.dart';
import 'package:petbond_uk/core/values/styles.dart';
import 'package:petbond_uk/modules/veterinarian/vet_add_staff.dart';
import 'package:petbond_uk/modules/veterinarian/vet_breeder_register.dart';
import 'package:petbond_uk/modules/veterinarian/vet_connected_breeder.dart';
import 'package:petbond_uk/modules/veterinarian/widgets/dashboard_container.dart';

class VetOverView extends StatelessWidget {
  final SizingInformationModel sizingInformation;

  const VetOverView({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Welcome to PetBond Vet Team Dashboard",
          style: CustomStyles.cardTitleStyle,
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Choose an action",
          style: CustomStyles.textStyle,
        ),
        const SizedBox(
          height: 25,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VetBreederRegistration()));
          },
          child: CustomContainer(
            sizingInformation: sizingInformation,
            txt: "Register Breeder/Seller Here",
            description:
                'Approve your breeder client here as being safe, ethical and not engaged in puppy farming',
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VetConnectedBreeders()));
          },
          child: CustomContainer(
            sizingInformation: sizingInformation,
            txt: "Clinically Approve Pets Here",
            description:
                'Ensure that only happy & healthy pets are featured on Petbond once Veterinary Approved here',
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 50),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddVetStaff(
                            comingFrom: "Overview",
                          )));
            },
            child: CustomContainer(
              sizingInformation: sizingInformation,
              txt: "Add Vet Team Staff",
              description:
                  'Allow additional vet team colleagues access to PetBond here',
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
