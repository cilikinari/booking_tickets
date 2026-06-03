import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class AppLogo extends StatelessWidget {
  final double fontSize;

  // Kita set default fontSize ke 26 jika tidak ditentukan
  const AppLogo({
    super.key, 
    this.fontSize = 26,
  });

  @override
  Widget build(BuildContext context) {
    // Style text dikonfigurasi dinamis mengikuti properti fontSize
    final TextStyle brandTextStyle = TextStyle(
      color: AppConstants.primaryColor,
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      fontStyle: FontStyle.italic,
      letterSpacing: 0.6,
    );

    final TextStyle brandPlusTextStyle = TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      fontStyle: FontStyle.italic,
      letterSpacing: 0.6,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('CINEMA', style: brandTextStyle),
        Text('+', style: brandPlusTextStyle),
      ],
    );
  }
}