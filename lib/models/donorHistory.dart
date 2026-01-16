class DonorHistory {
  final String id;
  final String nama;
  final String golDarah;
  final String tanggal;

  DonorHistory({
    required this.id,
    required this.nama,
    required this.golDarah,
    required this.tanggal,
  });

  factory DonorHistory.fromJson(Map<String, dynamic> json) {
    return DonorHistory(
      id: json['id'],
      nama: json['nama'],
      golDarah: json['gol_darah'],
      tanggal: json['tanggal_donor'],
    );
  }
}
