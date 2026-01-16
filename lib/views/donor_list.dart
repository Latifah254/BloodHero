import 'package:flutter/material.dart';
import 'package:bloodhero_app/controller/donorController.dart';
import 'package:bloodhero_app/models/donorHistory.dart';

class DonorListView extends StatelessWidget {
  const DonorListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Donor Darah"),
      ),
      body: FutureBuilder<List<DonorHistory>>(
        future: DonorController.fetchDonors(),
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

          // data kosong
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
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(donor.blood_type),
                  ),
                  title: Text(donor.name),
                  subtitle: Text("Tanggal donor: ${donor.donorDate}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
