import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UserAvatarWidget extends StatelessWidget {
  final int currentLevel;
  final int currentXP;
  final int xpToNextLevel;
  final VoidCallback? onTap;

  const UserAvatarWidget({
    Key? key,
    this.currentLevel = 1,
    this.currentXP = 150,
    this.xpToNextLevel = 300,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progressPercentage = currentXP / xpToNextLevel;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Progress ring
                SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: CircularProgressIndicator(
                    value: progressPercentage,
                    strokeWidth: 3,
                    backgroundColor: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.tertiary,
                    ),
                  ),
                ),
                // Avatar
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.lightTheme.colorScheme.primary,
                        AppTheme.lightTheme.colorScheme.secondary,
                      ],
                    ),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'person',
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                ),
                // Level badge
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 5.w,
                    height: 5.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        currentLevel.toString(),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 8.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seviye $currentLevel Öğrenci',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '$currentXP / $xpToNextLevel XP',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  LinearProgressIndicator(
                    value: progressPercentage,
                    backgroundColor: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }
}
