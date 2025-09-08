import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeeklyGoalsSection extends StatefulWidget {
  final Map<String, dynamic> weeklyGoals;
  final Function(Map<String, dynamic>) onGoalsChanged;

  const WeeklyGoalsSection({
    Key? key,
    required this.weeklyGoals,
    required this.onGoalsChanged,
  }) : super(key: key);

  @override
  State<WeeklyGoalsSection> createState() => _WeeklyGoalsSectionState();
}

class _WeeklyGoalsSectionState extends State<WeeklyGoalsSection> {
  late Map<String, dynamic> _currentGoals;

  @override
  void initState() {
    super.initState();
    _currentGoals = Map<String, dynamic>.from(widget.weeklyGoals);
  }

  void _updateGoal(String key, dynamic value) {
    setState(() {
      _currentGoals[key] = value;
    });
    widget.onGoalsChanged(_currentGoals);
  }

  String _getDifficultyLevel(String goalType, dynamic value) {
    switch (goalType) {
      case 'studyHours':
        if (value <= 14) return 'Kolay';
        if (value <= 28) return 'Orta';
        return 'Zor';
      case 'questionCount':
        if (value <= 350) return 'Kolay';
        if (value <= 700) return 'Orta';
        return 'Zor';
      case 'practiceExams':
        if (value <= 3) return 'Kolay';
        if (value <= 7) return 'Orta';
        return 'Zor';
      default:
        return 'Orta';
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Kolay':
        return AppTheme.getSuccessColor(true);
      case 'Orta':
        return AppTheme.getWarningColor(true);
      case 'Zor':
        return AppTheme.getErrorColor(true);
      default:
        return AppTheme.getWarningColor(true);
    }
  }

  String _getEstimatedTime(String goalType, dynamic value) {
    switch (goalType) {
      case 'studyHours':
        return '${(value / 7).toStringAsFixed(1)} saat/gün';
      case 'questionCount':
        return '${(value / 7).toStringAsFixed(0)} soru/gün';
      case 'practiceExams':
        return '${(value / 7).toStringAsFixed(1)} deneme/gün';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'date_range',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Haftalık Hedefler',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Weekly Study Hours Goal
            _buildWeeklyGoalItem(
              title: 'Toplam Çalışma Saati',
              icon: 'schedule',
              value: _currentGoals['studyHours'] ?? 14,
              unit: 'saat',
              min: 7,
              max: 70,
              step: 7,
              onChanged: (value) => _updateGoal('studyHours', value),
              goalType: 'studyHours',
            ),

            SizedBox(height: 2.h),

            // Weekly Question Count Goal
            _buildWeeklyGoalItem(
              title: 'Toplam Soru Sayısı',
              icon: 'quiz',
              value: _currentGoals['questionCount'] ?? 350,
              unit: 'soru',
              min: 70,
              max: 1400,
              step: 70,
              onChanged: (value) => _updateGoal('questionCount', value),
              goalType: 'questionCount',
            ),

            SizedBox(height: 2.h),

            // Weekly Practice Exams Goal
            _buildWeeklyGoalItem(
              title: 'Toplam Deneme Sınavı',
              icon: 'assignment',
              value: _currentGoals['practiceExams'] ?? 3,
              unit: 'deneme',
              min: 1,
              max: 14,
              onChanged: (value) => _updateGoal('practiceExams', value),
              goalType: 'practiceExams',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyGoalItem({
    required String title,
    required String icon,
    required int value,
    required String unit,
    required int min,
    required int max,
    int step = 1,
    required Function(int) onChanged,
    required String goalType,
  }) {
    final difficulty = _getDifficultyLevel(goalType, value);
    final difficultyColor = _getDifficultyColor(difficulty);
    final estimatedTime = _getEstimatedTime(goalType, value);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.lightTheme.colorScheme.secondary,
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
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: difficultyColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            difficulty,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: difficultyColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          estimatedTime,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '$value $unit',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Progress Preview Bar
          Container(
            height: 1.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (value - min) / (max - min),
              child: Container(
                decoration: BoxDecoration(
                  color: difficultyColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Value Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.lightTheme.colorScheme.secondary,
              thumbColor: AppTheme.lightTheme.colorScheme.secondary,
              overlayColor:
                  AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.2),
              inactiveTrackColor:
                  AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3),
              trackHeight: 0.8.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 3.w),
            ),
            child: Slider(
              value: value.toDouble(),
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: ((max - min) / step).round(),
              onChanged: (newValue) => onChanged(newValue.round()),
            ),
          ),

          // Min/Max Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$min $unit',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '$max $unit',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}