import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2B24),
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF1E2B24),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          NotificationCard(
            title: 'Pickup Scheduled',
            message: 'Your waste pickup is confirmed.',
            icon: Icons.check_circle,
          ),
          NotificationCard(
            title: 'Reminder',
            message: 'Your pickup is scheduled for tomorrow.',
            icon: Icons.notifications_active,
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2C3E34),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFD4AF37)),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          message,
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
