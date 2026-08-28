import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:guardiano_advmobprog_longexam1/screens/splash_screen.dart';
import 'package:guardiano_advmobprog_longexam1/screens/home_screen.dart';
import 'package:guardiano_advmobprog_longexam1/screens/detail_screen.dart';
import 'package:guardiano_advmobprog_longexam1/screens/signin_screen.dart';
import 'package:guardiano_advmobprog_longexam1/screens/register_screen.dart';
import 'package:guardiano_advmobprog_longexam1/screens/profile_screen.dart';
import 'package:guardiano_advmobprog_longexam1/screens/settings_screen.dart';
import 'package:guardiano_advmobprog_longexam1/providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables (.env)
  await dotenv.load(fileName: 'assets/.env');

  runApp(const VibezFacebook());
}

class VibezFacebook extends StatelessWidget {
  const VibezFacebook({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide ThemeProvider to child widgets
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider()..loadTheme(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // ScreenUtil makes the UI responsive on all phone screens
          return ScreenUtilInit(
            designSize: const Size(412, 715),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return MaterialApp(
                color: Colors.white,
                debugShowCheckedModeBanner: false,
                title: 'Facebook Replication',
                // Theme toggles between dark and light
                themeMode: themeProvider.isDark
                    ? ThemeMode.dark
                    : ThemeMode.light,
                darkTheme: ThemeData.dark(),
                theme: ThemeData.light(),
                initialRoute: '/splash',
                // App screen routes
                routes: {
                  '/splash': (context) => const SplashScreen(),
                  '/home': (context) =>
                      const HomeScreen(profileName: 'Venz Ygnaz Guardiano'),
                  '/detail': (context) => const DetailScreen(
                    userName: 'Guest',
                    date: '2026-01-19',
                    postContent: 'Sample post content',
                  ),
                  '/login': (context) => const LogInScreen(),
                  '/register': (context) => const RegisterScreen(),
                  '/profile': (context) =>
                      const ProfileScreen(profileName: 'admin'),
                  '/settings': (context) => const SettingsScreen(),
                },
              );
            },
          );
        },
      ),
    );
  }
}
