import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BreakReminderWidget extends StatelessWidget {
  final Duration remainingTime;
  final VoidCallback onSkipBreak;

  const BreakReminderWidget({
    super.key,
    required this.remainingTime,
    required this.onSkipBreak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // Break icon with animation placeholder
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.2),
            ),
            child: CustomIconWidget(
              iconName: 'self_improvement',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 8.w,
            ),
          ),

          SizedBox(height: 2.h),

          // Break title
          Text(
            'Mola Zamanı!',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 1.h),

          // Break suggestions
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Önerilen aktiviteler:',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                _buildSuggestionItem('💧', 'Su iç'),
                _buildSuggestionItem('🧘‍♂️', 'Derin nefes al'),
                _buildSuggestionItem('👀', 'Gözlerini dinlendir'),
                _buildSuggestionItem('🚶‍♂️', 'Kısa yürüyüş yap'),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Skip break button
          TextButton(
            onPressed: onSkipBreak,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Molayı Geç',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName: 'skip_next',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 4.w,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(String emoji, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: 16.sp),
          ),
          SizedBox(width: 3.w),
          Text(
            text,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
