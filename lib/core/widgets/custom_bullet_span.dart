import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../values/color_values.dart';

class BulletSpan extends StatelessWidget {
  final String text;

  const BulletSpan({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: const Text(
              '\u2022', // Bullet character
              style: TextStyle(
                fontSize: 18.0,
                color: ColorValues.white,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: ColorValues.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
