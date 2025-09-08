import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeakSubjectsAnalysisWidget extends StatelessWidget {
  final List<Map<String, dynamic>> weakSubjects;
  final Function(String) onSubjectTap;

  const WeakSubjectsAnalysisWidget({
    Key? key,
    required this.weakSubjects,
    required this.onSubjectTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (weakSubjects.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.getSuccessColor(true).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'emoji_events',
              color: AppTheme.getSuccessColor(true),
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'Harika! Tüm Dersleriniz İyi Durumda',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.getSuccessColor(true),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Şu anda hiçbir dersinizde zayıflık tespit edilmedi. Bu performansınızı sürdürün!',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'trending_down',
                color: AppTheme.getErrorColor(true),
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Geliştirilmesi Gereken Dersler',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: weakSubjects.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final subject = weakSubjects[index];
              return _buildWeakSubjectCard(subject);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeakSubjectCard(Map<String, dynamic> subject) {
    final subjectName = subject['name'] as String? ?? 'Bilinmeyen Ders';
    final currentScore = (subject['currentScore'] as num?)?.toDouble() ?? 0.0;
    final targetScore = (subject['targetScore'] as num?)?.toDouble() ?? 85.0;
    final recommendations =
        (subject['recommendations'] as List?)?.cast<String>() ?? [];
    final priority = subject['priority'] as String? ?? 'medium';

    return GestureDetector(
      onTap: () => onSubjectTap(subjectName),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getPriorityColor(priority).withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    subjectName,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(priority).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getPriorityText(priority),
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: _getPriorityColor(priority),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mevcut Ortalama',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${currentScore.toStringAsFixed(1)}',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.getErrorColor(true),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hedef',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${targetScore.toStringAsFixed(0)}',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fark',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${(targetScore - currentScore).toStringAsFixed(1)}',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.getWarningColor(true),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            LinearProgressIndicator(
              value: currentScore / targetScore,
              backgroundColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              valueColor:
                  AlwaysStoppedAnimation<Color>(_getPriorityColor(priority)),
              minHeight: 6,
            ),
            if (recommendations.isNotEmpty) ...[
              SizedBox(height: 2.h),
              Text(
                'Öneriler:',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              ...recommendations.take(2).map((recommendation) => Padding(
                    padding: EdgeInsets.only(bottom: 0.5.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 0.5.h, right: 2.w),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            recommendation,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => onSubjectTap(subjectName),
                  icon: CustomIconWidget(
                    iconName: 'arrow_forward',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  label: Text(
                    'Detaylı İncele',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return AppTheme.getErrorColor(true);
      case 'medium':
        return AppTheme.getWarningColor(true);
      case 'low':
        return AppTheme.lightTheme.colorScheme.primary;
      default:
        return AppTheme.getWarningColor(true);
    }
  }

  String _getPriorityText(String priority) {
    switch (priority) {
      case 'high':
        return 'Yüksek Öncelik';
      case 'medium':
        return 'Orta Öncelik';
      case 'low':
        return 'Düşük Öncelik';
      default:
        return 'Orta Öncelik';
    }
  }
}
