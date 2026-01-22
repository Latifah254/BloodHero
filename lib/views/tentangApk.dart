import 'package:flutter/material.dart';

class TentangAplikasiPage extends StatelessWidget {
  const TentangAplikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(context),
            const SizedBox(height: 16),
            _infoCard(),
            const SizedBox(height: 16),
            _featureCard(),
            const SizedBox(height: 16),
            _footer(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xfff44336), Color(0xffe91e63)],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Text(
            "Tentang Aplikasi",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  // ================= INFO APP =================
  Widget _infoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Aplikasi Donor Darah",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Aplikasi ini dibuat untuk membantu masyarakat dalam "
              "memantau status donor, riwayat donor, serta memberikan "
              "informasi lengkap mengenai syarat dan manfaat donor darah. "
              "Dengan aplikasi ini, diharapkan proses donor menjadi lebih "
              "mudah, cepat, dan terorganisir.",
              style: TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  // ================= FITUR =================
  Widget _featureCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Fitur Utama",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _FeatureItem(icon: Icons.favorite, text: "Cek status donor secara real-time"),
            _FeatureItem(icon: Icons.history, text: "Riwayat donor darah"),
            _FeatureItem(icon: Icons.info, text: "Informasi syarat & manfaat donor"),
            _FeatureItem(icon: Icons.emoji_events, text: "Badge & pencapaian donor"),
            _FeatureItem(icon: Icons.person, text: "Manajemen profil pengguna"),
          ],
        ),
      ),
    );
  }

  // ================= FOOTER =================
  Widget _footer() {
    return Column(
      children: const [
        Text("Versi Aplikasi 1.0.0", style: TextStyle(color: Colors.grey)),
        SizedBox(height: 4),
        Text("Dikembangkan untuk Project Akademik",
            style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}

// ================= COMPONENT =================
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.red),
          SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}