import 'package:flutter/material.dart';

enum StatusPesanan { menungguKonfirmasi, diterima, ditolak }

String teksStatus(StatusPesanan status) {
  switch (status) {
    case StatusPesanan.menungguKonfirmasi:
      return 'Menunggu Konfirmasi';
    case StatusPesanan.diterima:
      return 'Diterima';
    case StatusPesanan.ditolak:
      return 'Ditolak';
  }
}

class LayananPesanan {
  final String nama;
  final String deskripsi;
  final int hargaPerKg;
  final String estimasi;
  final IconData ikon;

  LayananPesanan({
    required this.nama,
    required this.deskripsi,
    required this.hargaPerKg,
    required this.estimasi,
    required this.ikon,
  });
}

class SlotWaktu {
  final String jam;
  final bool tersedia;

  SlotWaktu({required this.jam, required this.tersedia});
}

class Pesanan {
  String namaPelanggan;
  String alamat;
  double jarakKm;
  LayananPesanan layanan;
  double beratKg;
  String catatan;
  DateTime tanggalJemput;
  String jamJemput;
  TimeOfDay jamAntar;
  StatusPesanan status;
  String alasanTolak;

  Pesanan({
    required this.namaPelanggan,
    required this.alamat,
    required this.jarakKm,
    required this.layanan,
    required this.beratKg,
    required this.catatan,
    required this.tanggalJemput,
    required this.jamJemput,
    required this.jamAntar,
    this.status = StatusPesanan.menungguKonfirmasi,
    this.alasanTolak = '',
  });
}
