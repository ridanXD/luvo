import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'package:flutter/services.dart';
import '../components/navbar.dart';
import '../core/theme.dart';
import '../models/laundry.dart';
import '../models/pesanan.dart';
import '../data/dummy_pesanan.dart';
import '../pages/order_menu_page.dart';
import '../pages/katalog_laundry_page.dart' show daftarLaundry;
import '../pages/detail_laundry_page.dart';
import '../pages/konfirmasi_pesanan_mitra_page.dart';
import '../views/login_view.dart';
import 'profile_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;
  final TextEditingController searchC = TextEditingController();
  final FocusNode searchFocus = FocusNode();

  final user = AuthController.instance.currentUser;

  List<Laundry> get hasilPencarian {
    final kataKunci = searchC.text.toLowerCase().trim();

    if (kataKunci.isEmpty) {
      return daftarLaundry;
    }

    return daftarLaundry.where((laundry) {
      return laundry.nama.toLowerCase().contains(kataKunci) ||
          laundry.lokasi.toLowerCase().contains(kataKunci);
    }).toList();
  }

  @override
  void dispose() {
    searchC.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  void _bukaDetail(Laundry laundry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailLaundryPage(laundry: laundry),
      ),
    );
  }

  List<Pesanan> get pesananMasuk => [
        Pesanan(
          namaPelanggan: 'Dina',
          alamat: alamatDummy,
          jarakKm: 1.5,
          layanan: daftarLayanan[1],
          beratKg: 3.5,
          catatan: 'Pisahkan pakaian putih',
          tanggalJemput: DateTime.now(),
          jamJemput: '08.00 - 10.00',
          jamAntar: jamAntarDefault,
        ),
        Pesanan(
          namaPelanggan: 'Bima',
          alamat: 'Jl. Cikutra No. 24, Bandung',
          jarakKm: 3.2,
          layanan: daftarLayanan[0],
          beratKg: 2,
          catatan: 'Gunakan pewangi lembut',
          tanggalJemput: DateTime.now(),
          jamJemput: '13.00 - 15.00',
          jamAntar: jamAntarDefault,
        ),
      ];

  Widget _kartuPesananMasuk(Pesanan pesanan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: const CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(Icons.receipt_long, color: AppColors.secondary),
        ),
        title: Text(
          pesanan.namaPelanggan,
          style: AppFonts.heading(size: 16),
        ),
        subtitle: Text(
          '${pesanan.layanan.nama} · ${pesanan.beratKg} kg\nJemput ${pesanan.jamJemput}',
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KonfirmasiPesananMitraPage(pesanan: pesanan),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMerchantHome() {
    final pesanan = pesananMasuk;
    return [
      Text('Dashboard Merchant', style: AppFonts.heading(size: 23)),
      const SizedBox(height: 6),
      Text(
        'Kelola pesanan laundry yang masuk.',
        style: AppFonts.body(color: Colors.grey),
      ),
      const SizedBox(height: 24),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Pesanan Masuk', style: AppFonts.heading(size: 18)),
          Text('${pesanan.length} pesanan', style: AppFonts.body(color: Colors.grey)),
        ],
      ),
      const SizedBox(height: 12),
      ...pesanan.map(_kartuPesananMasuk),
    ];
  }

  List<Widget> _buildUserHome() {
    final hasil = hasilPencarian;
    return [
      Text(
        'Selamat Datang, ${user?.name ?? 'User'}!',
        style: AppFonts.heading(size: 23),
      ),
      const SizedBox(height: 6),
      Text(
        'Temukan layanan laundry terbaik untuk kebutuhanmu.',
        style: AppFonts.body(color: Colors.grey),
      ),
      const SizedBox(height: 24),
      TextField(
        controller: searchC,
        focusNode: searchFocus,
        onTap: () {
          searchFocus.requestFocus();
          SystemChannels.textInput.invokeMethod('TextInput.show');
        },
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Cari nama atau lokasi laundry...',
          hintStyle: AppFonts.body(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: AppColors.secondary),
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
      const SizedBox(height: 24),
      Text('Katalog Laundry', style: AppFonts.heading(size: 18)),
      const SizedBox(height: 12),
      if (hasil.isEmpty)
        const Text('Laundry tidak ditemukan.')
      else
        ...hasil.map(_kartuLaundry),
    ];
  }

  Widget _kartuLaundry(Laundry laundry) {
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
          Text('Lokasi: ${laundry.lokasi}', style: AppFonts.body()),
          Text(
            'Jam Operasional: ${laundry.jamOperasional}',
            style: AppFonts.body(),
          ),
          if (laundry.layanan.isNotEmpty)
            Text(
              'Mulai dari ${laundry.layanan.first.harga}',
              style: AppFonts.body(),
            ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _bukaDetail(laundry),
              child: Text(
                'Lihat Detail',
                style: AppFonts.body(color: AppColors.secondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _logout() {
    AuthController.instance.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMerchant = user?.role == 'merchant';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHome(isMerchant),
          const OrderMenuPage(),
          const ProfileView(),
        ],
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHome(bool isMerchant) {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: _logout,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: isMerchant ? _buildMerchantHome() : _buildUserHome(),
        ),
      ),
    );
  }
}
