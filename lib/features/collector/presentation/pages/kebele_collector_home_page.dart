import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/providers/auth_provider.dart';

/// Kebele Collector Dashboard (Requirement 3)
/// Displays Kebele municipal zone coverage, daily quota, route pickups, and municipal activities.
class KebeleCollectorHomePage extends StatefulWidget {
  const KebeleCollectorHomePage({super.key});

  @override
  State<KebeleCollectorHomePage> createState() => _KebeleCollectorHomePageState();
}

class _KebeleCollectorHomePageState extends State<KebeleCollectorHomePage> {
  int _navIndex = 0;
  bool _isOnDuty = true;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.appUser;
    final collectorName = user?.displayName ?? 'Tadesse Worku';
    final kebeleZone = user?.zoneOrOrganization ?? 'Kebele 08 / Woreda 03 (Bole)';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.buttonGreen.withAlpha(50),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.greenText.withAlpha(80)),
                  ),
                  child: const Text(
                    'KEBELE COLLECTOR',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.greenText,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              kebeleZone,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Text(
                _isOnDuty ? 'On Duty' : 'Off Duty',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _isOnDuty ? AppColors.greenText : AppColors.textSecondary,
                ),
              ),
              Switch(
                value: _isOnDuty,
                activeThumbColor: AppColors.greenText,
                activeTrackColor: AppColors.buttonGreen,
                onChanged: (val) => setState(() => _isOnDuty = val),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Kebele Officer Greeting & Info Card ───────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 22,
                            backgroundColor: Color(0xFFE8F5E9),
                            child: Icon(Icons.account_balance, color: AppColors.greenText, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                collectorName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const Text(
                                'Municipal Solid Waste Inspector',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.greenText.withAlpha(20),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'ID: KB-08-412',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greenText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 14),

                  // Municipal Stats Grid
                  Row(
                    children: [
                      Expanded(
                        child: _infoStatTile(
                          icon: Icons.speed,
                          title: 'Daily Target',
                          value: '820 / 1,000 kg',
                          subtitle: '82% of zone quota',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _infoStatTile(
                          icon: Icons.home_work_outlined,
                          title: 'Households',
                          value: '142 Blocks',
                          subtitle: 'Active zone route',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Quick Actions (using #53F19D for buttons) ─────────────
            const Text(
              'Kebele Operations',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Zone route scanner ready'),
                          backgroundColor: AppColors.greenText,
                        ),
                      );
                    },
                    icon: const Icon(Icons.qr_code_scanner, color: AppColors.buttonText),
                    label: const Text(
                      'Scan Bin',
                      style: TextStyle(color: AppColors.buttonText, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonGreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Municipal log updated'),
                          backgroundColor: AppColors.greenText,
                        ),
                      );
                    },
                    icon: const Icon(Icons.playlist_add_check, color: AppColors.buttonText),
                    label: const Text(
                      'Log Batch',
                      style: TextStyle(color: AppColors.buttonText, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonGreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Kebele Collection Requests & Activities ───────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Zone Route Pickups',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(color: AppColors.greenText, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            _activityItem(
              title: 'Kebele Sector 3 Residential Route',
              address: 'Bole Sub-City, Kebele 08 / Road 14',
              time: 'Today • 09:30 AM',
              wasteType: 'Plastic & Organic (Separated)',
              status: 'In Progress',
              statusColor: AppColors.greenText,
              icon: Icons.local_shipping,
            ),
            const SizedBox(height: 10),
            _activityItem(
              title: 'Municipal Public Bin 04',
              address: 'Near Kebele Administration Office',
              time: 'Today • 11:00 AM',
              wasteType: 'Mixed Recyclables (Paper/Cardboard)',
              status: 'Scheduled',
              statusColor: Colors.blue.shade700,
              icon: Icons.delete_outline,
            ),
            const SizedBox(height: 10),
            _activityItem(
              title: 'Commercial Zone Collection Point',
              address: 'Bole Medhanialem Commercial Center',
              time: 'Today • 02:30 PM',
              wasteType: 'Scrap Metal & Glass Waste',
              status: 'Pending',
              statusColor: Colors.orange.shade800,
              icon: Icons.inventory_2_outlined,
            ),
          ],
        ),
      ),

      // ── Consistent Bottom Navigation (Requirement 7) ───────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: AppColors.greenText,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: AppColors.surface,
        elevation: 8,
        onTap: (i) {
          setState(() => _navIndex = i);
          if (i == 3) {
            Navigator.pushNamed(context, '/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Zone Routes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _infoStatTile({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.sectionBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.greenText, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, color: AppColors.greenText),
          ),
        ],
      ),
    );
  }

  Widget _activityItem({
    required String title,
    required String address,
    required String time,
    required String wasteType,
    required String status,
    required Color statusColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.buttonGreen.withAlpha(40),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.greenText, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.recycling, size: 14, color: AppColors.greenText),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        wasteType,
                        style: const TextStyle(fontSize: 11, color: AppColors.greenText, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
