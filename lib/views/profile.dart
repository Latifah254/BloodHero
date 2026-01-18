import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bloodhero_app/controller/userController.dart';
import 'package:bloodhero_app/views/login.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Map<String, String> user = {};
  File? photo;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() async {
    final data = await UserController.getProfile();
    setState(() {
      user = data;
      if (data["photo"]!.isNotEmpty) {
        photo = File(data["photo"]!);
      }
    });
  }

  void pickPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await UserController.savePhoto(image.path);
      setState(() => photo = File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickPhoto,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: photo != null ? FileImage(photo!) : null,
                child: photo == null ? const Icon(Icons.person, size: 50) : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(user["name"] ?? "", style: const TextStyle(fontSize: 20)),
            Text(user["email"] ?? ""),
            const Divider(),
            ListTile(title: const Text("Golongan Darah"), subtitle: Text(user["blood_type"] ?? "-")),
            ListTile(title: const Text("Tanggal Lahir"), subtitle: Text(user["birth_date"] ?? "-")),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await UserController.logout();
                if (!mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginView()),
                  (route) => false,
                );
              },
              child: const Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
