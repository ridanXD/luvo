import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFFDCDCDC);
  static const secondary = Color(0xFF0147AD);
  static const background = Colors.white;
  static const text = Color(0xFF1E1E1E);
}

class AppFonts {
  static TextStyle heading({double size = 20, FontWeight weight = FontWeight.bold, Color color = AppColors.secondary}) =>
      GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);

  static TextStyle body({double size = 14, FontWeight weight = FontWeight.normal, Color color = AppColors.text}) =>
      GoogleFonts.plusJakartaSans(fontSize: size, fontWeight: weight, color: color);
}
