import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CountdownPreviewWidget extends StatefulWidget {
  const CountdownPreviewWidget({super.key});

  @override
  State<CountdownPreviewWidget> createState() => _CountdownPreviewWidgetState();
}

class _CountdownPreviewWidgetState extends State<CountdownPreviewWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start animation after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  DateTime get yksDate => DateTime(2026, 6, 15); // YKS 2026 exam date

  String get timeRemaining {
    final now = DateTime.now();
    final difference = yksDate.difference(now);

    if (difference.isNegative) {
      return "YKS 2026 Başladı!";
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;

    return "$days gün $hours saat";
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  child: Lottie.asset(
                    'assets/animations/countdown.json',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return CustomIconWidget(
                        iconName: 'timer',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 6.w,
                      );
                    },
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  'YKS 2026',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              timeRemaining,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
