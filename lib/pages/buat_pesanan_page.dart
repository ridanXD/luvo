import 'package:flutter/material.dart';

import '../data/dummy_pesanan.dart';
import '../models/pesanan.dart';
import '../theme/app_colors.dart';
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
                onPressed: pesan == null
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Form sudah lengkap')),
                        );
                      }
                    : null,
                child: const Text('Lihat Ringkasan'),
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
        ],
      ),
    );
  }
}
