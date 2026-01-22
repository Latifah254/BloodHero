import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/donorHistoryController.dart';
import '../controller/userController.dart';
import '../models/donorHistory.dart';
import 'package:bloodhero_app/views/syaratDonor.dart';
import 'package:bloodhero_app/views/manfaatDonor.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<List<DonorHistory>>? futureHistory;
  String userName = "-";

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadDonorInfo();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("name") ?? "-";
    });
  }

  void _loadDonorInfo() async {
    final userId = await UserController.getUserId();
    if (userId == null) return;

    setState(() {
      futureHistory = DonorHistoryController.fetchHistory(userId);
    });
  }

  // 🔥 PENTING: refresh saat kembali ke halaman
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadDonorInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(),
            const SizedBox(height: 16),
            _statusDonorCard(),
            const SizedBox(height: 16),
            _statisticRow(), // ✅ FIX
            const SizedBox(height: 16),
            _infoSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Halo,", style: TextStyle(color: Colors.white70)),
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const CircleAvatar(
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white),
          )
        ],
      ),
    );
  }

  // ================= STATUS DONOR =================
  Widget _statusDonorCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FutureBuilder<List<DonorHistory>>(
        future: futureHistory,
        builder: (context, snapshot) {
          int daysLeft = 0;
          bool canDonate = true;

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final next =
                DonorHistoryController.getNextDonorDate(snapshot.data!);
            if (next != null && DateTime.now().isBefore(next)) {
              daysLeft = next.difference(DateTime.now()).inDays;
              canDonate = false;
            }
          }

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8),
              ],
            ),
            child: Column(
              children: [
                const Text("Status Donor",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  "$daysLeft",
                  style: const TextStyle(
                    fontSize: 36,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("Hari lagi bisa donor"),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: canDonate ? 1 : (90 - daysLeft) / 90,
                  color: Colors.red,
                ),
                const SizedBox(height: 8),
                Text(
                  canDonate ? "Anda sudah boleh donor" : "Belum boleh donor",
                  style: TextStyle(
                    color: canDonate ? Colors.green : Colors.red,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= STATISTIC (FIXED) =================
  Widget _statisticRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FutureBuilder<List<DonorHistory>>(
        future: futureHistory,
        builder: (context, snapshot) {
          int total = 0;
          int ml = 0;
          int badge = 0;

          if (snapshot.hasData) {
            total = DonorHistoryController.getTotalDonor(snapshot.data!);
            ml = DonorHistoryController.getTotalMl(snapshot.data!);
            badge = DonorHistoryController.getBadgeCount(snapshot.data!);
          }

          return Row(
            children: [
              _statCard(Icons.bloodtype, "Total Donor", "$total"),
              const SizedBox(width: 12),
              _statCard(Icons.trending_up, "ml Darah", "$ml"),
              const SizedBox(width: 12),
              _statCard(Icons.emoji_events, "Badges", "$badge"),
            ],
          );
        },
      ),
    );
  }

  Widget _statCard(IconData icon, String title, String value) {
    return Expanded(
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
          children: [
            Icon(icon, color: Colors.red),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            Text(title,
                style:
                    const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // ================= INFO SECTION =================
  Widget _infoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _menuCardGradient(
            title: "Syarat Donor Darah",
            subtitle: "Pelajari persyaratan",
            colors: const [Color(0xff2196f3), Color(0xff3f51b5)],
            onTap: () {
              Navigator.push(
                context, 
                  MaterialPageRoute(builder: (_) => const SyaratDonorPage(),
                  ),
              );
            },
          ),
          const SizedBox(height: 12),
          _menuCardGradient(
            title: "Manfaat Donor Darah",
            subtitle: "Untuk kesehatan Anda",
            colors: const [Color(0xff4caf50), Color(0xff2e7d32)],
            onTap: () {
              Navigator.push(
                context, 
                  MaterialPageRoute(builder: (_) => const ManfaatDonorPage(),
                  ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _menuCardGradient({
    required String title,
    required String subtitle,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}