import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PerformanceOverviewWidget extends StatelessWidget {
  final Map<String, dynamic> overviewData;

  const PerformanceOverviewWidget({
    Key? key,
    required this.overviewData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final overallAverage =
        (overviewData['overallAverage'] as num?)?.toDouble() ?? 0.0;
    final targetAverage =
        (overviewData['targetAverage'] as num?)?.toDouble() ?? 85.0;
    final trend = overviewData['trend'] as String? ?? 'stable';
    final totalExams = (overviewData['totalExams'] as num?)?.toInt() ?? 0;
    final lastExamDate = overviewData['lastExamDate'] as DateTime?;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Genel Performans',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getTrendColor(trend).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: _getTrendIcon(trend),
                      color: _getTrendColor(trend),
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      _getTrendText(trend),
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: _getTrendColor(trend),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Genel Ortalama',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${overallAverage.toStringAsFixed(1)}',
                      style:
                          AppTheme.lightTheme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Hedef: ${targetAverage.toStringAsFixed(0)}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    SizedBox(
                      width: 25.w,
                      height: 25.w,
                      child: Stack(
                        children: [
                          CircularProgressIndicator(
                            value: 1.0,
                            strokeWidth: 8,
                            backgroundColor: AppTheme
                                .lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          CircularProgressIndicator(
                            value: overallAverage / 100,
                            strokeWidth: 8,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getProgressColor(overallAverage / 100),
                            ),
                          ),
                          Center(
                            child: Text(
                              '${(overallAverage).toStringAsFixed(0)}%',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Toplam Sınav',
                totalExams.toString(),
                'quiz',
                AppTheme.lightTheme.colorScheme.tertiary,
              ),
              Container(
                width: 1,
                height: 6.h,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
              _buildStatItem(
                'Son Sınav',
                lastExamDate != null
                    ? '${DateTime.now().difference(lastExamDate).inDays} gün önce'
                    : 'Henüz yok',
                'schedule',
                AppTheme.lightTheme.colorScheme.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, String iconName, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'improving':
        return AppTheme.getSuccessColor(true);
      case 'declining':
        return AppTheme.getErrorColor(true);
      default:
        return AppTheme.getWarningColor(true);
    }
  }

  String _getTrendIcon(String trend) {
    switch (trend) {
      case 'improving':
        return 'trending_up';
      case 'declining':
        return 'trending_down';
      default:
        return 'trending_flat';
    }
  }

  String _getTrendText(String trend) {
    switch (trend) {
      case 'improving':
        return 'Yükseliş Trendinde';
      case 'declining':
        return 'Düşüş Trendinde';
      default:
        return 'Sabit Performans';
    }
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.8) {
      return AppTheme.getSuccessColor(true);
    } else if (progress >= 0.6) {
      return AppTheme.getWarningColor(true);
    } else {
      return AppTheme.getErrorColor(true);
    }
  }
}
