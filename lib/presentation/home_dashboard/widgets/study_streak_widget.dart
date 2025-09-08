import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StudyStreakWidget extends StatelessWidget {
  final int currentStreak;
  final int bestStreak;
  final List<bool> weeklyProgress;
  final VoidCallback? onTap;

  const StudyStreakWidget({
    Key? key,
    this.currentStreak = 5,
    this.bestStreak = 12,
    this.weeklyProgress = const [true, true, false, true, true, true, false],
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.5.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFF6B35),
                            const Color(0xFFFF8E53),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '🔥',
                        style: TextStyle(fontSize: 5.w),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Çalışma Serisi',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$currentStreak gün üst üste',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'En İyi',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '$bestStreak gün',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              'Bu Hafta',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz']
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;
                final day = entry.value;
                final isCompleted = index < weeklyProgress.length
                    ? weeklyProgress[index]
                    : false;
                final isToday = index == DateTime.now().weekday - 1;

                return Column(
                  children: [
                    Text(
                      day,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isToday
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? AppTheme.lightTheme.colorScheme.tertiary
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                        border: isToday
                            ? Border.all(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                width: 2,
                              )
                            : null,
                      ),
                      child: isCompleted
                          ? Center(
                              child: CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 4.w,
                              ),
                            )
                          : null,
                    ),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'emoji_events',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    currentStreak >= 7
                        ? 'Harika! Bir hafta tamamladın!'
                        : '${7 - currentStreak} gün daha, bir hafta tamamla!',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
