import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../core/theme.dart';
import 'login_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: AppFonts.heading(size: 18, color: Colors.white)),
        backgroundColor: AppColors.secondary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              AuthController.instance.logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginView()));
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Selamat Datang',
            style: AppFonts.heading(size: 24),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
