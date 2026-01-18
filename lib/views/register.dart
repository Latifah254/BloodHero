import 'package:flutter/material.dart';
import 'package:bloodhero_app/controller/userController.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? selectedBlood;
  DateTime? birthDate;

  final bloodTypes = ['A', 'B', 'AB', 'O'];

  void handleRegister() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        selectedBlood == null ||
        birthDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Lengkapi semua data")));
      return;
    }

    final success = await UserController.register(
      nameController.text,
      emailController.text,
      passwordController.text,
      selectedBlood!,
      birthDate!.toIso8601String().split("T")[0],
    );

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Register gagal")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nama")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),

            const SizedBox(height: 12),

            DropdownButtonFormField(
              initialValue: selectedBlood,
              items: bloodTypes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => selectedBlood = v),
              decoration: const InputDecoration(labelText: "Golongan Darah"),
            ),

            const SizedBox(height: 12),

            ListTile(
              title: Text(birthDate == null
                  ? "Pilih tanggal lahir"
                  : "${birthDate!.day}-${birthDate!.month}-${birthDate!.year}"),
              trailing: const Icon(Icons.date_range),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                  initialDate: DateTime(2000),
                );
                if (picked != null) setState(() => birthDate = picked);
              },
            ),

            const SizedBox(height: 24),
            ElevatedButton(onPressed: handleRegister, child: const Text("Register")),
          ],
        ),
      ),
    );
  }
}
