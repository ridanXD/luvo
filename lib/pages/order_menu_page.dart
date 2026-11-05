import 'package:flutter/material.dart';
import '../components/navbar.dart';
import '../theme/app_colors.dart';
import 'buat_pesanan_page.dart';
import 'konfirmasi_pesanan_mitra_page.dart';
import 'status_pesanan_page.dart';
import 'riwayat_pesanan_page.dart';
import '../controllers/auth_controller.dart';

class OrderMenuPage extends StatelessWidget {
  const OrderMenuPage({super.key});

  void _bukaHalaman(BuildContext context, Widget halaman) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => halaman));
  }

  @override
  Widget build(BuildContext context) {
    final isMerchant = AuthController.instance.currentUser?.role == 'merchant';
    final menu = [
      {
        'judul': 'Buat Pesanan',
        'deskripsi': 'Buat pesanan laundry baru',
        'icon': Icons.add_shopping_cart,
        'halaman': BuatPesananPage(),
      },
      {
        'judul': 'Konfirmasi Pesanan',
        'deskripsi': 'Lihat konfirmasi pesanan',
        'icon': Icons.receipt_long,
        'halaman': KonfirmasiPesananMitraPage(),
      },
      {
        'judul': 'Status Pesanan',
        'deskripsi': 'Pantau proses pesanan laundry',
        'icon': Icons.local_shipping,
        'halaman': StatusPesananPage(),
      },
      {
        'judul': 'Riwayat Pesanan',
        'deskripsi': 'Lihat daftar pesanan sebelumnya',
        'icon': Icons.history,
        'halaman': RiwayatPesananPage(),
      },
    ].where((item) {
      return !isMerchant ||
          item['judul'] == 'Status Pesanan' ||
          item['judul'] == 'Riwayat Pesanan';
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.putih,
      appBar: AppBar(
        title: const Text(
          'Order',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Menu Pesanan',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 6),
          const Text('Pilih fitur pesanan yang ingin kamu buka.'),
          const SizedBox(height: 20),
          ...menu.map(
            (item) => Card(
              color: AppColors.primary,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Icon(
                  item['icon'] as IconData,
                  color: AppColors.secondary,
                  size: 32,
                ),
                title: Text(
                  item['judul'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                subtitle: Text(item['deskripsi'] as String),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () => _bukaHalaman(context, item['halaman'] as Widget),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          } else if (index == 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Halaman Profile belum tersedia')),
            );
          }
        },
      ),
    );
  }
}
