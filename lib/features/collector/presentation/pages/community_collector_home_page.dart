import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/providers/auth_provider.dart';

/// Community Collector Dashboard (Requirement 3)
/// Displays Community cooperative info, EcoPoints pool, volunteer cleanups, and local drop-off activities.
class CommunityCollectorHomePage extends StatefulWidget {
  const CommunityCollectorHomePage({super.key});

  @override
  State<CommunityCollectorHomePage> createState() =>
      _CommunityCollectorHomePageState();
}

class _CommunityCollectorHomePageState
    extends State<CommunityCollectorHomePage> {
  int _navIndex = 0;
  bool _acceptingDropoffs = true;

  // ── Role-specific sample data (Community cooperative collector) ──
  final List<_DropoffStation> _stations = [
    const _DropoffStation(
      title: 'Community Center Drop Station #2',
      address: 'Yeka-North, Station Hub',
      accepted: 'Plastic • Cans • Bottles',
      bins: '6 bins • 4 full',
      time: 'Today • 10:15 AM',
      status: 'Open',
      statusColor: AppColors.greenText,
      icon: Icons.inventory,
    ),
    const _DropoffStation(
      title: 'Megenagna Station Hub',
      address: 'Drop-off Bin: Megenagna',
      accepted: 'Metal Cans & Old Electronics',
      bins: '3 bins • 1 full',
      time: 'Yesterday • 04:00 PM',
      status: 'Open',
      statusColor: AppColors.greenText,
      icon: Icons.storefront_outlined,
    ),
    const _DropoffStation(
      title: 'Yeka Youth Center Bin',
      address: 'Next to Youth Center playground',
      accepted: 'Glass & Paper',
      bins: '2 bins • 2 full',
      time: 'Saturday • 09:00 AM',
      status: 'Needs Pickup',
      statusColor: Colors.orange,
      icon: Icons.delete_outline,
    ),
    const _DropoffStation(
      title: 'School Eco-Club Bin',
      address: 'Yeka Primary School Gate 2',
      accepted: 'Plastic Bottles',
      bins: '1 bin • 0 full',
      time: 'Monday • 07:30 AM',
      status: 'Closed',
      statusColor: AppColors.textSecondary,
      icon: Icons.school_outlined,
    ),
  ];

  final List<_Drive> _drives = [
    const _Drive(
      title: 'Saturday Clean-up Drive: Yeka Hillside',
      address: 'Meeting Point: Yeka Youth Center',
      time: 'Saturday • 08:00 AM',
      volunteers: 38,
      joined: false,
      icon: Icons.event,
    ),
    const _Drive(
      title: 'Household Metal & E-Waste Drive',
      address: 'Drop-off Bin: Megenagna Station Hub',
      time: 'Next Week • 04:00 PM',
      volunteers: 17,
      joined: true,
      icon: Icons.handshake_outlined,
    ),
    const _Drive(
      title: 'Riverbank Plastic Sweep (Kurtume)',
      address: 'Meeting Point: Kurtume Bridge',
      time: 'Sunday • 07:00 AM',
      volunteers: 24,
      joined: false,
      icon: Icons.waves,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.appUser;
    final orgName =
        user?.zoneOrOrganization ?? 'Green Community Youth Cooperative';

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
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.buttonGreen.withAlpha(50),
                      borderRadius: BorderRadius.circular(6),
                      border:
                          Border.all(color: AppColors.greenText.withAlpha(80)),
                    ),
                    child: const Text(
                      'COMMUNITY COLLECTOR',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.greenText,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              orgName,
              maxLines: 1,
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
                  color: _acceptingDropoffs
                      ? AppColors.greenText
                      : AppColors.textSecondary,
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
      body: _buildBody(),
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
          if (i == 3) {
            Navigator.pushNamed(context, '/profile');
            return;
          }
          setState(() => _navIndex = i);
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

  Widget _buildBody() {
    switch (_navIndex) {
      case 1:
        return _dropoffsBody();
      case 2:
        return _drivesBody();
      default:
        return _homeBody();
    }
  }

  // ── Tab 0: Home dashboard (unchanged design) ─────────────────────
  Widget _homeBody() {
    return SingleChildScrollView(
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
                _identityHeader(),
                const SizedBox(height: 16),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 14),

                // Community Impact Grid
                _responsiveStatTiles(
                  first: _infoStatTile(
                    icon: Icons.eco,
                    title: 'EcoCoins Pool',
                    value: '14,250 Coins',
                    subtitle: 'Distributed to volunteers',
                  ),
                  second: _infoStatTile(
                    icon: Icons.volunteer_activism_outlined,
                    title: 'Volunteers',
                    value: '38 Active',
                    subtitle: 'Involved this month',
                  ),
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
                    style: TextStyle(
                        color: AppColors.buttonText,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonGreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
                  icon: const Icon(Icons.cleaning_services,
                      color: AppColors.buttonText),
                  label: const Text(
                    'New Drive',
                    style: TextStyle(
                        color: AppColors.buttonText,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonGreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
              const Expanded(
                child: Text(
                  'Community Drop-offs & Drives',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => setState(() => _navIndex = 2),
                child: const Text(
                  'View All',
                  style: TextStyle(
                      color: AppColors.greenText, fontWeight: FontWeight.w600),
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
    );
  }

  // ── Tab 1: Drop-off Stations ─────────────────────────────────────
  Widget _dropoffsBody() {
    final openStations = _stations.where((s) => s.status != 'Closed').length;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Community Drop-offs',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$openStations of ${_stations.length} stations currently open',
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < _stations.length; i++)
            Padding(
              padding:
                  EdgeInsets.only(bottom: i == _stations.length - 1 ? 0 : 10),
              child: _activityItem(
                title: _stations[i].title,
                address: _stations[i].address,
                time: _stations[i].time,
                wasteType: '${_stations[i].accepted} • ${_stations[i].bins}',
                status: _stations[i].status,
                statusColor: _stations[i].statusColor,
                icon: _stations[i].icon,
              ),
            ),
        ],
      ),
    );
  }

  // ── Tab 2: Drives ────────────────────────────────────────────────
  Widget _drivesBody() {
    final joinedCount = _drives.where((d) => d.joined).length;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Clean-up Drives',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_drives.length} planned drives • you joined $joinedCount',
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < _drives.length; i++) _driveCard(_drives[i], i),
        ],
      ),
    );
  }

  Widget _driveCard(_Drive drive, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: index == _drives.length - 1 ? 0 : 12),
      child: Container(
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
              child: Icon(drive.icon, color: AppColors.greenText, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drive.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    drive.address,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.people_outline,
                          size: 14, color: AppColors.greenText),
                      const SizedBox(width: 4),
                      Text(
                        '${drive.volunteers} volunteers',
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.greenText,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    drive.time,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => _drives[index] = _Drive(
                                  title: drive.title,
                                  address: drive.address,
                                  time: drive.time,
                                  volunteers: drive.joined
                                      ? drive.volunteers - 1
                                      : drive.volunteers + 1,
                                  joined: !drive.joined,
                                  icon: drive.icon,
                                ));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(drive.joined
                                    ? 'Left "${drive.title}"'
                                    : 'Joined "${drive.title}" — see you there!'),
                                backgroundColor: AppColors.greenText,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: drive.joined
                                ? AppColors.sectionBg
                                : AppColors.buttonGreen,
                            side: drive.joined
                                ? const BorderSide(color: AppColors.border)
                                : BorderSide.none,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            drive.joined ? 'Joined ✓' : 'Join Drive',
                            style: TextStyle(
                              color: drive.joined
                                  ? AppColors.textSecondary
                                  : AppColors.buttonText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: AppColors.greenText),
          ),
        ],
      ),
    );
  }

  Widget _identityHeader() {
    final identity = Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primaryTint,
          child: Icon(Icons.groups, color: AppColors.greenText, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<AuthProvider>(
                builder: (context, auth, _) => Text(
                  auth.appUser?.displayName ?? 'Selamawit Desta',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Text(
                'Community Coordinator',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
    final hubBadge = Container(
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
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 300) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              identity,
              const SizedBox(height: 10),
              hubBadge,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: identity),
            const SizedBox(width: 8),
            hubBadge,
          ],
        );
      },
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
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
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
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.recycling,
                        size: 14, color: AppColors.greenText),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        wasteType,
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.greenText,
                            fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _responsiveStatTiles({
    required Widget first,
    required Widget second,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 280) {
          return Column(
            children: [
              first,
              const SizedBox(height: 12),
              second,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: first),
            const SizedBox(width: 12),
            Expanded(child: second),
          ],
        );
      },
    );
  }
}

class _DropoffStation {
  final String title;
  final String address;
  final String accepted;
  final String bins;
  final String time;
  final String status;
  final Color statusColor;
  final IconData icon;
  const _DropoffStation({
    required this.title,
    required this.address,
    required this.accepted,
    required this.bins,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.icon,
  });
}

class _Drive {
  final String title;
  final String address;
  final String time;
  final int volunteers;
  final bool joined;
  final IconData icon;
  const _Drive({
    required this.title,
    required this.address,
    required this.time,
    required this.volunteers,
    required this.joined,
    required this.icon,
  });
}
