import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          LanguageService.t("profile"),
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// PROFILE IMAGE
            Stack(
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundImage:
                      AssetImage("assets/profile.jpg"),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.edit,
                        size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            const Text(
              "Alex Johnson",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 231, 229, 227),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(LanguageService.t("level")),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                _statCard("42kg",
                    LanguageService.t("recycled")),
                const SizedBox(width: 10),
                _statCard("12",
                    LanguageService.t("pickups")),
              ],
            ),

            const SizedBox(height: 30),

            _section("ACCOUNT"),
            _tile(Icons.edit, LanguageService.t("editProfile")),
            _tile(Icons.credit_card, LanguageService.t("payment")),

            const SizedBox(height: 20),

            _section("APP"),
            _tile(Icons.notifications,
                LanguageService.t("notifications")),

            /// LANGUAGE SWITCH
            _languageTile(),

            const SizedBox(height: 20),

            _section("SUPPORT"),
            _tile(Icons.help_outline,
                LanguageService.t("help")),

            const SizedBox(height: 30),

            TextButton.icon(
              onPressed: () {
                // FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout),
              label: Text(LanguageService.t("logout")),
            ),
          ],
        ),
      ),
       
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: Colors.green[700],
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "Schedule"),
          BottomNavigationBarItem(
              icon: Icon(Icons.wallet), label: "Wallet"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      
    );
  }

  /// HELPERS 👇

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE6E1D6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(title,
            style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _tile(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE6E1D6),
          child: Icon(icon, color: Colors.green[700]),
        ),
        title: Text(title),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }

  Widget _languageTile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: const Icon(Icons.language),
        title: Text(LanguageService.t("language")),
        trailing: Switch(
          value: LanguageService.languageNotifier.value == "am",
          onChanged: (value) {
            LanguageService.toggleLanguage();
          },
        ),
      ),
    );
    
  }

  
}
