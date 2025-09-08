import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DailyGoalsSection extends StatefulWidget {
  final Map<String, dynamic> dailyGoals;
  final Function(Map<String, dynamic>) onGoalsChanged;

  const DailyGoalsSection({
    Key? key,
    required this.dailyGoals,
    required this.onGoalsChanged,
  }) : super(key: key);

  @override
  State<DailyGoalsSection> createState() => _DailyGoalsSectionState();
}

class _DailyGoalsSectionState extends State<DailyGoalsSection> {
  late Map<String, dynamic> _currentGoals;

  @override
  void initState() {
    super.initState();
    _currentGoals = Map<String, dynamic>.from(widget.dailyGoals);
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
        if (value <= 2) return 'Kolay';
        if (value <= 4) return 'Orta';
        return 'Zor';
      case 'questionCount':
        if (value <= 50) return 'Kolay';
        if (value <= 100) return 'Orta';
        return 'Zor';
      case 'practiceExams':
        if (value <= 1) return 'Kolay';
        if (value <= 2) return 'Orta';
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
                  iconName: 'today',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Günlük Hedefler',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Study Hours Goal
            _buildGoalItem(
              title: 'Çalışma Saati',
              icon: 'schedule',
              value: _currentGoals['studyHours'] ?? 2,
              unit: 'saat',
              min: 1,
              max: 12,
              onChanged: (value) => _updateGoal('studyHours', value),
              goalType: 'studyHours',
            ),

            SizedBox(height: 2.h),

            // Question Count Goal
            _buildGoalItem(
              title: 'Soru Sayısı',
              icon: 'quiz',
              value: _currentGoals['questionCount'] ?? 50,
              unit: 'soru',
              min: 10,
              max: 200,
              step: 10,
              onChanged: (value) => _updateGoal('questionCount', value),
              goalType: 'questionCount',
            ),

            SizedBox(height: 2.h),

            // Practice Exams Goal
            _buildGoalItem(
              title: 'Deneme Sınavı',
              icon: 'assignment',
              value: _currentGoals['practiceExams'] ?? 1,
              unit: 'deneme',
              min: 0,
              max: 5,
              onChanged: (value) => _updateGoal('practiceExams', value),
              goalType: 'practiceExams',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem({
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
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.lightTheme.primaryColor,
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
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: difficultyColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        difficulty,
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: difficultyColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$value $unit',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.primaryColor,
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

          // Value Stepper
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStepperButton(
                icon: 'remove',
                onPressed: value > min ? () => onChanged(value - step) : null,
              ),
              SizedBox(width: 4.w),
              Container(
                width: 20.w,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value.toString(),
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              _buildStepperButton(
                icon: 'add',
                onPressed: value < max ? () => onChanged(value + step) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepperButton({
    required String icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: onPressed != null
            ? AppTheme.lightTheme.primaryColor
            : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(2.w),
            child: CustomIconWidget(
              iconName: icon,
              color: onPressed != null
                  ? Colors.white
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ),
        ),
      ),
    );
  }
}
