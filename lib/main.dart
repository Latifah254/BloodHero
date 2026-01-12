import 'package:bloodhero_app/controller/userController.dart';
import 'package:bloodhero_app/views/home.dart';
import 'package:flutter/material.dart';
import 'views/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp (const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: UserController.checkLogin(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data == true) {
            return HomeView();
          } 
          return LoginView();
          
        },
      ),
    );
  }
}
