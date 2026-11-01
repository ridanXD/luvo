
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/laundry.dart';

class DetailLaundryPage extends StatelessWidget {
  final Laundry laundry;

  const DetailLaundryPage({
    super.key,
    required this.laundry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        title: Text(
          'Detail Laundry',
          style: AppFonts.heading(size: 18, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(laundry.nama, style: AppFonts.heading(size: 24)),
                    const SizedBox(height: 12),
                    Text('Lokasi: ${laundry.lokasi}', style: AppFonts.body()),
                    const SizedBox(height: 8),
                    Text('Jam Operasional: ${laundry.jamOperasional}',
                        style: AppFonts.body()),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Daftar Layanan', style: AppFonts.heading(size: 20)),
              const SizedBox(height: 12),
              if (laundry.layanan.isEmpty)
                Text('Belum ada layanan', style: AppFonts.body()),
              for (final layanan in laundry.layanan)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(layanan.nama, style: AppFonts.heading(size: 16)),
                      const SizedBox(height: 8),
                      Text('Harga: ${layanan.harga}', style: AppFonts.body()),
                      Text('Estimasi: ${layanan.estimasi}',
                          style: AppFonts.body()),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
