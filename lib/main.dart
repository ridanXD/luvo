import 'package:flutter/material.dart';

import 'pages/buat_pesanan_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luvo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tema(),
      home: const BuatPesananPage(),
    );
  }
}
