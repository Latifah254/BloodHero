class DonorHistory {
  final int id;
  final String donorDate;

  DonorHistory({
    required this.id,
    required this.donorDate,
  });

  factory DonorHistory.fromJson(Map<String, dynamic> json) {
    return DonorHistory(
      id: int.parse(json['id'].toString()),
      donorDate: json['donor_date'],
    );
  }
}
