import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/values/color_values.dart';

class ConnectBreederScanScreen extends StatelessWidget {
  const ConnectBreederScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QR Scanner',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorValues.fontColor,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'QR scanning is not available on web.\n'
            'Please use the mobile app to scan.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: ColorValues.fontColor),
          ),
        ),
      ),
    );
  }
}
