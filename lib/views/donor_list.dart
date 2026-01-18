import 'package:bloodhero_app/controller/userController.dart';
import 'package:flutter/material.dart';
import 'package:bloodhero_app/controller/donorHistoryController.dart';
import 'package:bloodhero_app/models/donorHistory.dart';

class DonorListView extends StatefulWidget {
  const DonorListView({super.key});

  @override
  State<DonorListView> createState() => _DonorListViewState();
}

class _DonorListViewState extends State<DonorListView> {
  late Future<List<DonorHistory>> futureHistory;

  @override
  void initState() {
    super.initState();
  
  }

  void loadData() async {
    final userId = await UserController.getUserId();

    if (userId == null) {
      return;
    }

    setState(() {
      futureHistory = DonorHistoryController.fetchHistory(userId);
    });   
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Donor Darah"),
      ),
      body: FutureBuilder<List<DonorHistory>>(
        future: futureHistory,
        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Terjadi kesalahan: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // kosong
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Belum ada riwayat donor"),
            );
          }

          final history = snapshot.data!;

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.bloodtype,
                    color: Colors.red,
                  ),
                  title: const Text("Donor Darah"),
                  subtitle: Text(
                    "Tanggal donor: ${item.donorDate}",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
