import 'package:flutter/material.dart';

const List<String> namaBulan = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

String formatTanggal(DateTime tanggal) {
  return '${tanggal.day} ${namaBulan[tanggal.month - 1]} ${tanggal.year}';
}

String formatJam(TimeOfDay jam) {
  final String j = jam.hour.toString().padLeft(2, '0');
  final String m = jam.minute.toString().padLeft(2, '0');
  return '$j.$m';
}
