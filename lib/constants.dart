import 'dart:ui';
import 'package:flutter/material.dart';

const String apiBaseUrl = "https://pokeapi.co/api/v2";

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
  'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) + (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}

class ColorConstants {
  static Color indicatorColor = hexToColor('#3558CD');
  static Color appMainBlue = hexToColor('#3558CD');
  static Color appLightBlue = hexToColor('#D5DEFF');
  static Color textColor = hexToColor('#161A33');
  static Color lightTextColor = hexToColor("#6B6B6B");
  static Color selectedTextColor = hexToColor('#161A33');
  static Color unselectedTextColor = hexToColor('#6B6B6B');
  static Color scrollViewBackgroundColor = hexToColor('#E8E8E8');
}