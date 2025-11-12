import 'package:flutter/material.dart';

/// Nutrix App Color Palette - Green Energy Theme 🍃
/// Fresh & Natural Design for Nutrition App
class AppColors {
  // Primary Colors - Fresh Green Theme
  static const Color primary = Color(0xFF11998E); // Deep Turquoise
  static const Color primaryLight = Color(0xFF38EF7D); // Bright Lime Green
  static const Color primaryDark = Color(0xFF0B6E63);
  
  // Secondary Colors - Sky Blue Theme
  static const Color secondary = Color(0xFF2E86DE); // Ocean Blue
  static const Color secondaryLight = Color(0xFF54A0FF); // Sky Blue
  static const Color secondaryDark = Color(0xFF1E5FAA);
  
  // Accent Colors - Vibrant Orange
  static const Color accent = Color(0xFFFFA502); // Bright Orange
  static const Color accentLight = Color(0xFFFFD32A);
  
  // Status Colors - Natural Theme
  static const Color success = Color(0xFF38EF7D); // Bright Green
  static const Color warning = Color(0xFFFFA502); // Orange
  static const Color danger = Color(0xFFFF6348); // Coral Red
  static const Color info = Color(0xFF54A0FF); // Sky Blue
  
  // Nutrition Colors - Fresh & Vibrant
  static const Color protein = Color(0xFFFF6348); // Coral Red
  static const Color carbs = Color(0xFFFFD32A); // Golden Yellow
  static const Color fat = Color(0xFF2E86DE); // Ocean Blue
  static const Color calories = Color(0xFF38EF7D); // Lime Green
  
  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFFDFE6E9);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFAFBFC);
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkCard = Color(0xFF2D2D2D);
  static const Color darkCardLight = Color(0xFF3A3A3A);
  static const Color darkSurface = Color(0xFF242424);
  static const Color darkBorder = Color(0xFF404040);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFFB2BEC3);
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Dark Theme Text Colors
  static const Color darkTextPrimary = Color(0xFFE8E8E8);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkTextLight = Color(0xFF808080);
  
  // Fresh & Natural Gradient Colors 🍃
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF11998E), Color(0xFF38EF7D)], // Turquoise to Lime Green
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF2E86DE), Color(0xFF54A0FF)], // Ocean to Sky Blue
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFFA502), Color(0xFFFFD32A)], // Orange to Yellow
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Alternative Natural Gradients
  static const LinearGradient forestGradient = LinearGradient(
    colors: [Color(0xFF134E5E), Color(0xFF71B280)], // Deep Green to Light Green
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFFA502), Color(0xFFFF6348)], // Orange to Coral
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// App Text Styles
class AppTextStyles {
  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  // Body Text
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  
  // Caption & Small
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );
  
  static const TextStyle small = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: AppColors.textLight,
    height: 1.4,
  );
  
  // Button Text
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    letterSpacing: 0.5,
  );
  
  // Special
  static const TextStyle number = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    height: 1,
  );
}

/// App Spacing & Sizing
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double full = 999;
}

class AppShadow {
  static List<BoxShadow> small = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> large = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}
