import 'package:flutter/material.dart';

import '../models/pesanan.dart';

const String namaPelangganDummy = 'Dina';
const String alamatDummy = 'Jl. Sukabirus No. 12, Dayeuhkolot, Kab. Bandung';
const double jarakDummy = 1.5;
const int tarifAntarJemputPerKm = 2000;
const TimeOfDay jamAntarDefault = TimeOfDay(hour: 16, minute: 0);

List<LayananPesanan> daftarLayanan = [
  LayananPesanan(
    nama: 'Cuci Kiloan',
    deskripsi: 'Cuci dan lipat pakaian harian.',
    hargaPerKg: 6000,
    estimasi: '2 hari',
    ikon: Icons.local_laundry_service,
  ),
  LayananPesanan(
    nama: 'Cuci Setrika',
    deskripsi: 'Cuci, keringkan, dan setrika rapi.',
    hargaPerKg: 8000,
    estimasi: '3 hari',
    ikon: Icons.checkroom,
  ),
  LayananPesanan(
    nama: 'Setrika Saja',
    deskripsi: 'Hanya setrika untuk pakaian yang sudah bersih.',
    hargaPerKg: 5000,
    estimasi: '1 hari',
    ikon: Icons.iron,
  ),
  LayananPesanan(
    nama: 'Dry Clean',
    deskripsi: 'Untuk jas, kebaya, dan bahan khusus.',
    hargaPerKg: 20000,
    estimasi: '4 hari',
    ikon: Icons.dry_cleaning,
  ),
];

List<SlotWaktu> daftarSlotJemput = [
  SlotWaktu(jam: '08.00 - 10.00', tersedia: true),
  SlotWaktu(jam: '10.00 - 12.00', tersedia: false),
  SlotWaktu(jam: '13.00 - 15.00', tersedia: true),
  SlotWaktu(jam: '15.00 - 17.00', tersedia: true),
];
