class DonorHistory {
  final int id;
  final int userId;
  final String donorDate;

  DonorHistory({
    required this.id,
    required this.userId,
    required this.donorDate,
  });

  factory DonorHistory.fromJson(Map<String, dynamic> json) {
    return DonorHistory(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      donorDate: json['donor_date'],
    );
  }
}
