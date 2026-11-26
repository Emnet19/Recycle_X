import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/providers/auth_provider.dart';

/// Company home dashboard.
/// Shows available materials, recycling stats, company profile overview.
class CompanyHomePage extends StatefulWidget {
  const CompanyHomePage({super.key});

  @override
  State<CompanyHomePage> createState() => _CompanyHomePageState();
}

class _CompanyHomePageState extends State<CompanyHomePage> {
  int _navIndex = 0;

  // ── Role-specific sample data (Recycling company) ────────────────
  static const int _monthTotalKg = 12480;

  final List<_MaterialBatch> _materials = [
    const _MaterialBatch(
      type: 'Plastic Bottles (PET)',
      weight: '620 kg',
      source: 'Kebele 08 Zone Route',
      quality: 'A — Clean, separated',
      time: 'Today • 09:30 AM',
    ),
    const _MaterialBatch(
      type: 'Paper & Cardboard',
      weight: '410 kg',
      source: 'Megenagna Station Hub',
      quality: 'B — Minor contamination',
      time: 'Today • 11:00 AM',
    ),
    const _MaterialBatch(
      type: 'Scrap Metal',
      weight: '180 kg',
      source: 'Commercial Zone Pickup',
      quality: 'A — Sorted ferrous',
      time: 'Yesterday • 03:15 PM',
    ),
    const _MaterialBatch(
      type: 'Glass Waste',
      weight: '240 kg',
      source: 'Yeka Drop-off Bins',
      quality: 'B — Mixed colors',
      time: 'Yesterday • 05:40 PM',
    ),
  ];

  final List<_Shipment> _shipments = [
    _Shipment(
      id: 'SHP-C-2201',
      title: 'Incoming — PET Bale Shipment',
      source: 'Kebele 08 Sorting Center',
      weight: '620 kg',
      time: 'Tomorrow • 08:00 AM',
      status: 'Scheduled',
      statusColor: Colors.blue.shade700,
    ),
    _Shipment(
      id: 'SHP-C-2202',
      title: 'Incoming — Mixed Paper Batch',
      source: 'Community Hub: Yeka-North',
      weight: '410 kg',
      time: 'Tomorrow • 10:30 AM',
      status: 'Scheduled',
      statusColor: Colors.blue.shade700,
    ),
    _Shipment(
      id: 'SHP-C-2199',
      title: 'Received — Scrap Metal Load',
      source: 'Commercial Zone Collector',
      weight: '180 kg',
      time: 'Yesterday • 03:15 PM',
      status: 'Received',
      statusColor: AppColors.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final name = auth.appUser?.displayName ?? 'Company';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
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
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: AppColors.companyRole,
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
      ),
    );
  }

  Widget _buildBody() {
    switch (_navIndex) {
      case 1:
        return _materialsBody();
      case 2:
        return _analyticsBody();
      default:
        return _homeBody();
    }
  }

  // ── Tab 0: Home dashboard ────────────────────────────────────────
  Widget _homeBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Materials overview card ───────────────────────────────
          _MaterialsCard(totalKg: _monthTotalKg),

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
          for (final batch in _materials) _materialTile(batch),
        ],
      ),
    );
  }

  Widget _materialTile(_MaterialBatch batch) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  batch.type,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                batch.weight,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.companyRole,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Source: ${batch.source} • ${batch.time}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.companyRole.withAlpha(20),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  batch.quality,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.companyRole,
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Request sent: ${batch.type} (${batch.weight})'),
                      backgroundColor: AppColors.companyRole,
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: Size.zero,
                  backgroundColor: AppColors.companyRole.withAlpha(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Request',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.companyRole,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Tab 1: Materials / Incoming Shipments ────────────────────────
  Widget _materialsBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Incoming Shipments',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_shipments.length} shipments in the company pipeline',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          for (final shipment in _shipments)
            _shipmentCard(shipment),
        ],
      ),
    );
  }

  Widget _shipmentCard(_Shipment shipment) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.companyRole.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_shipping,
                color: AppColors.companyRole, size: 24),
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
                        shipment.title,
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
                        color: shipment.statusColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        shipment.status,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: shipment.statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${shipment.source} • ${shipment.weight}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      shipment.id,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.companyRole,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      shipment.time,
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 34,
                  child: ElevatedButton(
                    onPressed: shipment.status == 'Received'
                        ? null
                        : () {
                            setState(() {
                              shipment.status = 'Received';
                              shipment.statusColor = AppColors.success;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${shipment.id} marked as received (${shipment.weight} added)'),
                                backgroundColor: AppColors.companyRole,
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.companyRole,
                      disabledBackgroundColor:
                          AppColors.sectionBg,
                      disabledForegroundColor: AppColors.textSecondary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    ),
                    child: Text(
                      shipment.status == 'Received' ? 'Received ✓' : 'Confirm Receipt',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab 2: Analytics ─────────────────────────────────────────────
  Widget _analyticsBody() {
    const weekly = <String, int>{
      'Sat': 1420,
      'Sun': 980,
      'Mon': 1680,
      'Tue': 2210,
      'Wed': 1940,
      'Thu': 2380,
      'Fri': 1870,
    };
    final maxKg = weekly.values
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weekly volume bar chart
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weekly Processing Volume',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total: ${weekly.values.reduce((a, b) => a + b)} kg this week',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final entry in weekly.entries)
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${entry.value}',
                                style: const TextStyle(
                                    fontSize: 9,
                                    color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 18,
                                height: 78 *
                                    (entry.value / maxKg),
                                decoration: BoxDecoration(
                                  color: AppColors.companyRole
                                      .withAlpha(200),
                                  borderRadius:
                                      BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                entry.key,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _analyticsTile(
                  icon: Icons.factory_outlined,
                  title: 'This Month',
                  value: '12,480 kg',
                  subtitle: '+14% vs last month',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _analyticsTile(
                  icon: Icons.recycling,
                  title: 'Recycling Rate',
                  value: '87%',
                  subtitle: 'Company-wide target 80%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _analyticsTile(
                  icon: Icons.inventory_2_outlined,
                  title: 'Materials In Stock',
                  value: '3,470 kg',
                  subtitle: '4 active batches',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _analyticsTile(
                  icon: Icons.payments_outlined,
                  title: 'Est. Revenue',
                  value: 'ETB 96,200',
                  subtitle: 'This month',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _analyticsTile({
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
              Icon(icon, color: AppColors.companyRole, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
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
            style:
                const TextStyle(fontSize: 10, color: AppColors.companyRole),
          ),
        ],
      ),
    );
  }
}

class _MaterialsCard extends StatelessWidget {
  final int totalKg;
  const _MaterialsCard({required this.totalKg});

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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Materials Processed',
                    style:
                        TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 4),
                Text('$totalKg kg',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                const Text('This month',
                    style:
                        TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.factory_outlined,
              size: 60, color: Colors.white24),
        ],
      ),
    );
  }
}

class _MaterialBatch {
  final String type;
  final String weight;
  final String source;
  final String quality;
  final String time;
  const _MaterialBatch({
    required this.type,
    required this.weight,
    required this.source,
    required this.quality,
    required this.time,
  });
}

class _Shipment {
  final String id;
  final String title;
  final String source;
  final String weight;
  final String time;
  String status;
  Color statusColor;
  _Shipment({
    required this.id,
    required this.title,
    required this.source,
    required this.weight,
    required this.time,
    required this.status,
    required this.statusColor,
  });
}
