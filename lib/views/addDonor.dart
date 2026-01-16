import 'package:flutter/material.dart';
import 'package:bloodhero_app/controller/donorHistoryController.dart';

class AddDonorView extends StatefulWidget {
  const AddDonorView({super.key});

  @override
  State<AddDonorView> createState() => _AddDonorViewState();
}

class _AddDonorViewState extends State<AddDonorView> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final bloodTypeController = TextEditingController();
  final dateController = TextEditingController();

  bool isLoading = false;

  Future<void> submitDonor() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final success = await DonorHistoryController.addDonor(
      nameController.text,
      bloodTypeController.text,
      dateController.text,
    );

    setState(() => isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? "Donor berhasil ditambahkan" : "Gagal menambah donor",
        ),
      ),
    );

    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Donor")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nama"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: bloodTypeController,
                decoration: const InputDecoration(labelText: "Golongan Darah"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(labelText: "Tanggal Donor"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : submitDonor,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
