import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback? onStartStudy;
  final VoidCallback? onSetGoals;
  final VoidCallback? onViewProgress;

  const QuickActionsWidget({
    Key? key,
    this.onStartStudy,
    this.onSetGoals,
    this.onViewProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hızlı İşlemler',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          // Primary action button
          GestureDetector(
            onTap: onStartStudy,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 3.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary,
                    AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'play_arrow',
                    color: Colors.white,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Çalışma Seansı Başlat',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          // Secondary action buttons
          Row(
            children: [
              Expanded(
                child: _buildSecondaryButton(
                  icon: 'flag',
                  title: 'Hedef Belirle',
                  onTap: onSetGoals,
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildSecondaryButton(
                  icon: 'analytics',
                  title: 'İlerleme Görüntüle',
                  onTap: onViewProgress,
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String icon,
    required String title,
    required VoidCallback? onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: Colors.white,
                size: 5.w,
              ),
            ),
            SizedBox(height: 1.5.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
