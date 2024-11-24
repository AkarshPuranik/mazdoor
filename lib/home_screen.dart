import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isWorkMode = false; // Initial state of the toggle switch
  int _selectedIndex = 0; // BottomNavigationBar selected index

  bool get isWithinRestrictedHours {
    final now = TimeOfDay.now();
    final startRestriction = TimeOfDay(hour: 19, minute: 0); // 7 PM
    final endRestriction = TimeOfDay(hour: 9, minute: 0); // 9 AM
    return now.hour >= startRestriction.hour || now.hour < endRestriction.hour;
  }

  @override
  void initState() {
    super.initState();
    if (isWithinRestrictedHours) {
      isWorkMode = false; // Ensure it stays off if within restricted hours
    }
  }

  void _navigateTo(String route) {
    switch (route) {
      case 'settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsScreen()),
        );
        break;
      case 'about':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutScreen()),
        );
        break;
      case 'profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileSettingsScreen()),
        );
        break;
    }
  }

  void _onBottomNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return _buildHomeContent();
      case 1:
        return Center(
            child: Text('Services Screen', style: TextStyle(fontSize: 18)));
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Work Mode',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedToggleSwitch<bool>.dual(
            animationDuration: Durations.extralong4,
            current: isWorkMode,
            first: false,
            second: true,
            spacing: 80.0, // Increase the toggle's width
            height: 70.0, // Make the toggle larger
            borderWidth: 3.0, // Add border for better visibility
            onChanged: isWithinRestrictedHours
                ? null // Disable the toggle during restricted hours
                : (value) {
                    setState(() {
                      isWorkMode = value;
                    });
                  },
            styleBuilder: (b) => ToggleStyle(
                indicatorColor: b ? Colors.green : Colors.red,
                backgroundColor: b ? Colors.green : Colors.red),
            iconBuilder: (value) => value
                ? Icon(Icons.check_circle, color: Colors.white, size: 30)
                : Icon(Icons.cancel, color: Colors.white, size: 30),
            textBuilder: (value) => value
                ? Center(
                    child: Text(
                      "I'm ready to work",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : Center(
                    child: Text(
                      "I can't work today",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
        ),
        if (isWithinRestrictedHours)
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              'Work mode cannot be enabled \nbetween 7 PM and 9 AM',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  _navigateTo('profile');
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150'), // Placeholder image
                ),
              ),
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _navigateTo('settings');
              },
            ),
            ListTile(
              title: Text('About'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _navigateTo('about');
              },
            ),
          ],
        ),
      ),
      body: _getScreenForIndex(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.miscellaneous_services),
            label: 'Services',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onBottomNavItemTapped,
      ),
    );
  }
}

// Placeholder for Settings Screen
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Text('Settings Screen'),
      ),
    );
  }
}

// Placeholder for About Screen
class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Text('About Screen'),
      ),
    );
  }
}

// Placeholder for Profile Settings Screen
class ProfileSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
      ),
      body: Center(
        child: Text('Profile Settings Screen'),
      ),
    );
  }
}
