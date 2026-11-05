import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/providers/auth_provider.dart';

/// Community Collector Dashboard (Requirement 3)
/// Displays Community cooperative info, EcoPoints pool, volunteer cleanups, and local drop-off activities.
class CommunityCollectorHomePage extends StatefulWidget {
  const CommunityCollectorHomePage({super.key});

  @override
  State<CommunityCollectorHomePage> createState() => _CommunityCollectorHomePageState();
}

class _CommunityCollectorHomePageState extends State<CommunityCollectorHomePage> {
  int _navIndex = 0;
  bool _acceptingDropoffs = true;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.appUser;
    final leaderName = user?.displayName ?? 'Selamawit Desta';
    final orgName = user?.zoneOrOrganization ?? 'Green Community Youth Cooperative';

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
                    'COMMUNITY COLLECTOR',
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
              orgName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Text(
                _acceptingDropoffs ? 'Open' : 'Closed',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _acceptingDropoffs ? AppColors.greenText : AppColors.textSecondary,
                ),
              ),
              Switch(
                value: _acceptingDropoffs,
                activeThumbColor: AppColors.greenText,
                activeTrackColor: AppColors.buttonGreen,
                onChanged: (val) => setState(() => _acceptingDropoffs = val),
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
            // ── Community Leader & EcoPool Card ───────────────────────
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
                            backgroundColor: Color(0xFFE0F2F1),
                            child: Icon(Icons.groups, color: AppColors.greenText, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                leaderName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const Text(
                                'Community Coordinator',
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
                          color: AppColors.buttonGreen.withAlpha(60),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Hub: Yeka-North',
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

                  // Community Impact Grid
                  Row(
                    children: [
                      Expanded(
                        child: _infoStatTile(
                          icon: Icons.eco,
                          title: 'EcoCoins Pool',
                          value: '14,250 Coins',
                          subtitle: 'Distributed to volunteers',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _infoStatTile(
                          icon: Icons.volunteer_activism_outlined,
                          title: 'Volunteers',
                          value: '38 Active',
                          subtitle: 'Involved this month',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Quick Community Actions (using #53F19D for buttons) ───
            const Text(
              'Community Actions',
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
                          content: Text('Member EcoCoins reward window opened'),
                          backgroundColor: AppColors.greenText,
                        ),
                      );
                    },
                    icon: const Icon(Icons.stars, color: AppColors.buttonText),
                    label: const Text(
                      'Award Coins',
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
                          content: Text('New Community Clean-up Drive created'),
                          backgroundColor: AppColors.greenText,
                        ),
                      );
                    },
                    icon: const Icon(Icons.cleaning_services, color: AppColors.buttonText),
                    label: const Text(
                      'New Drive',
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

            // ── Community Drop-offs & Neighborhood Activities ─────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Community Drop-offs & Drives',
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
              title: 'Neighborhood Plastic Drop-off',
              address: 'Community Center Drop Station #2',
              time: 'Today • 10:15 AM',
              wasteType: 'Plastic Bottles (45 kg)',
              status: 'Received',
              statusColor: AppColors.greenText,
              icon: Icons.inventory,
            ),
            const SizedBox(height: 10),
            _activityItem(
              title: 'Saturday Clean-up Drive: Yeka Hillside',
              address: 'Meeting Point: Yeka Youth Center',
              time: 'Saturday • 08:00 AM',
              wasteType: 'General Litter & Single-use Plastic',
              status: 'Upcoming',
              statusColor: Colors.blue.shade700,
              icon: Icons.event,
            ),
            const SizedBox(height: 10),
            _activityItem(
              title: 'Household Metal & E-Waste Drive',
              address: 'Drop-off Bin: Megenagna Station Hub',
              time: 'Yesterday • 04:00 PM',
              wasteType: 'Metal Cans & Old Electronics',
              status: 'Sent to Recycler',
              statusColor: Colors.purple.shade700,
              icon: Icons.handshake_outlined,
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
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Drop-offs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'Drives',
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
