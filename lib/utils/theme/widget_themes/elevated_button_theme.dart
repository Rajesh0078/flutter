import 'package:flutter/material.dart';
import 'package:swype/utils/constants/colors.dart';

class CElevatedButtonTheme {
  CElevatedButtonTheme._();

  static final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16),
      foregroundColor: Colors.white,
      backgroundColor: CColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
