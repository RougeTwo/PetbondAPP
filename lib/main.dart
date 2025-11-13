import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/core/routes/routes.dart';
import 'package:petbond_uk/core/routes/routes_generator.dart';
import 'package:petbond_uk/core/utils/config.dart';

const kGoogleApiKey = AppConfig.googleMapsApiKey;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configLoading();
  runApp(const MyApp());
  // runApp(
  //   const MaterialApp(
  //     home: Scaffold(
  //       body: Center(
  //         child: Text('It works!'),
  //       ),
  //     ),
  //   ),
  // );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 12.0
    ..textStyle = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
    ..toastPosition = EasyLoadingToastPosition.bottom
    ..maskColor = Colors.transparent
    ..textColor = Colors.white
    ..progressColor = Colors.white
    ..indicatorColor = Colors.white
    ..backgroundColor = ColorValues.darkerGreyColor;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetBond',
      theme: ThemeData(
        primaryColor: Colors.white,
        fontFamily: 'NotoSans',
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: ColorValues.fontColor, //thereby
        ),
      ),
      initialRoute: splashScreen,
      builder: EasyLoading.init(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
