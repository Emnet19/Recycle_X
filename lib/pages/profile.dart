
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/login.dart';
import '../services/language_service.dart';
import 'edit_profile.dart';
import 'notifications_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  String _userName = 'Alex Johnson';
  String _userEmail = 'user@example.com';
  String _userLevel = 'Eco Champion';
  int _totalRecycled = 42;
  int _totalPickups = 12;
  int _ecoCoins = 1250;
  String _profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Listen to language changes
    LanguageService.languageNotifier.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    LanguageService.languageNotifier.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          _userName = doc.data()?['name'] ?? user.displayName ?? 'User';
          _userEmail = user.email ?? 'user@example.com';
          _userLevel = doc.data()?['userLevel'] ?? LanguageService.t('level');
          _totalRecycled = (doc.data()?['totalRecycled'] ?? 0).toInt();
          _totalPickups = (doc.data()?['totalPickups'] ?? 0).toInt();
          _ecoCoins = (doc.data()?['ecoCoins'] ?? 0).toInt();
          _profileImageUrl = doc.data()?['profileImageUrl'] ?? '';
        });
      }
    }
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LanguageService.t('logout')),
        content: Text(LanguageService.t('confirmLogout')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LanguageService.t('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _auth.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => RecycleLoginPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(LanguageService.t('logout')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.green[700]!, Colors.green[500]!],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: _profileImageUrl.isNotEmpty
                                ? CircleAvatar(
                                    radius: 48,
                                    backgroundImage: NetworkImage(_profileImageUrl),
                                  )
                                : CircleAvatar(
                                    radius: 48,
                                    backgroundColor: Colors.green[100],
                                    child: Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.green[700],
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _navigateToEditProfile(),
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Icon(Icons.edit, color: Colors.green[700], size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        _userName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _userEmail,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Stats and Settings
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Stats Cards
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green[100]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(LanguageService.t('totalRecycled'), '${_totalRecycled}kg', Icons.recycling),
                        Container(height: 40, width: 1, color: Colors.green[200]),
                        _buildStatItem(LanguageService.t('pickups'), '$_totalPickups', Icons.local_shipping),
                        Container(height: 40, width: 1, color: Colors.green[200]),
                        _buildStatItem(LanguageService.t('ecoCoins'), '$_ecoCoins', Icons.monetization_on),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // User Level Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green[700]!, Colors.green[500]!],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.emoji_events, color: Colors.white, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userLevel,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                LanguageService.t('keepRecycling'),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Account Section
                  _buildSection(LanguageService.t('account'), [
                    _buildSettingItem(
                      icon: Icons.edit_note,
                      title: LanguageService.t('editProfile'),
                      subtitle: 'Update your personal information',
                      onTap: () => _navigateToEditProfile(),
                    ),
                    _buildSettingItem(
                      icon: Icons.security,
                      title: LanguageService.t('privacySecurity'),
                      subtitle: 'Manage your account security',
                      onTap: () {},
                    ),
                  ]),

                  SizedBox(height: 30),

                  // App Settings Section
                  _buildSection(LanguageService.t('appSettings'), [
                    _buildSettingItem(
                      icon: Icons.notifications,
                      title: LanguageService.t('notifications'),
                      subtitle: 'Manage notification preferences',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage())),
                    ),
                    _buildSettingItem(
                      icon: Icons.language,
                      title: LanguageService.t('language'),
                      subtitle: LanguageService.languageNotifier.value == 'en' ? 'English' : 'አማርኛ',
                      trailing: Switch(
                        value: LanguageService.languageNotifier.value == 'am',
                        onChanged: (value) {
                          LanguageService.toggleLanguage();
                        },
                      ),
                    ),
                    _buildSettingItem(
                      icon: Icons.dark_mode,
                      title: LanguageService.t('darkMode'),
                      subtitle: 'Switch between themes',
                      trailing: Switch(value: false, onChanged: (value) {}),
                    ),
                  ]),

                  SizedBox(height: 40),

                  // Logout Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.red[100]!),
                    ),
                    child: TextButton.icon(
                      onPressed: _logout,
                      icon: Icon(Icons.logout, color: Colors.red),
                      label: Text(
                        LanguageService.t('logout'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Delete Account (Danger Zone)
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(LanguageService.t('deleteAccount')),
                          content: Text(LanguageService.t('deleteWarning')),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(LanguageService.t('cancel')),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: Text(LanguageService.t('deleteAccount')),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      LanguageService.t('deleteAccount'),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.green[700], size: 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.green[700]),
          ),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(subtitle),
          trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        if (onTap != null) Divider(height: 0, indent: 72),
      ],
    );
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage()),
    ).then((_) => _loadUserData());
  }
}
