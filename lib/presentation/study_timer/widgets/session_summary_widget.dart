import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SessionSummaryWidget extends StatelessWidget {
  final int completedSessions;
  final Duration totalStudyTime;
  final int goalProgress;
  final VoidCallback onContinue;
  final VoidCallback onFinish;

  const SessionSummaryWidget({
    super.key,
    required this.completedSessions,
    required this.totalStudyTime,
    required this.goalProgress,
    required this.onContinue,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Success icon
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.2),
            ),
            child: CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 10.w,
            ),
          ),

          SizedBox(height: 2.h),

          // Congratulations text
          Text(
            'Tebrikler!',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 1.h),

          Text(
            'Çalışma seansını başarıyla tamamladın',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 3.h),

          // Session statistics
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildStatItem(
                  'Tamamlanan Seans',
                  '$completedSessions',
                  'timer',
                  AppTheme.lightTheme.colorScheme.primary,
                ),
                SizedBox(height: 2.h),
                _buildStatItem(
                  'Toplam Çalışma',
                  _formatDuration(totalStudyTime),
                  'schedule',
                  AppTheme.lightTheme.colorScheme.secondary,
                ),
                SizedBox(height: 2.h),
                _buildStatItem(
                  'Günlük Hedef',
                  '%$goalProgress',
                  'trending_up',
                  AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onContinue,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Devam Et',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: onFinish,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Bitir',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, String iconName, Color color) {
    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.2),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 5.w,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}s ${minutes}dk';
    } else {
      return '${minutes}dk';
    }
  }
}
