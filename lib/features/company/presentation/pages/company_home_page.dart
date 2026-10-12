import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/providers/auth_provider.dart';

/// Company home dashboard.
/// Shows available materials, recycling stats, company profile overview.
class CompanyHomePage extends StatelessWidget {
  const CompanyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final name = auth.appUser?.displayName ?? 'Company';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'RecycleX Company',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.companyRole,
              ),
            ),
            Text(
              'Welcome, $name',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Materials overview card ───────────────────────────────
            _MaterialsCard(),

            const SizedBox(height: 24),

            const Text(
              'Available Materials',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _MaterialsPlaceholder(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.companyRole,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              label: 'Materials'),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              label: 'Analytics'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), label: 'Profile'),
        ],
        onTap: (i) {
          if (i == 3) Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }
}

class _MaterialsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.companyRole, Color(0xFF8E24AA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Materials Processed',
                    style:
                        TextStyle(color: Colors.white70, fontSize: 13)),
                SizedBox(height: 4),
                Text('0 kg',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                Text('This month',
                    style:
                        TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.factory_outlined,
              size: 60, color: Colors.white24),
        ],
      ),
    );
  }
}

class _MaterialsPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 48, color: AppColors.textSecondary),
          SizedBox(height: 8),
          Text('No materials available yet',
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500)),
          Text('Available recyclable materials will appear here.',
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 12),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
