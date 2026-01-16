
import 'package:flutter/material.dart';
import '../pages/schedule_page.dart';
import '../pages/profile.dart';
import '../pages/emergency_pickup.dart';
import '../pages/wallet.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecycleX',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const RecycleXHome(),
    );
  }
}

class RecycleXHome extends StatefulWidget {
  const RecycleXHome({super.key});

  @override
  State<RecycleXHome> createState() => _RecycleXHomeState();
}

class _RecycleXHomeState extends State<RecycleXHome> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top padding
            const SizedBox(height: 40),
            
            // Greeting
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Hello',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ),
            
            // App name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Welcome To RecycleX',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Menu items in a grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    _buildMenuItem('Schedule Pickup', Icons.calendar_today),
                    _buildMenuItem('Emergency Pickup', Icons.emergency),
                    _buildMenuItem('EcoCoins Wallet', Icons.wallet),
                    _buildMenuItem('Nearby Collectors', Icons.location_on),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green[700],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.green[200],
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          
          // Navigation logic
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SchedulePickupPage()));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EcoWalletPage()));
          } else if (index == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          }
        },
      ),
    );
  }

  // Function to build menu items with icons
  Widget _buildMenuItem(String text, IconData icon) {
    return GestureDetector(
      onTap: () {
        // Add navigation logic for each menu item
        if (text == 'Schedule Pickup') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SchedulePickupPage()));
        } else if (text == 'Emergency Pickup') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EmergencyPickupPage()));
        } else if (text == 'EcoCoins Wallet') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EcoWalletPage()));
        } else if (text == 'Nearby Collectors') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CollectorsPage()));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.green[100]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.green[700],
            ),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



