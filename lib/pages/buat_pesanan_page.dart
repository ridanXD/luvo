import 'package:flutter/material.dart';

import '../data/dummy_pesanan.dart';
import '../models/pesanan.dart';
import '../theme/app_colors.dart';
import '../utils/format_rupiah.dart';
import '../utils/format_tanggal.dart';
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
  DateTime? tanggalJemput;
  String? jamJemput;
  TimeOfDay jamAntar = jamAntarDefault;

  @override
  void dispose() {
    beratController.dispose();
    catatanController.dispose();
    super.dispose();
  }

  Future<void> pilihTanggal() async {
    final DateTime hariIni = DateTime.now();
    final DateTime? hasil = await showDatePicker(
      context: context,
      initialDate: tanggalJemput ?? hariIni,
      firstDate: hariIni,
      lastDate: hariIni.add(const Duration(days: 7)),
    );
    if (hasil != null) {
      setState(() {
        tanggalJemput = hasil;
      });
    }
  }

  Future<void> pilihJamAntar() async {
    final TimeOfDay? hasil = await showTimePicker(
      context: context,
      initialTime: jamAntar,
    );
    if (hasil != null) {
      setState(() {
        jamAntar = hasil;
      });
    }
  }

  double ambilBerat() {
    final String teks = beratController.text.replaceAll(',', '.');
    return double.tryParse(teks) ?? 0;
  }

  String? pesanKurang() {
    if (layananDipilih == null) {
      return 'Pilih layanan terlebih dahulu';
    }
    if (ambilBerat() <= 0) {
      return 'Isi perkiraan berat lebih dari 0 kg';
    }
    if (tanggalJemput == null) {
      return 'Pilih tanggal penjemputan';
    }
    if (jamJemput == null) {
      return 'Pilih jam penjemputan';
    }
    return null;
  }

  int hitungBiayaLayanan() {
    if (layananDipilih == null) {
      return 0;
    }
    return (layananDipilih!.hargaPerKg * ambilBerat()).round();
  }

  int hitungBiayaAntarJemput() {
    return (tarifAntarJemputPerKm * jarakDummy).round();
  }

  int hitungTotal() {
    return hitungBiayaLayanan() + hitungBiayaAntarJemput();
  }

  void kirimPesanan() {
    FocusManager.instance.primaryFocus?.unfocus();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kirim Pesanan?'),
          content: Text(
            'Total estimasi ${formatRupiah(hitungTotal())}. Pesanan akan dikirim ke mitra laundry.',
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
                tampilkanDialogSukses();
              },
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );
  }

  void tampilkanDialogSukses() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle,
            color: AppColors.secondary,
            size: 64,
          ),
          title: const Text('Pesanan Terkirim'),
          content: Text(
            'Status: ${teksStatus(StatusPesanan.menungguKonfirmasi)}\nMitra laundry akan segera mengonfirmasi pesananmu.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget barisHarga(String label, int harga, bool tebal) {
    final TextStyle gaya = TextStyle(
      fontWeight: tebal ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: gaya),
          Text(formatRupiah(harga), style: gaya),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? pesan = pesanKurang();

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Pesanan')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (pesan != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    pesan,
                    style: const TextStyle(color: AppColors.merah),
                  ),
                ),
              ElevatedButton(
                onPressed: pesan == null ? kirimPesanan : null,
                child: const Text('Kirim Pesanan'),
              ),
            ],
          ),
        ),
      ),
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
              decoration: InputDecoration(
                hintText: 'Contoh: 3',
                suffixText: 'kg',
                helperText: 'Berat akhir dikonfirmasi setelah ditimbang mitra',
                errorText: beratController.text.isNotEmpty && ambilBerat() <= 0
                    ? 'Berat harus angka lebih dari 0'
                    : null,
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
          const SizedBox(height: 16),
          KartuBagian(
            judul: 'Jadwal Penjemputan',
            ikon: Icons.calendar_month,
            isi: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton.icon(
                  onPressed: pilihTanggal,
                  icon: const Icon(Icons.event),
                  label: Text(
                    tanggalJemput == null
                        ? 'Pilih tanggal'
                        : formatTanggal(tanggalJemput!),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Pilih jam penjemputan:'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: daftarSlotJemput.map((slot) {
                    return ChoiceChip(
                      label: Text(
                        slot.tersedia ? slot.jam : '${slot.jam} (penuh)',
                      ),
                      selected: jamJemput == slot.jam,
                      selectedColor: AppColors.secondary,
                      checkmarkColor: AppColors.putih,
                      labelStyle: TextStyle(
                        color: jamJemput == slot.jam
                            ? AppColors.putih
                            : AppColors.teks,
                      ),
                      onSelected: slot.tersedia
                          ? (pilih) {
                              setState(() {
                                jamJemput = slot.jam;
                              });
                            }
                          : null,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          KartuBagian(
            judul: 'Jadwal Pengantaran',
            ikon: Icons.delivery_dining,
            isi: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Diantar pukul ${formatJam(jamAntar)}'),
              trailing: TextButton(
                onPressed: pilihJamAntar,
                child: const Text('Ubah'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          KartuBagian(
            judul: 'Rincian Harga',
            ikon: Icons.payments,
            isi: layananDipilih == null || ambilBerat() <= 0
                ? const Text(
                    'Pilih layanan dan isi berat untuk melihat harga',
                    style: TextStyle(color: AppColors.teksAbu),
                  )
                : Column(
                    children: [
                      barisHarga(
                        'Layanan (${beratController.text} kg x ${formatRupiah(layananDipilih!.hargaPerKg)})',
                        hitungBiayaLayanan(),
                        false,
                      ),
                      barisHarga(
                        'Antar-jemput ($jarakDummy km)',
                        hitungBiayaAntarJemput(),
                        false,
                      ),
                      const Divider(),
                      barisHarga('Total Estimasi', hitungTotal(), true),
                      const SizedBox(height: 8),
                      const Text(
                        'Harga akhir dikonfirmasi setelah cucian ditimbang mitra.',
                        style: TextStyle(
                          color: AppColors.teksAbu,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
