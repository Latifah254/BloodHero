import 'package:flutter/material.dart';
import 'package:bloodhero_app/controller/donorHistoryController.dart';
import 'package:bloodhero_app/controller/userController.dart';

class AddDonorView extends StatefulWidget {
  const AddDonorView({super.key});

  @override
  State<AddDonorView> createState() => _AddDonorViewState();
}

class _AddDonorViewState extends State<AddDonorView> {
  DateTime? selectedDate;
  bool isLoading = false;

  Future<void> saveDonor() async {
    if (selectedDate == null) {
      showMsg("Tanggal donor wajib diisi");
      return;
    }

    final userId = await UserController.getUserId();
    if (userId == null) return;

    setState(() => isLoading = true);

    final history =
        await DonorHistoryController.fetchHistory(userId);

    final isAllowed =
        DonorHistoryController.canAddDonor(
      history,
      selectedDate!,
    );

    if (!isAllowed) {
      setState(() => isLoading = false);
      showMsg(
        "Belum waktunya donor.\nMinimal 90 hari dari donor terakhir.",
      );
      return;
    }

    final success = await DonorHistoryController.addDonor(
      userId: userId,
      donorDate:
          "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}",
    );

    setState(() => isLoading = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      showMsg("Gagal menyimpan data donor");
    }
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Riwayat Donor")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text(
                selectedDate == null
                    ? "Pilih tanggal donor"
                    : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  initialDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => selectedDate = picked);
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : saveDonor,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
