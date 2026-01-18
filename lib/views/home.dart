import 'package:flutter/material.dart';
import 'package:bloodhero_app/controller/userController.dart';
import 'package:bloodhero_app/controller/donorHistoryController.dart';
import 'package:bloodhero_app/models/donorHistory.dart';
import 'package:bloodhero_app/views/donorHistory.dart';
import 'package:bloodhero_app/views/profile.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<List<DonorHistory>>? futureHistory;

  @override
  void initState() {
    super.initState();
    loadDonorInfo();
  }

  void loadDonorInfo() async {
    final userId = await UserController.getUserId();
    if (userId == null) return;

    setState(() {
      futureHistory = DonorHistoryController.fetchHistory(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BloodHero"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Selamat Datang di BloodHero",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              /// ===== INFORMASI DONOR =====
              FutureBuilder<List<DonorHistory>>(
                future: futureHistory,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "🩸 Anda belum memiliki riwayat donor.\nSilakan donor pertama Anda!",
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final history = snapshot.data!;
                  final nextDate =
                      DonorHistoryController.getNextDonorDate(history);

                  final today = DateTime.now();
                  final canDonate =
                      nextDate == null || today.isAfter(nextDate);

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: canDonate
                          ? Colors.green[100]
                          : Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Status Donor Darah",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          canDonate
                              ? "✅ Anda sudah boleh donor darah lagi"
                              : "⏳ Anda bisa donor lagi pada:\n"
                                "${nextDate.day}-${nextDate.month}-${nextDate.year}",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              /// ===== MENU =====
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DonorHistoryView(),
                    ),
                  );
                },
                child: const Text("Riwayat Donor"),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileView(),
                    ),
                  );
                },
                child: const Text("Profil Saya"),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
