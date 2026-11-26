import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/providers/auth_provider.dart';

/// Kebele Collector Dashboard (Requirement 3)
/// Displays Kebele municipal zone coverage, daily quota, route pickups, and municipal activities.
class KebeleCollectorHomePage extends StatefulWidget {
  const KebeleCollectorHomePage({super.key});

  @override
  State<KebeleCollectorHomePage> createState() =>
      _KebeleCollectorHomePageState();
}

class _KebeleCollectorHomePageState extends State<KebeleCollectorHomePage> {
  int _navIndex = 0;
  bool _isOnDuty = true;

  // ── Role-specific sample data (Kebele municipal collector) ──────
  final List<_KebelePickupRequest> _requests = [
    const _KebelePickupRequest(
      id: 'REQ-KB-1041',
      title: 'Household Pickup — Bole Kebele 08',
      address: 'Woreda 03, Road 14, House 221',
      wasteType: 'Plastic & Organic (Separated)',
      time: 'Today • 02:00 PM',
      weight: '18 kg',
    ),
    const _KebelePickupRequest(
      id: 'REQ-KB-1042',
      title: 'Public Bin Overflow — Kebele Office',
      address: 'Near Kebele Administration Office',
      wasteType: 'Mixed Recyclables (Paper/Cardboard)',
      time: 'Today • 04:30 PM',
      weight: '45 kg',
    ),
    const _KebelePickupRequest(
      id: 'REQ-KB-1043',
      title: 'Commercial Zone Pickup Request',
      address: 'Bole Medhanialem Commercial Center',
      wasteType: 'Scrap Metal & Glass Waste',
      time: 'Tomorrow • 09:00 AM',
      weight: '120 kg',
    ),
  ];

