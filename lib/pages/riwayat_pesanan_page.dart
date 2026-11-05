import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class RiwayatPesananPage extends StatefulWidget {
  const RiwayatPesananPage({super.key});

  @override
  State<RiwayatPesananPage> createState() => _RiwayatPesananPageState();
}

class _RiwayatPesananPageState extends State<RiwayatPesananPage> {
  String filter = 'Semua';

  final daftarPesanan = <Map<String, String>>[
    {
      'laundry': 'Ilham Laundry',
      'layanan': 'Cuci Setrika · 4 kg',
      'tanggal': '2 November 2026',
      'harga': 'Rp38.000',
      'status': 'Sedang Dikerjakan',
    },
    {
      'laundry': 'Laundry Lauza',
      'layanan': 'Cuci Kiloan · 3 kg',
      'tanggal': '1 November 2026',
      'harga': 'Rp18.000',
      'status': 'Selesai',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final data = daftarPesanan.where((p) =>
        filter == 'Semua' ||
        (filter == 'Diproses' && p['status'] != 'Selesai') ||
        (filter == 'Selesai' && p['status'] == 'Selesai')).toList();

    return Scaffold(
      backgroundColor: AppColors.putih,
      appBar: AppBar(
        title: const Text('Riwayat Pesanan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.putih,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              children: ['Semua', 'Diproses', 'Selesai'].map((item) =>
                ChoiceChip(
                  label: Text(item),
                  selected: filter == item,
                  selectedColor: AppColors.primary,
                  onSelected: (_) => setState(() => filter = item),
                ),
              ).toList(),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: data.isEmpty
                  ? const Center(child: Text('Belum ada riwayat pesanan.'))
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final p = data[index];
                        final selesai = p['status'] == 'Selesai';

                        return Card(
                          color: AppColors.primary,
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(p['laundry']!,
                                        style: const TextStyle(
                                          color: AppColors.secondary,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text(selesai ? 'Selesai' : 'Diproses',
                                        style: TextStyle(
                                          color: selesai
                                              ? Colors.green
                                              : AppColors.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        )),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(p['layanan']!),
                                Text(p['tanggal']!,
                                    style: const TextStyle(
                                      color: AppColors.teksAbu,
                                      fontSize: 12,
                                    )),
                                const Divider(color: Colors.white, height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total'),
                                    Text(p['harga']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
