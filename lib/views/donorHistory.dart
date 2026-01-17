import 'package:flutter/material.dart';
import 'package:bloodhero_app/controller/donorHistoryController.dart';
import 'package:bloodhero_app/models/donorHistory.dart';
import 'package:bloodhero_app/views/addDonor.dart';

class DonorHistoryView extends StatefulWidget {
  const DonorHistoryView({super.key});

  @override
  State<DonorHistoryView> createState() => _DonorHistoryViewState();
}

class _DonorHistoryViewState extends State<DonorHistoryView> {
  late Future<List<DonorHistory>> futureHistory;

  void loadData() {
    futureHistory = DonorHistoryController.fetchHistory(1);
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Donor"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddDonorView()),
              );

              if (result == true) {
                setState(loadData);
              }
            },
          )
        ],
      ),
      body: FutureBuilder<List<DonorHistory>>(
        future: futureHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Terjadi kesalahan: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada riwayat donor"));
          }

          final history = snapshot.data!;

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.bloodtype),
                  title: const Text("Donor Darah"),
                  subtitle: Text("Tanggal: ${history[index].donorDate}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
