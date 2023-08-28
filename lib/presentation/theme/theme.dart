import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  Color darkNavy = const Color(0xFF152545);
  Color lightGrey = const Color(0xFFD9D9D9);
  Color grey = const Color(0xFFD6D6D6);
  Color lightBrown = const Color(0xFFCB997E);
  Color darkRed = const Color(0xFFB23A48);
  Color blueGrey = const Color(0xFF415A78);

  TextStyle mainTitle = GoogleFonts.genos(
    fontSize: 48.0,
    fontWeight: FontWeight.w600,
    color: const Color(0xFFB23A48),
    height: 0.7,
  );
  TextStyle subTitle = GoogleFonts.genos(
      fontSize: 40.0,
      fontWeight: FontWeight.w600,
      color: const Color(0xFFFFFFFF));
  TextStyle normalText = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 22,
    color: Colors.black,
  );
  TextStyle bodyText = GoogleFonts.signika(
      fontSize: 24.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF152545));
}
