


import 'package:flutter/material.dart';
import '../services/language_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _pickupNotifications = true;
  bool _ecoCoinNotifications = true;
  bool _promotionNotifications = false;
  bool _newsletterNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _notificationTime = '09:00';

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(LanguageService.t('notifications')),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LanguageService.t('notificationSettings'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            
            SizedBox(height: 10),
            
            Text(
              LanguageService.t('notificationSettingsDesc'),
              style: TextStyle(color: Colors.grey[600]),
            ),
            
            SizedBox(height: 30),
            
            // Notification Types Section
            _buildSection(LanguageService.t('notificationTypes'), [
              _buildNotificationItem(
                title: LanguageService.t('pickupReminders'),
                subtitle: LanguageService.t('pickupRemindersDesc'),
                value: _pickupNotifications,
                onChanged: (value) => setState(() => _pickupNotifications = value),
              ),
              _buildNotificationItem(
                title: LanguageService.t('ecoCoinUpdates'),
                subtitle: LanguageService.t('ecoCoinUpdatesDesc'),
                value: _ecoCoinNotifications,
                onChanged: (value) => setState(() => _ecoCoinNotifications = value),
              ),
              _buildNotificationItem(
                title: LanguageService.t('promotions'),
                subtitle: LanguageService.t('promotionsDesc'),
                value: _promotionNotifications,
                onChanged: (value) => setState(() => _promotionNotifications = value),
              ),
              _buildNotificationItem(
                title: LanguageService.t('newsletter'),
                subtitle: LanguageService.t('newsletterDesc'),
                value: _newsletterNotifications,
                onChanged: (value) => setState(() => _newsletterNotifications = value),
              ),
            ]),
            
            SizedBox(height: 30),
            
            // Notification Preferences Section
            _buildSection(LanguageService.t('notificationPrefs'), [
              _buildNotificationItem(
                title: LanguageService.t('sound'),
                subtitle: LanguageService.t('soundDesc'),
                value: _soundEnabled,
                onChanged: (value) => setState(() => _soundEnabled = value),
              ),
              _buildNotificationItem(
                title: LanguageService.t('vibration'),
                subtitle: LanguageService.t('vibrationDesc'),
                value: _vibrationEnabled,
                onChanged: (value) => setState(() => _vibrationEnabled = value),
              ),
              ListTile(
                leading: Icon(Icons.access_time, color: Colors.green[700]),
                title: Text(LanguageService.t('dailyDigest')),
                subtitle: Text('${LanguageService.t('dailyDigestDesc')} $_notificationTime'),
                trailing: Text(_notificationTime, style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: _selectTime,
              ),
            ]),
            
            SizedBox(height: 30),
            
            // Test Notification Button
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.green[100]!),
              ),
              child: Column(
                children: [
                  Icon(Icons.notifications_active, size: 40, color: Colors.green[700]),
                  SizedBox(height: 12),
                  Text(
                    LanguageService.t('testNotification'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    LanguageService.t('testNotificationDesc'),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _sendTestNotification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(LanguageService.t('sendTest')),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 30),
            
            // Recent Notifications
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history, color: Colors.green[700]),
                      SizedBox(width: 10),
                      Text(
                        LanguageService.t('recentNotifications'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildNotificationHistoryItem(
                    LanguageService.t('pickupScheduled'),
                    LanguageService.t('pickupScheduledDesc'),
                    LanguageService.t('today'),
                    Icons.calendar_today,
                    Colors.blue,
                  ),
                  _buildNotificationHistoryItem(
                    LanguageService.t('ecoCoinsEarned'),
                    LanguageService.t('ecoCoinsEarnedDesc'),
                    LanguageService.t('yesterday'),
                    Icons.monetization_on,
                    Colors.green,
                  ),
                  _buildNotificationHistoryItem(
                    LanguageService.t('rewardAvailable'),
                    LanguageService.t('rewardAvailableDesc'),
                    LanguageService.t('jan12'),
                    Icons.card_giftcard,
                    Colors.orange,
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(LanguageService.t('clearAll')),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 30),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  LanguageService.t('saveSettings'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Reset Button
            TextButton(
              onPressed: _resetSettings,
              child: Text(LanguageService.t('resetSettings'), style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
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

  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(subtitle),
          trailing: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green[700],
          ),
        ),
        Divider(height: 0, indent: 16),
      ],
    );
  }

  Widget _buildNotificationHistoryItem(String title, String message, String time, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text(message, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                SizedBox(height: 4),
                Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        DateTime.parse('2024-01-01 $_notificationTime:00'),
      ),
    );
    if (picked != null) {
      setState(() {
        _notificationTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void _sendTestNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text(LanguageService.t('testSent')),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LanguageService.t('settingsSaved')),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LanguageService.t('resetSettings')),
        content: Text(LanguageService.t('resetConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LanguageService.t('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _pickupNotifications = true;
                _ecoCoinNotifications = true;
                _promotionNotifications = false;
                _newsletterNotifications = true;
                _soundEnabled = true;
                _vibrationEnabled = true;
                _notificationTime = '09:00';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(LanguageService.t('settingsReset'))),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(LanguageService.t('reset')),
          ),
        ],
      ),
    );
  }

}
