// ignore_for_file: file_names, constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyleTextfield {
  static String FontFamily = GoogleFonts.inter().fontFamily!;

  static const Color GreyTextColor = Color.fromARGB(255, 94, 94, 94);
  static const Color BorderColor = Color.fromARGB(255, 135, 135, 135);
  static const Color TextfieldColor = Color.fromARGB(255, 255, 255, 255);
  static const Color TextfieldborderColor = Color.fromARGB(255, 194, 194, 194);

  static TextStyle hintTextstyle = TextStyle(
    fontFamily: FontFamily,
    fontWeight: FontWeight.w400,
    color: const Color.fromARGB(255, 145, 145, 145),
    fontSize: 14,
  );
}
