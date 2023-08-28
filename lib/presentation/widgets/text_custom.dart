import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget titleText(String text) {
  return Text(
    text,
    style: GoogleFonts.genos(
      textStyle: const TextStyle(
          color: Colors.white, fontSize: 40, fontWeight: FontWeight.w500),
    ),
  );
}

Widget normalText(String text) {
  return Text(
    text,
    style: GoogleFonts.signika(
      textStyle: const TextStyle(
          color: Color(0xFF1B263B), fontSize: 24, fontWeight: FontWeight.w500),
    ),
  );
}
