import 'package:flutter/material.dart';
import 'package:bloodhero_app/controller/donorController.dart';
import 'package:bloodhero_app/models/donorHistory.dart';

class DonorHistoryView extends StatelessWidget {
  const DonorHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Donor"),
      ),
      body: FutureBuilder<List<DonorHistory>>(
        future: DonorController.fetchDonors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Belum ada data donor"),
            );
          }

          final donors = snapshot.data!;

          return ListView.builder(
            itemCount: donors.length,
            itemBuilder: (context, index) {
              final donor = donors[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: const Icon(Icons.bloodtype),
                  title: Text(donor.name),
                  subtitle: Text(
                    "Gol: ${donor.blood_type}\nTanggal: ${donor.donorDate}",
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
