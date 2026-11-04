
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class RiwayatPesananPage extends StatefulWidget {
  const RiwayatPesananPage({super.key});

  @override
  State<RiwayatPesananPage> createState() => _RiwayatPesananPageState();
}

class _RiwayatPesananPageState extends State<RiwayatPesananPage> {
  String filter = 'Semua';

  final daftarPesanan = [
    {
      'id': 'LV-001',
      'laundry': 'Ilham Laundry',
      'layanan': 'Cuci Setrika · 4 kg',
      'tanggal': '2 November 2026',
      'harga': 'Rp38.000',
      'status': 'Sedang Dikerjakan',
    },
    {
      'id': 'LV-002',
      'laundry': 'Laundry Lauza',
      'layanan': 'Cuci Kiloan · 3 kg',
      'tanggal': '1 November 2026',
      'harga': 'Rp18.000',
      'status': 'Selesai',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final pesananTampil = daftarPesanan.where((p) =>
        filter == 'Semua' ||
        (filter == 'Diproses' && p['status'] != 'Selesai') ||
        (filter == 'Selesai' && p['status'] == 'Selesai')).toList();

    return Scaffold(
      backgroundColor: AppColors.putih,
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.putih,
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              children: ['Semua', 'Diproses', 'Selesai'].map((item) {
                return ChoiceChip(
                  label: Text(item),
                  selected: filter == item,
                  selectedColor: AppColors.primary,
                  onSelected: (_) => setState(() => filter = item),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: pesananTampil.length,
                itemBuilder: (context, index) {
                  final p = pesananTampil[index];
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
                              Text(p['id']!),
                              Text(
                                selesai ? 'Selesai' : 'Diproses',
                                style: TextStyle(
                                  color: selesai
                                      ? Colors.green
                                      : AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white),
                          Text(
                            p['laundry']!,
                            style: const TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(p['layanan']!),
                          Text(
                            p['tanggal']!,
                            style: const TextStyle(
                              color: AppColors.teksAbu,
                              fontSize: 12,
                            ),
                          ),
                          const Divider(color: Colors.white),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total'),
                              Text(
                                p['harga']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
