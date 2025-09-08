import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/countdown_preview_widget.dart';
import './widgets/loading_indicator_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  String _loadingText = 'Başlatılıyor...';
  bool _showCountdown = false;
  bool _isInitialized = false;

  final List<String> _loadingSteps = [
    'Başlatılıyor...',
    'Veritabanı hazırlanıyor...',
    'Bildirimler ayarlanıyor...',
    'Kullanıcı tercihleri yükleniyor...',
    'Hazır!'
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialization();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _backgroundController.forward();
  }

  Future<void> _startInitialization() async {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.colorScheme.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    // Simulate initialization steps
    for (int i = 0; i < _loadingSteps.length; i++) {
      if (mounted) {
        setState(() {
          _loadingText = _loadingSteps[i];
        });
      }

      // Perform actual initialization tasks
      switch (i) {
        case 0:
          await _initializeCore();
          break;
        case 1:
          await _initializeDatabase();
          break;
        case 2:
          await _initializeNotifications();
          break;
        case 3:
          await _loadUserPreferences();
          break;
        case 4:
          await _finalizeInitialization();
          break;
      }

      await Future.delayed(const Duration(milliseconds: 600));
    }

    // Show countdown preview
    if (mounted) {
      setState(() {
        _showCountdown = true;
      });
    }

    // Wait for countdown animation
    await Future.delayed(const Duration(milliseconds: 1500));

    // Navigate to appropriate screen
    if (mounted) {
      _navigateToNextScreen();
    }
  }

  Future<void> _initializeCore() async {
    // Initialize core app services
    try {
      // Simulate core initialization
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      // Handle initialization error gracefully
      debugPrint('Core initialization error: $e');
    }
  }

  Future<void> _initializeDatabase() async {
    // Initialize SQLite database
    try {
      // Simulate database setup
      await Future.delayed(const Duration(milliseconds: 400));
    } catch (e) {
      // Handle database error gracefully
      debugPrint('Database initialization error: $e');
    }
  }

  Future<void> _initializeNotifications() async {
    // Initialize Firebase messaging and local notifications
    try {
      // Simulate notification setup
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      // Handle notification error gracefully
      debugPrint('Notification initialization error: $e');
    }
  }

  Future<void> _loadUserPreferences() async {
    // Load user preferences from shared preferences
    try {
      // Simulate preference loading
      await Future.delayed(const Duration(milliseconds: 200));

      // Check if user is first time or returning
      // This would normally check SharedPreferences
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      // Handle preference loading error gracefully
      debugPrint('User preferences loading error: $e');
      setState(() {
        _isInitialized = true; // Default to initialized
      });
    }
  }

  Future<void> _finalizeInitialization() async {
    // Finalize initialization process
    try {
      await Future.delayed(const Duration(milliseconds: 200));
    } catch (e) {
      // Handle finalization error gracefully
      debugPrint('Finalization error: $e');
    }
  }

  void _navigateToNextScreen() {
    // Navigate based on user status
    final String nextRoute =
        _isInitialized ? '/home-dashboard' : '/goal-setting';

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.colorScheme.primary,
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.8),
                  AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.6),
                ],
                stops: [
                  0.0,
                  0.5 + (_backgroundAnimation.value * 0.3),
                  1.0,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AnimatedLogoWidget(),
                          SizedBox(height: 4.h),
                          Text(
                            'YKS 2026 Başarı Yolculuğun',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Hedeflerine ulaşmak için buradayız',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_showCountdown) ...[
                    const CountdownPreviewWidget(),
                    SizedBox(height: 4.h),
                  ],
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingIndicatorWidget(
                          loadingText: _loadingText,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'StudyCoach v1.0',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
