import 'package:bloodhero_app/controller/userController.dart';
import 'package:bloodhero_app/views/home.dart';
import 'package:flutter/material.dart';
import 'views/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLogin = await UserController.checkLogin();
  runApp(MyApp(isLogin: isLogin));
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  
  const MyApp({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLogin ? const HomeView() : LoginView(),
    );
  }
}
