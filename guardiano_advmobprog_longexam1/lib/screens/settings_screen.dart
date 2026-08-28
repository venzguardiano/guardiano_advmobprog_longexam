import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../providers/theme_provider.dart';
import '../services/user_service.dart';
import '../widgets/custom_font.dart';

// Settings screen with light/dark theme toggle and working sign out
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _isLoading = true;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _isLoading = false;
    });
  }

  Future<void> _updateNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    setState(() => _notificationsEnabled = value);
  }

  Future<void> _updateDarkMode(bool value) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    await themeProvider.toggleTheme();
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Wipe saved session in SharedPreferences
    await _userService.logout();

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDark;

    final bgColor = isDark ? VZ_PRIMARY_DARK : Colors.grey[100];
    final cardBg = isDark ? VZ_CARD_DARK : Colors.white;
    final textColor = isDark ? VZ_TEXT_WHITE : Colors.black87;
    final subTextColor = isDark ? VZ_TEXT_GRAY : Colors.grey[600]!;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: bgColor,
        body: const Center(
          child: CircularProgressIndicator(color: VZ_NEON_BLUE),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 1,
        iconTheme: IconThemeData(color: textColor),
        title: CustomFont(
          text: 'Settings',
          fontSize: 18,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(20),
          vertical: ScreenUtil().setHeight(10),
        ),
        children: [
          CustomFont(
            text: 'Preferences',
            fontSize: 14,
            color: subTextColor,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          _buildSwitchTile(
            title: 'Dark Mode',
            subtitle: 'Use dark theme throughout the app',
            icon: Icons.dark_mode,
            value: isDark,
            onChanged: _updateDarkMode,
            cardBg: cardBg,
            textColor: textColor,
            subTextColor: subTextColor,
          ),
          _buildSwitchTile(
            title: 'Notifications',
            subtitle: 'Receive alerts for likes and comments',
            icon: Icons.notifications,
            value: _notificationsEnabled,
            onChanged: _updateNotifications,
            cardBg: cardBg,
            textColor: textColor,
            subTextColor: subTextColor,
          ),
          SizedBox(height: ScreenUtil().setHeight(30)),
          CustomFont(
            text: 'Account',
            fontSize: 14,
            color: subTextColor,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: _signOut,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color cardBg,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SwitchListTile(
        activeColor: VZ_NEON_BLUE,
        secondary: Icon(icon, color: textColor),
        title: Text(title, style: TextStyle(color: textColor)),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: subTextColor, fontSize: 12),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
