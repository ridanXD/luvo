import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/laundry.dart';
import 'detail_laundry_page.dart';

const List<Laundry> daftarLaundry = [
  Laundry(
    nama: 'Laundry Lauza',
    lokasi:
        'Jl. Batununggal Indah Raya No.172, Batununggal, Kec. Bandung Kidul, Kota Bandung, Jawa Barat 40266',
    jamOperasional: '08.00 - 20.00',
    layanan: [
      Layanan(nama: 'Cuci Kiloan', harga: 'Rp7.000/kg', estimasi: '2 hari'),
      Layanan(nama: 'Cuci Setrika', harga: 'Rp10.000/kg', estimasi: '2 hari'),
    ],
  ),
  Laundry(
    nama: 'Ilham Laundry',
    lokasi:
        'Jl. Adhyaksa Raya No.11, Sukapura, Kec. Dayeuhkolot, Kota Bandung, Jawa Barat 40267',
    jamOperasional: '09.00 - 21.00',
    layanan: [
      Layanan(nama: 'Setrika Saja', harga: 'Rp5.000/kg', estimasi: '1 hari'),
    ],
  ),
];

class KatalogLaundryPage extends StatefulWidget {
  const KatalogLaundryPage({super.key});

  @override
  State<KatalogLaundryPage> createState() => _KatalogLaundryPageState();
}

class _KatalogLaundryPageState extends State<KatalogLaundryPage> {
  String _query = '';

  List<Laundry> get _hasilPencarian {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return daftarLaundry;

    return daftarLaundry.where((laundry) {
      return laundry.nama.toLowerCase().contains(query) ||
          laundry.lokasi.toLowerCase().contains(query);
    }).toList();
  }

  String? _hargaTermurah(Laundry laundry) {
    if (laundry.layanan.isEmpty) return null;

    final layananTermurah = laundry.layanan.reduce((a, b) {
      int nilaiHarga(String harga) =>
          int.tryParse(harga.replaceAll(RegExp(r'[^0-9]'), '')) ??
          0x7fffffffffffffff;

      return nilaiHarga(a.harga) <= nilaiHarga(b.harga) ? a : b;
    });

    return layananTermurah.harga;
  }

  @override
  Widget build(BuildContext context) {
    final hasil = _hasilPencarian;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        title: Text(
          'Katalog Laundry',
          style: AppFonts.heading(size: 18, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Cari nama atau lokasi laundry',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.primary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: hasil.isEmpty
                ? Center(
                    child: Text(
                      'Laundry tidak ditemukan',
                      style: AppFonts.body(),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: hasil.length,
                    itemBuilder: (context, index) {
                      final laundry = hasil[index];
                      final hargaTermurah = _hargaTermurah(laundry);

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
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
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
                            if (hargaTermurah != null)
                              Text(
                                'Mulai dari $hargaTermurah',
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
                                          DetailLaundryPage(laundry: laundry),
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
          ),
        ],
      ),
    );
  }
}
