import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/camera_detection_modal.dart';
import 'screens/statistics_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/auth_service.dart';
import 'services/user_data_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const NutrixApp());
}

class NutrixApp extends StatelessWidget {
  const NutrixApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    
    return MaterialApp(
      title: 'Nutrix',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          background: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'SF Pro Display',
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
        cardTheme: CardThemeData(
          color: AppColors.card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textWhite,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            textStyle: AppTextStyles.button,
          ),
        ),
      ),
      
      debugShowCheckedModeBanner: false,
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const NutrixHome(),
      },
    );
  }
}

class NutrixHome extends StatefulWidget {
  const NutrixHome({super.key});

  @override
  State<NutrixHome> createState() => _NutrixHomeState();
}
// Beranda utama aplikasi Nutrix
class _NutrixHomeState extends State<NutrixHome> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header with Gradient & Better Design
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppRadius.xxl),
                  bottomRight: Radius.circular(AppRadius.xxl),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nutrix',
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getGreeting(),
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textWhite.withOpacity(0.95),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        _selectedIndex == 1 
                            ? Icons.bar_chart_rounded 
                            : Icons.restaurant_menu_rounded,
                        color: AppColors.textWhite,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Main Content
            Expanded(
              child: _selectedIndex == 0 
                  ? _buildHomeContent() 
                  : _selectedIndex == 1 
                      ? const StatisticsScreen() 
                      : _buildProfileContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: AppShadow.medium,
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Statistik',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          backgroundColor: AppColors.card,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTextStyles.caption,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
  
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi! 🌅';
    } else if (hour < 17) {
      return 'Selamat Siang! ☀️';
    } else if (hour < 19) {
      return 'Selamat Sore! 🌤️';
    } else {
      return 'Selamat Malam! 🌙';
    }
  }

  Widget _buildHomeContent() {
    final authService = AuthService();
    final currentUser = authService.currentUser;
    final userDataService = UserDataService();
    
    // Get user data
    final userId = currentUser?.id ?? 'demo';
    final totalCalories = userDataService.getTotalCalories(userId);
    final targetCalories = userDataService.getCalorieTarget(userId);
    final remainingCalories = userDataService.getRemainingCalories(userId);
    final totalProtein = userDataService.getCalorieData(userId).totalProtein;
    final totalCarbs = userDataService.getCalorieData(userId).totalCarbs;
    final meals = userDataService.getMeals(userId);
    
    // Calculate progress
    final progress = targetCalories > 0 ? (totalCalories / targetCalories).clamp(0.0, 1.0) : 0.0;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.sm),
          // 🍃 Modern Calorie Counter Card with Fresh Green Gradient!
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 2,
              ),
            ],
            // Border tebal putih agar lebih mencolok!
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                'Kalori Hari Ini',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textWhite.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: totalCalories.toString(),
                      style: AppTextStyles.number.copyWith(
                        color: AppColors.textWhite,
                        fontSize: 56,
                      ),
                    ),
                    TextSpan(
                      text: ' / $targetCalories',
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.textWhite.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'kkal',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textWhite.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Modern Progress Bar
              Container(
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  color: AppColors.textWhite.withOpacity(0.2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      color: AppColors.textWhite,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textWhite.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Modern Macronutrients Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildModernMacroItem(
                    Icons.emoji_events_rounded,
                    remainingCalories.toString(), 
                    'Sisa', 
                    AppColors.textWhite,
                  ),
                  _buildModernMacroItem(
                    Icons.fitness_center_rounded,
                    '${totalProtein}g', 
                    'Protein', 
                    AppColors.textWhite,
                  ),
                  _buildModernMacroItem(
                    Icons.bakery_dining_rounded,
                    '${totalCarbs}g', 
                    'Karbo', 
                    AppColors.textWhite,
                  ),
                ],
              ),
            ],
          ),
        ),
        // Modern Add Food Button with GREEN GRADIENT
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient, // HIJAU GRADIEN!
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CameraDetectionModal(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.textWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.textWhite,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Tambah Makanan',
                  style: AppTextStyles.button.copyWith(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Meals List with Modern Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Makanan Hari Ini',
                    style: AppTextStyles.h3,
                  ),
                  if (meals.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          '${meals.length} item',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                meals.isEmpty 
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xl,
                          horizontal: AppSpacing.lg,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.restaurant_menu_rounded,
                                size: 48,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Belum ada makanan hari ini',
                              style: AppTextStyles.body1.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap "Tambah Makanan" untuk memulai',
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        final meal = meals[index];
                        return _buildMealItem(
                          meal.name,
                          meal.type,
                          meal.time,
                          '${meal.calories} kkal',
                        );
                      },
                    ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return const ProfileScreen();
  }

  Widget _buildModernMacroItem(
    IconData icon,
    String value,
    String label,
    Color textColor,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: textColor.withOpacity(0.8),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTextStyles.h3.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: textColor.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildMealItem(String name, String type, String time, String calories) {
    // Modern color mapping with new palette
    Color typeColor;
    IconData typeIcon;
    switch (type) {
      case 'Sarapan':
        typeColor = const Color(0xFFFF9F43); // Warm Orange
        typeIcon = Icons.wb_sunny_rounded;
        break;
      case 'Makan Siang':
        typeColor = AppColors.secondary; // Purple
        typeIcon = Icons.lunch_dining_rounded;
        break;
      case 'Makan Malam':
        typeColor = const Color(0xFF5F27CD); // Deep Purple
        typeIcon = Icons.dinner_dining_rounded;
        break;
      default:
        typeColor = AppColors.accent; // Yellow
        typeIcon = Icons.fastfood_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadow.small,
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Type Icon
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              typeIcon,
              color: typeColor,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Meal Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            typeColor,
                            typeColor.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        type,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Calories
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Column(
              children: [
                Text(
                  calories.split(' ')[0],
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'kkal',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
