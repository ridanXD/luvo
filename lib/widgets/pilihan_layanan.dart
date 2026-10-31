import 'package:flutter/material.dart';

import '../models/pesanan.dart';
import '../theme/app_colors.dart';
import '../utils/format_rupiah.dart';

class PilihanLayanan extends StatelessWidget {
  final LayananPesanan layanan;
  final bool dipilih;
  final VoidCallback onTap;

  const PilihanLayanan({
    super.key,
    required this.layanan,
    required this.dipilih,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: dipilih
          ? AppColors.secondary.withValues(alpha: 0.08)
          : AppColors.putih,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: dipilih ? AppColors.secondary : AppColors.primary,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(layanan.ikon, color: AppColors.secondary, size: 32),
        title: Text(
          layanan.nama,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${layanan.deskripsi}\n'
          '${formatRupiah(layanan.hargaPerKg)}/kg  •  ${layanan.estimasi}',
        ),
        isThreeLine: true,
        trailing: Icon(
          dipilih ? Icons.check_circle : Icons.circle_outlined,
          color: dipilih ? AppColors.secondary : AppColors.primary,
        ),
      ),
    );
  }
}
