import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/theme_provider.dart';
import '../services/user_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_font.dart';
import 'home_screen.dart';

// Displays sign in form screen with dynamic light and dark theme support.
class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  // Input controllers for reading username and password values.
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserService _userService = UserService();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    // Disposes text editing controllers when screen is removed.
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Sends authentication request to login user and navigate to home screen.
  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both username and password.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _userService.login(username, password);

      if (!mounted) return;

      // Opens home screen upon successful user login.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            profileName: user.fullName,
            userId: user.id,
            profileImage: user.image,
          ),
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credentials or authentication error.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Configures UI colors based on active light or dark theme mode.
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final bgColor = isDark ? VZ_PRIMARY_DARK : Colors.grey[100];
    final cardBg = isDark ? VZ_CARD_DARK : Colors.white;
    final textColor = isDark ? VZ_TEXT_WHITE : Colors.black87;
    final subTextColor = isDark ? VZ_TEXT_GRAY : Colors.grey[600]!;

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Renders Vibez letter V logo avatar.
              CircleAvatar(
                radius: 36.r,
                backgroundColor: VZ_NEON_BLUE,
                child: CustomFont(
                  text: 'V',
                  fontSize: 42.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12.h),
              // Renders main app title text.
              CustomFont(
                text: 'Vibez',
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: VZ_NEON_BLUE,
              ),
              SizedBox(height: 6.h),
              Text(
                'Connect with friends and the world around you.',
                textAlign: TextAlign.center,
                style: TextStyle(color: subTextColor, fontSize: 13.sp),
              ),
              SizedBox(height: 30.h),

              // Card container for login input fields.
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Column(
                  children: [
                    // Text field for username input.
                    TextField(
                      controller: _usernameController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: subTextColor),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: VZ_NEON_BLUE,
                        ),
                        filled: true,
                        fillColor: isDark ? Colors.grey[900] : Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Text field for password input.
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: subTextColor),
                        prefixIcon: const Icon(Icons.lock, color: VZ_NEON_BLUE),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: subTextColor,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        filled: true,
                        fillColor: isDark ? Colors.grey[900] : Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Button triggering sign in action.
                    _isLoading
                        ? const CircularProgressIndicator(color: VZ_NEON_BLUE)
                        : CustomButton(
                            buttonName: 'Log In',
                            onPressed: _handleLogin,
                            buttonType: 'elevated',
                            fontColor: Colors.white,
                            backgroundColor: VZ_NEON_BLUE,
                          ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Button navigating to user registration screen.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: subTextColor),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: VZ_NEON_BLUE,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
