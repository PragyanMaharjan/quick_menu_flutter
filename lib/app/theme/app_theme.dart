import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFE53935);
  static const bg = Color(0xFFF5F5F5);
  static const card = Colors.white;
  static const textDark = Color(0xFF111111);
}

class AppText {
  static const String fontFamily = 'Inter';

  static const title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const normal = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
  );

  static const link = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static const button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
