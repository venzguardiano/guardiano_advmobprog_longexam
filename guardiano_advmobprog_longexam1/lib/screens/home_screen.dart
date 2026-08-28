import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/theme_provider.dart';
import '../screens/newsfeed_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/custom_font.dart';

// HomeScreen managing active bottom navigation tab views.
class HomeScreen extends StatefulWidget {
  final String profileName;
  final int userId;
  final String profileImage;

  const HomeScreen({
    super.key,
    required this.profileName,
    this.userId = 1,
    this.profileImage = '',
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Tracks active tab index

  @override
  Widget build(BuildContext context) {
    // Retrieves theme preferences for dynamic app bar and background colors.
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final bgColor = isDark ? VZ_PRIMARY_DARK : Colors.grey[100];
    final appBarBg = isDark ? VZ_CARD_DARK : Colors.white;
    final iconColor = isDark ? VZ_TEXT_WHITE : Colors.black87;

    final List<String> titles = ['Vibez', 'Notifications', widget.profileName];

    // Array containing active screen widgets to avoid layout overflow bugs.
    final List<Widget> screens = [
      const NewsFeedScreen(),
      const NotificationScreen(),
      ProfileScreen(
        profileName: widget.profileName,
        userId: widget.userId,
        profileImage: widget.profileImage,
      ),
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: isDark ? 3 : 1,
        shadowColor: VZ_NEON_BLUE.withOpacity(0.3),
        title: CustomFont(
          key: ValueKey(titles[_selectedIndex]),
          text: titles[_selectedIndex],
          fontSize: 25.sp,
          color: VZ_NEON_BLUE,
          fontFamily: 'Roboto',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: iconColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      // Renders active body directly to give child list views clear layout bounds.
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: appBarBg,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: VZ_NEON_BLUE,
        unselectedItemColor: isDark ? VZ_TEXT_GRAY : Colors.grey[600],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
