import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloodhero_app/controller/userController.dart';
import 'login.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String name = "-";
  String email = "-";
  String bloodType = "-";
  String birthDate = "-";
  File? photo;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final photoPath = prefs.getString("photo");

    setState(() {
      name = prefs.getString("name") ?? "-";
      email = prefs.getString("email") ?? "-";
      bloodType = prefs.getString("blood_type") ?? "-";
      birthDate = prefs.getString("birth_date") ?? "-";
      if (photoPath != null) photo = File(photoPath);
    });
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 70);
    if (image == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("photo", image.path);

    setState(() {
      photo = File(image.path);
    });
  }

  void showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Kamera"),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Galeri"),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow(String title, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // ================= HEADER =================
          Container(
            width: double.infinity,
            height: 260,
            padding: const EdgeInsets.only(top: 50),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE53935), Color(0xFFD81B60)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  "Profil Saya",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: showPicker,
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    backgroundImage:
                        photo != null ? FileImage(photo!) : null,
                    child: photo == null
                        ? const Icon(Icons.person,
                            color: Colors.white, size: 50)
                        : null,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  "Pendonor Aktif",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // ================= CONTENT =================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ---------- CARD INFO ----------
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        infoRow(
                          "Golongan Darah",
                          bloodType,
                          valueColor: Colors.red,
                        ),
                        const Divider(),
                        infoRow("Tanggal Lahir", birthDate),
                        const Divider(),
                        infoRow("Email", email),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ---------- MENU ----------
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: const [
                        ListTile(
                          title: Text("Edit Profil"),
                          trailing: Icon(Icons.chevron_right),
                        ),
                        Divider(height: 1),
                        ListTile(
                          title: Text("Pengaturan"),
                          trailing: Icon(Icons.chevron_right),
                        ),
                        Divider(height: 1),
                        ListTile(
                          title: Text("Tentang Aplikasi"),
                          trailing: Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ---------- LOGOUT ----------
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await UserController.logout();
                        if (!mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginView(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}