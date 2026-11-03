import 'package:flutter/material.dart';

import '../data/dummy_pesanan.dart';
import '../models/pesanan.dart';
import '../theme/app_colors.dart';
import '../utils/format_rupiah.dart';
import '../utils/format_tanggal.dart';
import '../widgets/kartu_bagian.dart';

class KonfirmasiPesananMitraPage extends StatefulWidget {
  const KonfirmasiPesananMitraPage({super.key});

  @override
  State<KonfirmasiPesananMitraPage> createState() =>
      _KonfirmasiPesananMitraPageState();
}

class _KonfirmasiPesananMitraPageState
    extends State<KonfirmasiPesananMitraPage> {
  final Pesanan pesanan = Pesanan(
    namaPelanggan: namaPelangganDummy,
    alamat: alamatDummy,
    jarakKm: jarakDummy,
    layanan: daftarLayanan[1],
    beratKg: 3.5,
    catatan: 'Pisahkan pakaian putih',
    tanggalJemput: DateTime.now(),
    jamJemput: '08.00 - 10.00',
    jamAntar: jamAntarDefault,
  );

  int hitungTotal() {
    final int biayaLayanan = (pesanan.layanan.hargaPerKg * pesanan.beratKg)
        .round();
    final int biayaAntarJemput = (tarifAntarJemputPerKm * pesanan.jarakKm)
        .round();
    return biayaLayanan + biayaAntarJemput;
  }

  Color warnaStatus() {
    if (pesanan.status == StatusPesanan.diterima) {
      return AppColors.secondary;
    }
    if (pesanan.status == StatusPesanan.ditolak) {
      return AppColors.merah;
    }
    return AppColors.teksAbu;
  }

  void tampilkanPesan(String teks) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(teks)));
  }

  void terimaPesanan() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Terima Pesanan?'),
          content: Text(
            'Pesanan dari ${pesanan.namaPelanggan} akan diterima. Harga akhir dikonfirmasi setelah cucian ditimbang.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  pesanan.status = StatusPesanan.diterima;
                });
                tampilkanPesan('Pesanan diterima');
              },
              child: const Text('Terima'),
            ),
          ],
        );
      },
    );
  }

  Widget barisInfo(String label, String isi) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.teksAbu),
            ),
          ),
          Expanded(child: Text(isi)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool sudahDiproses =
        pesanan.status != StatusPesanan.menungguKonfirmasi;

    return Scaffold(
      appBar: AppBar(title: const Text('Pesanan Masuk')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: sudahDiproses ? null : terimaPesanan,
            child: const Text('Terima'),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          KartuBagian(
            judul: 'Status Pesanan',
            ikon: Icons.info,
            isi: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: warnaStatus(),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                teksStatus(pesanan.status),
                style: const TextStyle(
                  color: AppColors.putih,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          KartuBagian(
            judul: 'Pelanggan',
            ikon: Icons.person,
            isi: Column(
              children: [
                barisInfo('Nama', pesanan.namaPelanggan),
                barisInfo('Alamat', pesanan.alamat),
                barisInfo('Jarak', '${pesanan.jarakKm} km'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          KartuBagian(
            judul: 'Detail Pesanan',
            ikon: Icons.receipt_long,
            isi: Column(
              children: [
                barisInfo('Layanan', pesanan.layanan.nama),
                barisInfo('Berat', '${pesanan.beratKg} kg (perkiraan)'),
                barisInfo(
                  'Catatan',
                  pesanan.catatan.isEmpty ? '-' : pesanan.catatan,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          KartuBagian(
            judul: 'Jadwal',
            ikon: Icons.calendar_month,
            isi: Column(
              children: [
                barisInfo(
                  'Jemput',
                  '${formatTanggal(pesanan.tanggalJemput)}, ${pesanan.jamJemput}',
                ),
                barisInfo('Antar', 'Pukul ${formatJam(pesanan.jamAntar)}'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          KartuBagian(
            judul: 'Total Estimasi',
            ikon: Icons.payments,
            isi: Text(
              formatRupiah(hitungTotal()),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
