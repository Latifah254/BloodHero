import 'package:flutter/material.dart';

class ManfaatDonorPage extends StatelessWidget {
  const ManfaatDonorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manfaat Donor Darah"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(
              title: "Manfaat Kesehatan",
              icon: Icons.favorite,
              items: [
                "Membantu regenerasi sel darah",
                "Menjaga kesehatan jantung",
                "Mengurangi risiko stroke",
                "Mengontrol zat besi",
                "Tubuh lebih segar",
              ],
            ),
            _buildCard(
              title: "Manfaat Psikologis",
              icon: Icons.psychology,
              items: [
                "Meningkatkan empati",
                "Memberi rasa bahagia",
                "Kepuasan batin",
              ],
            ),
            _buildCard(
              title: "Manfaat Sosial",
              icon: Icons.people,
              items: [
                "1 donor = 3 nyawa",
                "Membantu pasien darurat",
                "Gerakan kemanusiaan",
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<String> items,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...items.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 6),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}