class Donor {
  final String nama;
  final String golDarah;

  Donor({
    required this.nama,
    required this.golDarah,
  });

  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
      nama: json['nama'],
      golDarah: json['gol_darah'],
    );
  }
}
