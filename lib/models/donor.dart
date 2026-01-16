class Donor {
  final String name;
  final String bloodType;
  final String donorDate;

  Donor({
    required this.name,
    required this.bloodType,
    required this.donorDate,
  });

  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
      name: json['name'],
      bloodType: json['blood_type'],
      donorDate: json['donor_date'],
    );
  }
}