  final List<_RouteCard> _zoneRoutes = [
    const _RouteCard(
      title: 'Zone Route A — Residential Blocks 1-46',
      address: 'Bole Sub-City, Kebele 08 / Roads 10-14',
      wasteType: 'Plastic & Organic (Separated)',
      time: 'Daily • 07:00 AM',
      status: 'Active',
      statusColor: AppColors.greenText,
      icon: Icons.home_work_outlined,
    ),
    const _RouteCard(
      title: 'Zone Route B — PublicBins & Offices',
      address: 'Kebele Administration & Market Area',
      wasteType: 'Mixed Recyclables (Paper/Cardboard)',
      time: 'Daily • 10:00 AM',
      status: 'Scheduled',
      statusColor: Colors.blue,
      icon: Icons.delete_outline,
    ),
    const _RouteCard(
      title: 'Zone Route C — Commercial District',
      address: 'Bole Medhanialem Commercial Center',
      wasteType: 'Scrap Metal & Glass Waste',
      time: 'Mon / Thu • 02:30 PM',
      status: 'Pending',
      statusColor: Colors.orange,
      icon: Icons.inventory_2_outlined,
    ),
    const _RouteCard(
      title: 'Zone Route D — Bulky Waste Sweep',
      address: 'Woreda 03, Road 20 corridor',
      wasteType: 'Furniture & E-Waste',
      time: 'Sat • 08:00 AM',
      status: 'Completed',
      statusColor: AppColors.success,
      icon: Icons.local_shipping,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.appUser;
    final kebeleZone =
        user?.zoneOrOrganization ?? 'Kebele 08 / Woreda 03 (Bole)';

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
                      'KEBELE COLLECTOR',
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
              kebeleZone,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
                  color:
                      _isOnDuty ? AppColors.greenText : AppColors.textSecondary,
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

  Widget _buildBody() {
    switch (_navIndex) {
      case 1:
        return _zoneRoutesBody();
      case 2:
        return _requestsBody();
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
                    Expanded(
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.primaryTint,
                            child: Icon(Icons.account_balance,
                                color: AppColors.greenText, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Consumer<AuthProvider>(
                                  builder: (context, auth, _) => Text(
                                    auth.appUser?.displayName ??
                                        'Tadesse Worku',
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
                                  'Municipal Solid Waste Inspector',
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
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
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
                _responsiveStatTiles(
                  first: _infoStatTile(
                    icon: Icons.speed,
                    title: 'Daily Target',
                    value: '820 / 1,000 kg',
                    subtitle: '82% of zone quota',
                  ),
                  second: _infoStatTile(
                    icon: Icons.home_work_outlined,
                    title: 'Households',
                    value: '142 Blocks',
                    subtitle: 'Active zone route',
                  ),
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
                  icon: const Icon(Icons.qr_code_scanner,
                      color: AppColors.buttonText),
                  label: const Text(
                    'Scan Bin',
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
                        content: Text('Municipal log updated'),
                        backgroundColor: AppColors.greenText,
                      ),
                    );
                  },
                  icon: const Icon(Icons.playlist_add_check,
                      color: AppColors.buttonText),
                  label: const Text(
                    'Log Batch',
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

          // ── Kebele Collection Requests & Activities ───────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Zone Route Pickups',
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
    );
  }

  // ── Tab 1: Zone Routes ───────────────────────────────────────────
  Widget _zoneRoutesBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Zone Routes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_zoneRoutes.length} assigned routes in your kebele zone',
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          _responsiveStatTiles(
            first: _infoStatTile(
              icon: Icons.route_outlined,
              title: 'Routes Assigned',
              value: '4 Routes',
              subtitle: '3 active this week',
            ),
            second: _infoStatTile(
              icon: Icons.scale_outlined,
              title: 'Collected Today',
              value: '540 kg',
              subtitle: 'Route A + Route B',
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < _zoneRoutes.length; i++)
            Padding(
              padding:
                  EdgeInsets.only(bottom: i == _zoneRoutes.length - 1 ? 0 : 10),
              child: _activityItem(
                title: _zoneRoutes[i].title,
                address: _zoneRoutes[i].address,
                time: _zoneRoutes[i].time,
                wasteType: _zoneRoutes[i].wasteType,
                status: _zoneRoutes[i].status,
                statusColor: _zoneRoutes[i].statusColor,
                icon: _zoneRoutes[i].icon,
              ),
            ),
        ],
      ),
    );
  }

  // ── Tab 2: Pickup Requests ───────────────────────────────────────
  Widget _requestsBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pickup Requests',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _requests.isEmpty
                ? 'All requests have been handled.'
                : '${_requests.length} pending request${_requests.length == 1 ? '' : 's'} in your zone',
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          if (_requests.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 48, color: AppColors.greenText),
                  SizedBox(height: 8),
                  Text('No pending requests',
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500)),
                  Text('New kebele requests will appear here.',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            )
          else
            for (var i = 0; i < _requests.length; i++)
              Padding(
                padding:
                    EdgeInsets.only(bottom: i == _requests.length - 1 ? 0 : 12),
                child: _requestCard(_requests[i], i),
              ),
        ],
      ),
    );
  }

  Widget _requestCard(_KebelePickupRequest request, int index) {
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
            child: const Icon(Icons.assignment,
                color: AppColors.greenText, size: 24),
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
                        request.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      request.weight,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.greenText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  request.address,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  request.id,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.greenText,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.recycling,
                        size: 14, color: AppColors.greenText),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        request.wasteType,
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
                  request.time,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _requests.removeAt(index));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '"${request.title}" accepted — added to route'),
                              backgroundColor: AppColors.greenText,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonGreen,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Accept',
                          style: TextStyle(
                              color: AppColors.buttonText,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _requests.removeAt(index));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('"${request.title}" declined'),
                              backgroundColor: AppColors.textSecondary,
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Decline',
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold),
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

class _KebelePickupRequest {
  final String id;
  final String title;
  final String address;
  final String wasteType;
  final String time;
  final String weight;
  const _KebelePickupRequest({
    required this.id,
    required this.title,
    required this.address,
    required this.wasteType,
    required this.time,
    required this.weight,
  });
}

class _RouteCard {
  final String title;
  final String address;
  final String wasteType;
  final String time;
  final String status;
  final Color statusColor;
  final IconData icon;
  const _RouteCard({
    required this.title,
    required this.address,
    required this.wasteType,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.icon,
  });
}
