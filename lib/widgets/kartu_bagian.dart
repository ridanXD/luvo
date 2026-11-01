import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

class KartuBagian extends StatelessWidget {
  final String judul;
  final IconData ikon;
  final Widget isi;

  const KartuBagian({
    super.key,
    required this.judul,
    required this.ikon,
    required this.isi,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.putih,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.primary),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(ikon, color: AppColors.secondary),
                const SizedBox(width: 8),
                Text(
                  judul,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            isi,
          ],
        ),
      ),
    );
  }
}
