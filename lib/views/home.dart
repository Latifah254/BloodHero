import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BloodHero")),
      body: const Center(
        child: Text(
          "Selamat Datang di BloodHero",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
