
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/laundry.dart';
import 'detail_laundry_page.dart';

const List<Laundry> daftarLaundry = [
  Laundry(
    nama: 'Laundry Lauza',
    lokasi: 'Jl. Batununggal Indah Raya No.172, Batununggal, Kec. Bandung Kidul, Kota Bandung, Jawa Barat 40266',
    jamOperasional: '08.00 - 20.00',
    layanan: [
      Layanan(
        nama: 'Cuci Kiloan',
        harga: 'Rp7.000/kg',
        estimasi: '2 hari',
      ),
      Layanan(
        nama: 'Cuci Setrika',
        harga: 'Rp10.000/kg',
        estimasi: '2 hari',
      ),
    ],
  ),
  Laundry(
    nama: 'Ilham Laundry',
    lokasi: 'Jl. Adhyaksa Raya No.11, Sukapura, Kec. Dayeuhkolot, Kota Bandung, Jawa Barat 40267',
    jamOperasional: '09.00 - 21.00',
    layanan: [
      Layanan(
        nama: 'Setrika Saja',
        harga: 'Rp5.000/kg',
        estimasi: '1 hari',
      ),
    ],
  ),
];

class KatalogLaundryPage extends StatelessWidget {
  const KatalogLaundryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        title: Text(
          'Katalog Laundry',
          style: AppFonts.heading(
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: daftarLaundry.length,
        itemBuilder: (context, index) {
          final laundry = daftarLaundry[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  laundry.nama,
                  style: AppFonts.heading(size: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Lokasi: ${laundry.lokasi}',
                  style: AppFonts.body(),
                ),
                Text(
                  'Jam Operasional: ${laundry.jamOperasional}',
                  style: AppFonts.body(),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailLaundryPage(
                            laundry: laundry,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Lihat Detail',
                      style: AppFonts.body(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
