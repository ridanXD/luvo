import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'package:flutter/services.dart';
import '../components/navbar.dart';
import '../core/theme.dart';
import '../models/laundry.dart';
import '../models/pesanan.dart';
import '../data/dummy_pesanan.dart';
import '../pages/order_menu_page.dart';
import '../pages/katalog_laundry_page.dart';
import '../pages/detail_laundry_page.dart';
import '../pages/konfirmasi_pesanan_mitra_page.dart';
import '../views/login_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final TextEditingController searchC = TextEditingController();
  final FocusNode searchFocus = FocusNode();

  // Mengambil data user yang sedang login dari AuthController milik temanmu
  final user = AuthController.instance.currentUser;

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
    searchFocus.dispose();
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
      if (searchC.text.isNotEmpty) ...[
        const SizedBox(height: 16),
        Text('Hasil Pencarian', style: AppFonts.heading(size: 18)),
        const SizedBox(height: 10),
        if (hasil.isEmpty)
          const Text('Laundry tidak ditemukan.')
        else
          ...hasil.map(
            (laundry) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.local_laundry_service),
              title: Text(laundry.nama),
              subtitle: Text(laundry.lokasi),
              onTap: () => _bukaDetail(laundry),
            ),
          ),
      ],
      const SizedBox(height: 24),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.local_laundry_service, color: Colors.white, size: 40),
            const SizedBox(height: 14),
            Text('Laundry Jadi Lebih Mudah!', style: AppFonts.heading(size: 20, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Pilih layanan dan temukan laundry yang sesuai dengan kebutuhanmu.', style: AppFonts.body(color: Colors.white)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _bukaKatalog,
                child: Text('Lihat Katalog Laundry', style: AppFonts.heading(size: 16, color: AppColors.secondary)),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  // Fungsi Logout terhubung dengan AuthController temanmu
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
      bottomNavigationBar: Navbar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderMenuPage()),
            );
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/navbar.dart';
import '../core/theme.dart';
import '../models/laundry.dart';
import '../pages/katalog_laundry_page.dart';
import '../pages/detail_laundry_page.dart';
import '../pages/order_status_page.dart';
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
    searchFocus.dispose();
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

  Widget _buildHome() {
    final hasil = hasilPencarian;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Selamat Datang',
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
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: 'Cari nama atau lokasi laundry...',
              hintStyle: AppFonts.body(color: Colors.grey),
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.secondary,
              ),
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
                        const Icon(
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
                        const Icon(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentBody;
    PreferredSizeWidget? currentAppBar;

    if (_selectedIndex == 1) {
      currentBody = const OrderStatusPage();
    } else if (_selectedIndex == 2) {
      currentBody = const ProfileView();
    } else {
      currentAppBar = AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Luvo',
          style: AppFonts.heading(size: 20, color: Colors.white),
        ),
      );
      currentBody = _buildHome();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: currentAppBar,
      body: currentBody,
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
}
