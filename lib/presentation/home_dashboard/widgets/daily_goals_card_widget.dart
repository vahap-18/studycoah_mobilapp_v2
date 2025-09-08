import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DailyGoalsCardWidget extends StatelessWidget {
  final int studyHoursGoal;
  final int studyHoursCompleted;
  final int questionsGoal;
  final int questionsCompleted;
  final int practiceExamsGoal;
  final int practiceExamsCompleted;
  final VoidCallback? onEditGoals;

  const DailyGoalsCardWidget({
    Key? key,
    this.studyHoursGoal = 6,
    this.studyHoursCompleted = 3,
    this.questionsGoal = 50,
    this.questionsCompleted = 32,
    this.practiceExamsGoal = 2,
    this.practiceExamsCompleted = 1,
    this.onEditGoals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Günlük Hedeflerim',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: onEditGoals,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'edit',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildGoalItem(
            icon: 'schedule',
            title: 'Çalışma Saati',
            completed: studyHoursCompleted,
            goal: studyHoursGoal,
            unit: 'saat',
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          _buildGoalItem(
            icon: 'quiz',
            title: 'Soru Çözümü',
            completed: questionsCompleted,
            goal: questionsGoal,
            unit: 'soru',
            color: AppTheme.lightTheme.colorScheme.secondary,
          ),
          SizedBox(height: 2.h),
          _buildGoalItem(
            icon: 'assignment',
            title: 'Deneme Sınavı',
            completed: practiceExamsCompleted,
            goal: practiceExamsGoal,
            unit: 'deneme',
            color: AppTheme.lightTheme.colorScheme.tertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem({
    required String icon,
    required String title,
    required int completed,
    required int goal,
    required String unit,
    required Color color,
  }) {
    final progress = completed / goal;
    final isCompleted = completed >= goal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: color,
                size: 5.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '$completed / $goal $unit',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.1)
                    : color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCompleted)
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 4.w,
                    ),
                  if (isCompleted) SizedBox(width: 1.w),
                  Text(
                    isCompleted ? 'Tamamlandı' : '${(progress * 100).toInt()}%',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: isCompleted
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: progress > 1.0 ? 1.0 : progress,
          backgroundColor: color.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(
            isCompleted ? AppTheme.lightTheme.colorScheme.tertiary : color,
          ),
        ),
      ],
    );
  }
}
