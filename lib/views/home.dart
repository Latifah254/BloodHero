import 'package:bloodhero_app/controller/userController.dart';
import 'package:bloodhero_app/views/addDonor.dart';
import 'package:bloodhero_app/views/donorHistory.dart';
import 'package:bloodhero_app/views/login.dart';
import 'package:flutter/material.dart';
import 'package:bloodhero_app/views/profile.dart';

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
              onPressed: (){
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (_) => DonorHistoryView(),
                  ),
                );
              }, 
              child: const Text("Riwayat Donor"),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileView()),
                );
              },
              child: const Text("Profil Saya"),
            ),
           
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const AddDonorView()),
                );
              }, 
              child: const Text("Tambah Donor"),
            ),


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
