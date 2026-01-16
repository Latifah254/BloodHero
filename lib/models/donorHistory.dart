class DonorHistory {
  final String id;
  final String name;
  final String blood_type;
  final String donorDate;

  DonorHistory({
    required this.id,
    required this.name,
    required this.blood_type,
    required this.donorDate
  });

  factory DonorHistory.fromJson(Map<String, dynamic> json) {
    return DonorHistory(
      id: json['id'].toString(),
      name: json['name'],
      blood_type: json['blood_type'],
      donorDate: json['donorDate'],
    );
  }
}
