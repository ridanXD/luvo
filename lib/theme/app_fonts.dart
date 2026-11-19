import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppFonts {
  static TextStyle heading({
    double size = 20,
    FontWeight weight = FontWeight.bold,
    Color color = AppColors.secondary,
  }) => GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);

  static TextStyle body({
    double size = 14,
    FontWeight weight = FontWeight.normal,
    Color color = AppColors.text,
  }) => GoogleFonts.plusJakartaSans(
    fontSize: size,
    fontWeight: weight,
    color: color,
  );
}
