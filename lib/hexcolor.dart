// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

//COLORS
final Color JET = HexColor.fromHex("#353535");
final Color WHITE = HexColor.fromHex("#FFFFFF");
final Color FRENCH_GRAY = HexColor.fromHex("#D2D7DF");
final Color SILVER = HexColor.fromHex("#BDBBB0");
final Color BATTLESHIP_GRAY = HexColor.fromHex("#8A897C");
final Color CHEKK_GREEN = HexColor.fromHex("00bd62");
final Color GHOST_WHITE = HexColor.fromHex("#F8F8FF");
