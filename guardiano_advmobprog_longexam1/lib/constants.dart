import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Fallback host ensures it never evaluates to null if dotenv load is delayed
String get host => dotenv.env['HOST'] ?? 'https://dummyjson.com';

// DARK MODE PALETTE FOR VIBEZ APP
const Color VZ_PRIMARY_DARK = Color(0xFF0D0D0D); // App background
const Color VZ_CARD_DARK = Color(0xFF1A1A1A); // Card backgrounds
const Color VZ_NEON_BLUE = Color(0xFF4CC9F0); // Main accent color
const Color VZ_TEXT_WHITE = Color(0xFFF5F5F5); // Primary text
const Color VZ_TEXT_GRAY = Color(0xFFA1A1A1); // Secondary text
