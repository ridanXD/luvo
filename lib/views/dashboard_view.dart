import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/laundry.dart';
import '../pages/katalog_laundry_page.dart';
import '../pages/detail_laundry_page.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final TextEditingController searchC = TextEditingController();

  List<Laundry> get hasilPencarian {
    final kataKunci = searchC.text.toLowerCase().trim();

    if (kataKunci.isEmpty) {
      return [];
    }

    return daftarLaundry.where((laundry) {
      return laundry.nama.toLowerCase().contains(kataKunci) ||
          laundry.lokasi.toLowerCase().contains(kataKunci);
    }).toList();
  }

  @override
  void dispose() {
    searchC.dispose();
    super.dispose();
  }

  void _bukaKatalog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const KatalogLaundryPage()),
    );
  }

  void _bukaDetail(Laundry laundry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailLaundryPage(laundry: laundry),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasil = hasilPencarian;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Luvo',
          style: AppFonts.heading(size: 20, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // SAPAAN
            Text('Selamat Datang!', style: AppFonts.heading(size: 23)),
            const SizedBox(height: 6),
            Text(
              'Temukan layanan laundry terbaik untuk kebutuhanmu.',
              style: AppFonts.body(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // KOLOM PENCARIAN
            TextField(
              controller: searchC,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Cari nama atau lokasi laundry...',
                hintStyle: AppFonts.body(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: AppColors.secondary),
                suffixIcon: searchC.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchC.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            // HASIL PENCARIAN
            if (searchC.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Hasil Pencarian', style: AppFonts.heading(size: 18)),
              const SizedBox(height: 10),

              if (hasil.isEmpty)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Laundry tidak ditemukan.',
                    textAlign: TextAlign.center,
                    style: AppFonts.body(color: Colors.grey),
                  ),
                )
              else
                ...hasil.map(
                  (laundry) => InkWell(
                    onTap: () => _bukaDetail(laundry),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_laundry_service,
                            color: AppColors.secondary,
                            size: 30,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  laundry.nama,
                                  style: AppFonts.heading(size: 15),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  laundry.lokasi,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppFonts.body(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.secondary,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],

            const SizedBox(height: 24),

            // BANNER KATALOG
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.local_laundry_service,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Laundry Jadi Lebih Mudah!',
                    style: AppFonts.heading(size: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pilih layanan dan temukan laundry yang sesuai dengan kebutuhanmu.',
                    style: AppFonts.body(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _bukaKatalog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Lihat Katalog Laundry',
                        style: AppFonts.heading(
                          size: 16,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
