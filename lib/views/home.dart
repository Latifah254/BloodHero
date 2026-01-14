import 'package:bloodhero_app/controller/userController.dart';
import 'package:bloodhero_app/views/login.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BloodHero"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Selamat Datang di BloodHero"),
            const SizedBox(height: 20,),

            ElevatedButton(
              onPressed: () async {
                await UserController.logout();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(
                    builder: (_) => LoginView()),
                    (route) => false,
                );
              },
              child: const Text("Logout"),
            ),
          ],
        )
      ),
    );
  }
}
