import 'package:flutter/material.dart';
import '../controller/donorHistoryController.dart';
import '../controller/userController.dart';

class AddDonorView extends StatefulWidget {
  const AddDonorView({super.key});

  @override
  State<AddDonorView> createState() => _AddDonorViewState();
}

class _AddDonorViewState extends State<AddDonorView> {
  DateTime? selectedDate;
  bool loading = false;
  int? userId;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController locationController =
      TextEditingController(text: "");
  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    userId = await UserController.getUserId();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _save() async {
    if (selectedDate == null || userId == null) return;
    setState(() => loading = true);

    try {
      final history =
          await DonorHistoryController.fetchHistory(userId!);

      if (!DonorHistoryController.canAddDonor(history, selectedDate!)) {
        final next =
            DonorHistoryController.getNextDonorDate(history);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Belum bisa donor"),
            content: Text("Bisa donor lagi pada:\n$next"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              )
            ],
          ),
        );
        return;
      }

      final ok = await DonorHistoryController.addDonor(
        userId: userId!,
        donorDate: selectedDate!.toIso8601String().split('T')[0],
      );

      if (ok) {
        Navigator.pop(context, true);
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final InputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 0.5,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // ===== HEADER =====
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 200),
            padding: const EdgeInsets.fromLTRB(16, 72, 16, 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE53935), Color(0xFFD81B60)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero, 
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 26,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 24),
                  const Text(
                  "Tambah Riwayat Donor",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                    ),
                  ),
              
                  const SizedBox(height: 4),
                  const Text(
                    "Catat aktivitas donor Anda",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

          // ===== FORM =====
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TANGGAL
                    const Text("Tanggal Donor"),
                    const SizedBox(height: 6),
                    TextField(
                      controller: dateController,
                      readOnly: true,
                      onTap: _pickDate,
                      decoration: const InputDecoration(
                        hintText: "hh/bb/tttt",
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // LOKASI (UI SAJA)
                    const Text("Lokasi Donor"),
                    const SizedBox(height: 6),
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        hintText: "contoh: PMI Surabaya",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // CATATAN (UI SAJA)
                    const Text("Catatan (Opsional)"),
                    const SizedBox(height: 6),
                    TextField(
                      controller: noteController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: "Tambahkan catatan...",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // SIMPAN
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading ? null : _save,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFFD81B60),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "Simpan Riwayat",
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // BATAL
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text("Batal"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}