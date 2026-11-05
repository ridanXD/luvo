import 'package:flutter/material.dart';

import 'pages/buat_pesanan_page.dart';
import 'pages/konfirmasi_pesanan_mitra_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text('Halaman Awal Tes')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BuatPesananPage(),
                        ),
                      );
                    },
                    child: const Text('Buka Buat Pesanan'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const KonfirmasiPesananMitraPage(),
                        ),
                      );
                    },
                    child: const Text('Buka Pesanan Masuk (Mitra)'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
