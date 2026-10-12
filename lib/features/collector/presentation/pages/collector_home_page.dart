import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/providers/auth_provider.dart';

/// Collector home dashboard.
/// Shows active collection requests, today's schedule, earnings summary.
class CollectorHomePage extends StatelessWidget {
  const CollectorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final name = auth.appUser?.displayName ?? 'Collector';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'RecycleX Collector',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              'Hello, $name 👋',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          // Availability toggle
          Row(
            children: [
              const Text('Available',
                  style: TextStyle(fontSize: 12)),
              Switch(
                value: true,
                activeThumbColor: AppColors.primary,
                onChanged: (_) {},
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Earnings card ─────────────────────────────────────────
            _EarningsCard(),

            const SizedBox(height: 24),

            const Text(
              'Pending Requests',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _PendingRequestsPlaceholder(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: 'Requests'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Earnings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (i) {
          if (i == 3) Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }
}

class _EarningsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.collectorRole, Color(0xFF1976D2)],
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
                Text('Today\'s Earnings',
                    style:
                        TextStyle(color: Colors.white70, fontSize: 13)),
                SizedBox(height: 4),
                Text('ETB 0.00',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                Text('0 collections completed',
                    style:
                        TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.directions_bike,
              size: 60, color: Colors.white24),
        ],
      ),
    );
  }
}

class _PendingRequestsPlaceholder extends StatelessWidget {
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
          Icon(Icons.inbox_outlined,
              size: 48, color: AppColors.textSecondary),
          SizedBox(height: 8),
          Text('No pending requests',
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500)),
          Text('New requests will appear here.',
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}
