// ignore_for_file: public_member_api_docs, sort_constructors_first
class Layanan {
  final String nama;
  final String harga;
  final String estimasi;

  const Layanan({
    required this.nama,
    required this.harga,
    required this.estimasi,
  });
}

class Laundry {
  final String nama;
  final String lokasi;
  final String jamOperasional;
  final List<Layanan> layanan;

  const Laundry({
    required this.nama,
    required this.lokasi,
    required this.jamOperasional,
    required this.layanan,
  });
}
