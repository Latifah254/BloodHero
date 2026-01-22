import 'package:flutter/material.dart';

class SyaratDonorPage extends StatelessWidget {
  const SyaratDonorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Syarat Donor Darah"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(
              title: "Syarat Umum",
              items: [
                "Usia 17–60 tahun",
                "Berat badan minimal 45 kg",
                "Sehat jasmani & rohani",
                "Tidur minimal 5 jam",
                "Tidak sedang sakit",
                "Jarak donor minimal 3 bulan",
              ],
            ),
            _buildCard(
              title: "Syarat Teknis",
              items: [
                "Tekanan darah normal",
                "Hb perempuan ≥ 12.5 g/dL",
                "Hb laki-laki ≥ 13 g/dL",
                "Denyut nadi 50–100/menit",
                "Tidak hamil / menyusui",
                "Tidak konsumsi alkohol 24 jam",
              ],
            ),
            _buildCard(
              title: "Belum Bisa Donor Jika",
              items: [
                "Sedang minum antibiotik",
                "Baru operasi / transfusi",
                "Sedang haid",
                "Baru vaksinasi",
                "Memiliki penyakit menular",
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<String> items}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            ...items.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, size: 18, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}