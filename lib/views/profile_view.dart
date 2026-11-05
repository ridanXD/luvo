import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../core/theme.dart';
import 'login_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  void _logout(BuildContext context) {
    AuthController.instance.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthController.instance.currentUser;
    final name = user?.name.isNotEmpty == true ? user!.name : 'Pengguna';
    final email = user?.email.isNotEmpty == true ? user!.email : '-';
    final role = user?.role ?? 'user';
    final isMerchant = role.toLowerCase() == 'merchant';
    final roleText = isMerchant ? 'Merchant' : 'User';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Profil',
          style: AppFonts.heading(size: 20, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFFEBF1FA),
                    child: Icon(
                      isMerchant ? Icons.storefront : Icons.person,
                      size: 44,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    name,
                    style: AppFonts.heading(size: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: AppFonts.body(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.badge_outlined, color: AppColors.secondary),
                    title: Text('Nama', style: AppFonts.body(color: Colors.grey, size: 12)),
                    subtitle: Text(name, style: AppFonts.body(size: 15, color: Colors.black87)),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(Icons.email_outlined, color: AppColors.secondary),
                    title: Text('Email', style: AppFonts.body(color: Colors.grey, size: 12)),
                    subtitle: Text(email, style: AppFonts.body(size: 15, color: Colors.black87)),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: Icon(
                      isMerchant ? Icons.storefront_outlined : Icons.account_circle_outlined,
                      color: AppColors.secondary,
                    ),
                    title: Text('Peran Akun', style: AppFonts.body(color: Colors.grey, size: 12)),
                    subtitle: Text(roleText, style: AppFonts.body(size: 15, color: Colors.black87)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: Text(
                  'Logout',
                  style: AppFonts.heading(size: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
