import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/routes/routes.dart';
import 'package:petbond_uk/core/values/asset_values.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/widgets/base_widget.dart';
import 'package:petbond_uk/core/widgets/shared/footer.dart';
import 'package:petbond_uk/modules/auth/signup/widgets/signup_widgets.dart';

const double circleRadius = 90.0;

class SignUpSelectionScreen extends StatefulWidget {
  const SignUpSelectionScreen({Key? key}) : super(key: key);

  @override
  _SignUpSelectionScreenState createState() => _SignUpSelectionScreenState();
}

class _SignUpSelectionScreenState extends State<SignUpSelectionScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, sizingInformation) {
        return Scaffold(
            key: scaffoldKey,
            backgroundColor: ColorValues.backgroundColor,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  topArea(),
                  SignUpWidgets.selectionCard(
                      title: "Seller / Breeder",
                      image: AssetValues.breederIcon,
                      description:
                          "If you wish to be recognized as a PetBond Approved Breeder Approved Hobby and Advertise on PetBond",
                      onTap: () {
                        Navigator.pushNamed(context, signUpScreen,
                            arguments: 1);
                      }),
                  SignUpWidgets.selectionCard(
                      title: "Veterinary Practice",
                      image: AssetValues.vetIcon,
                      description:
                          "If your veterinary practice would like to sign up to PetBond and be listed as PetBond approved Veterinary Practice",
                      onTap: () {
                        Navigator.pushNamed(context, signUpScreen,
                            arguments: 2);
                      }),
                  SignUpWidgets.selectionCard(
                      title: "Charity Practice",
                      image: AssetValues.charityIcon,
                      description:
                          "If you are a charity or rescue centre that is interested in partnering to become a Petbond approved charity / rescue centre",
                      onTap: () {
                        Navigator.pushNamed(context, signUpScreen,
                            arguments: 3);
                      }),
                  Footer(sizingInformation: sizingInformation)
                ],
              ),
            ));
      },
    );
  }

  topArea() {
    return Stack(
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
    );
  }
}
