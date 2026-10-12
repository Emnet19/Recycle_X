import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/language_service.dart';
import '../../../auth/providers/auth_provider.dart';

/// Profile page — migrated from lib/pages/profile.dart.
/// Now connected to [AuthProvider] for logout and real user data.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.appUser;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: ValueListenableBuilder<String>(
          valueListenable: LanguageService.languageNotifier,
          builder: (_, __, ___) => Text(
            LanguageService.t('profile'),
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ValueListenableBuilder<String>(
          valueListenable: LanguageService.languageNotifier,
          builder: (_, __, ___) {
            return Column(
              children: [
                // ── Avatar ───────────────────────────────────────────
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: user?.photoUrl != null
                          ? NetworkImage(user!.photoUrl!)
                          : null,
                      child: user?.photoUrl == null
                          ? const Icon(Icons.person,
                              size: 45, color: Colors.grey)
                          : null,
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.edit,
                            size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  user?.displayName ?? 'RecycleX User',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(LanguageService.t('level')),
                ),

                const SizedBox(height: 20),

                // ── Stats ─────────────────────────────────────────────
                Row(
                  children: [
                    _statCard('42kg', LanguageService.t('recycled')),
                    const SizedBox(width: 10),
                    _statCard('12', LanguageService.t('pickups')),
                  ],
                ),

                const SizedBox(height: 30),

                // ── Account section ───────────────────────────────────
                _section('ACCOUNT'),
                _tile(Icons.edit, LanguageService.t('editProfile'),
                    onTap: () {}),
                _tile(Icons.credit_card, LanguageService.t('payment'),
                    onTap: () {}),

                const SizedBox(height: 20),

                // ── App section ───────────────────────────────────────
                _section('APP'),
                _tile(Icons.notifications,
                    LanguageService.t('notifications'),
                    onTap: () {}),
                _languageTile(),

                const SizedBox(height: 20),

                // ── Support section ───────────────────────────────────
                _section('SUPPORT'),
                _tile(Icons.help_outline, LanguageService.t('help'),
                    onTap: () {}),

                const SizedBox(height: 30),

                // ── Logout ────────────────────────────────────────────
                TextButton.icon(
                  onPressed: () async {
                    await auth.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: Text(
                    LanguageService.t('logout'),
                    style: const TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _tile(IconData icon, String title,
      {required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.cardBg,
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }

  Widget _languageTile() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: const Icon(Icons.language),
        title: Text(LanguageService.t('language')),
        trailing: ValueListenableBuilder<String>(
          valueListenable: LanguageService.languageNotifier,
          builder: (_, lang, __) => Switch(
            value: lang == 'am',
            activeThumbColor: AppColors.primary,
            onChanged: (_) => LanguageService.toggleLanguage(),
          ),
        ),
      ),
    );
  }

  Widget _bottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 3,
      selectedItemColor: AppColors.primary,
      onTap: (i) {
        switch (i) {
          case 0:
            Navigator.pushReplacementNamed(context, '/customer/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/schedule-pickup');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/wallet');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), label: 'Schedule'),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
