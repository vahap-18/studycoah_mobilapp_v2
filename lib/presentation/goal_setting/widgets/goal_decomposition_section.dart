import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GoalDecompositionSection extends StatefulWidget {
  final Map<String, dynamic> dailyGoals;
  final Map<String, dynamic> weeklyGoals;
  final Map<String, bool> decompositionSettings;
  final Function(Map<String, bool>) onSettingsChanged;

  const GoalDecompositionSection({
    Key? key,
    required this.dailyGoals,
    required this.weeklyGoals,
    required this.decompositionSettings,
    required this.onSettingsChanged,
  }) : super(key: key);

  @override
  State<GoalDecompositionSection> createState() =>
      _GoalDecompositionSectionState();
}

class _GoalDecompositionSectionState extends State<GoalDecompositionSection> {
  late Map<String, bool> _currentSettings;

  @override
  void initState() {
    super.initState();
    _currentSettings = Map<String, bool>.from(widget.decompositionSettings);
  }

  void _updateSetting(String key, bool value) {
    setState(() {
      _currentSettings[key] = value;
    });
    widget.onSettingsChanged(_currentSettings);
  }

  List<Map<String, dynamic>> _generateDecomposedTasks() {
    List<Map<String, dynamic>> tasks = [];

    // Study Hours Decomposition
    if (_currentSettings['autoBreakStudyHours'] ?? false) {
      final dailyHours = widget.dailyGoals['studyHours'] ?? 2;
      if (dailyHours > 2) {
        tasks.add({
          'title': 'Sabah Çalışma Seansı',
          'description':
              '${(dailyHours * 0.4).toStringAsFixed(1)} saat matematik ve fen',
          'icon': 'wb_sunny',
          'color': AppTheme.getWarningColor(true),
          'time': '08:00 - ${(8 + (dailyHours * 0.4)).toStringAsFixed(0)}:00',
        });
        tasks.add({
          'title': 'Öğleden Sonra Seansı',
          'description':
              '${(dailyHours * 0.4).toStringAsFixed(1)} saat türkçe ve sosyal',
          'icon': 'wb_cloudy',
          'color': AppTheme.lightTheme.primaryColor,
          'time': '14:00 - ${(14 + (dailyHours * 0.4)).toStringAsFixed(0)}:00',
        });
        tasks.add({
          'title': 'Akşam Tekrar Seansı',
          'description':
              '${(dailyHours * 0.2).toStringAsFixed(1)} saat günün tekrarı',
          'icon': 'nights_stay',
          'color': AppTheme.lightTheme.colorScheme.secondary,
          'time': '20:00 - ${(20 + (dailyHours * 0.2)).toStringAsFixed(0)}:00',
        });
      }
    }

    // Question Count Decomposition
    if (_currentSettings['autoBreakQuestions'] ?? false) {
      final dailyQuestions = widget.dailyGoals['questionCount'] ?? 50;
      if (dailyQuestions > 30) {
        tasks.add({
          'title': 'Matematik Soruları',
          'description':
              '${(dailyQuestions * 0.3).toStringAsFixed(0)} soru çöz',
          'icon': 'calculate',
          'color': AppTheme.getSuccessColor(true),
          'time': 'Sabah seansında',
        });
        tasks.add({
          'title': 'Fen Soruları',
          'description':
              '${(dailyQuestions * 0.3).toStringAsFixed(0)} soru çöz',
          'icon': 'science',
          'color': AppTheme.getSuccessColor(true),
          'time': 'Sabah seansında',
        });
        tasks.add({
          'title': 'Türkçe Soruları',
          'description':
              '${(dailyQuestions * 0.2).toStringAsFixed(0)} soru çöz',
          'icon': 'menu_book',
          'color': AppTheme.getSuccessColor(true),
          'time': 'Öğleden sonra',
        });
        tasks.add({
          'title': 'Sosyal Soruları',
          'description':
              '${(dailyQuestions * 0.2).toStringAsFixed(0)} soru çöz',
          'icon': 'public',
          'color': AppTheme.getSuccessColor(true),
          'time': 'Öğleden sonra',
        });
      }
    }

    // Practice Exam Decomposition
    if (_currentSettings['autoScheduleExams'] ?? false) {
      final weeklyExams = widget.weeklyGoals['practiceExams'] ?? 3;
      if (weeklyExams > 1) {
        tasks.add({
          'title': 'Haftalık Deneme Planı',
          'description': 'Pazartesi: TYT, Çarşamba: AYT, Cumartesi: Karma',
          'icon': 'event_note',
          'color': AppTheme.getWarningColor(true),
          'time': 'Haftalık program',
        });
      }
    }

    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    final decomposedTasks = _generateDecomposedTasks();

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
                  iconName: 'auto_awesome',
                  color: AppTheme.getSuccessColor(true),
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Hedef Ayrıştırma',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Büyük hedeflerinizi küçük, yönetilebilir görevlere bölelim',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),

            // Decomposition Settings
            _buildDecompositionToggle(
              title: 'Çalışma Saatlerini Böl',
              subtitle: 'Günlük çalışma saatini seanslar halinde ayır',
              icon: 'schedule',
              value: _currentSettings['autoBreakStudyHours'] ?? false,
              onChanged: (value) =>
                  _updateSetting('autoBreakStudyHours', value),
            ),

            SizedBox(height: 2.h),

            _buildDecompositionToggle(
              title: 'Soruları Derslere Böl',
              subtitle: 'Günlük soru sayısını derslere göre dağıt',
              icon: 'quiz',
              value: _currentSettings['autoBreakQuestions'] ?? false,
              onChanged: (value) => _updateSetting('autoBreakQuestions', value),
            ),

            SizedBox(height: 2.h),

            _buildDecompositionToggle(
              title: 'Deneme Sınavlarını Planla',
              subtitle: 'Haftalık denemeleri günlere dağıt',
              icon: 'assignment',
              value: _currentSettings['autoScheduleExams'] ?? false,
              onChanged: (value) => _updateSetting('autoScheduleExams', value),
            ),

            // Show decomposed tasks if any settings are enabled
            if (decomposedTasks.isNotEmpty) ...[
              SizedBox(height: 3.h),
              Divider(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3)),
              SizedBox(height: 2.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'task_alt',
                    color: AppTheme.getSuccessColor(true),
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Önerilen Görevler',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              ...decomposedTasks.map((task) => _buildTaskItem(task)).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDecompositionToggle({
    required String title,
    required String subtitle,
    required String icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: value
            ? AppTheme.getSuccessColor(true).withValues(alpha: 0.05)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value
              ? AppTheme.getSuccessColor(true).withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: value
                  ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: value
                  ? AppTheme.getSuccessColor(true)
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: (task['color'] as Color).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (task['color'] as Color).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: task['icon'],
            color: task['color'],
            size: 4.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  task['description'],
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (task['time'] != null)
                  Text(
                    task['time'],
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: task['color'],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}