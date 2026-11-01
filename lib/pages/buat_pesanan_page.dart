import 'package:flutter/material.dart';

import '../data/dummy_pesanan.dart';
import '../models/pesanan.dart';
import '../theme/app_colors.dart';
import '../widgets/kartu_bagian.dart';
import '../widgets/pilihan_layanan.dart';

class BuatPesananPage extends StatefulWidget {
  const BuatPesananPage({super.key});

  @override
  State<BuatPesananPage> createState() => _BuatPesananPageState();
}

class _BuatPesananPageState extends State<BuatPesananPage> {
  LayananPesanan? layananDipilih;
  final beratController = TextEditingController();
  final catatanController = TextEditingController();

  @override
  void dispose() {
    beratController.dispose();
    catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Pesanan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          KartuBagian(
            judul: 'Alamat Penjemputan',
            ikon: Icons.location_on,
            isi: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  namaPelangganDummy,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  alamatDummy,
                  style: const TextStyle(color: AppColors.teksAbu),
                ),
                const SizedBox(height: 4),
                Text('Jarak: $jarakDummy km'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          KartuBagian(
            judul: 'Pilih Layanan',
            ikon: Icons.local_laundry_service,
            isi: Column(
              children: daftarLayanan.map((layanan) {
                return PilihanLayanan(
                  layanan: layanan,
                  dipilih: layananDipilih == layanan,
                  onTap: () {
                    setState(() {
                      layananDipilih = layanan;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          KartuBagian(
            judul: 'Perkiraan Berat',
            ikon: Icons.scale,
            isi: TextField(
              controller: beratController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                hintText: 'Contoh: 3',
                suffixText: 'kg',
                helperText: 'Berat akhir dikonfirmasi setelah ditimbang mitra',
              ),
              onChanged: (teks) {
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: 16),
          KartuBagian(
            judul: 'Catatan Khusus',
            ikon: Icons.edit_note,
            isi: TextField(
              controller: catatanController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Contoh: pisahkan pakaian putih (opsional)',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
