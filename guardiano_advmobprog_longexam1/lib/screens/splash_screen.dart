import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/theme_provider.dart';
import '../widgets/custom_font.dart';
import 'signin_screen.dart';

// Displays initial splash branding screen before navigating to sign in.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigates automatically to the sign in screen after a 3-second delay.
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LogInScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Reads theme state to switch background color between light and dark modes.
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final bgColor = isDark ? VZ_PRIMARY_DARK : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Renders circular logo with Vibez letter V avatar.
            CircleAvatar(
              radius: 40.r,
              backgroundColor: VZ_NEON_BLUE,
              child: CustomFont(
                text: 'V',
                fontSize: 48.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
            // Displays app title branding text.
            CustomFont(
              text: 'Vibez',
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: VZ_NEON_BLUE,
            ),
          ],
        ),
      ),
    );
  }
}
