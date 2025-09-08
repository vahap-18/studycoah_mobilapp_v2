import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SmartSuggestionsSection extends StatefulWidget {
  final Map<String, dynamic> currentGoals;
  final Function(Map<String, dynamic>) onApplySuggestion;

  const SmartSuggestionsSection({
    Key? key,
    required this.currentGoals,
    required this.onApplySuggestion,
  }) : super(key: key);

  @override
  State<SmartSuggestionsSection> createState() =>
      _SmartSuggestionsSectionState();
}

class _SmartSuggestionsSectionState extends State<SmartSuggestionsSection> {
  List<Map<String, dynamic>> _generateSmartSuggestions() {
    List<Map<String, dynamic>> suggestions = [];

    // Mock historical performance data
    final Map<String, dynamic> mockPerformance = {
      'averageStudyHours': 2.5,
      'averageQuestions': 45,
      'averageExams': 2,
      'strongSubjects': ['Matematik', 'Fen'],
      'weakSubjects': ['Türkçe', 'Sosyal'],
      'bestStudyTime': 'Sabah',
      'completionRate': 0.75,
    };

    // YKS 2026 countdown (mock calculation)
    final DateTime yksDate = DateTime(2026, 6, 15);
    final int daysLeft = yksDate.difference(DateTime.now()).inDays;
    final int weeksLeft = (daysLeft / 7).ceil();

    // Generate suggestions based on performance and timeline
    if (widget.currentGoals['studyHours'] != null) {
      final currentHours = widget.currentGoals['studyHours'] as int;
      final avgHours = mockPerformance['averageStudyHours'] as double;

      if (currentHours < avgHours) {
        suggestions.add({
          'type': 'increase',
          'title': 'Çalışma Saatini Artır',
          'description':
              'Geçmiş performansına göre günde ${avgHours.toStringAsFixed(1)} saat çalışman daha etkili olabilir',
          'icon': 'trending_up',
          'color': AppTheme.getSuccessColor(true),
          'action': 'studyHours',
          'suggestedValue': avgHours.ceil(),
          'reason': 'Geçmiş verilerine dayanarak',
        });
      }
    }

    if (daysLeft < 365) {
      suggestions.add({
        'type': 'intensive',
        'title': 'Yoğun Çalışma Moduna Geç',
        'description':
            'YKS 2026\'ya ${daysLeft} gün kaldı. Hedeflerini artırman önerilir',
        'icon': 'rocket_launch',
        'color': AppTheme.getWarningColor(true),
        'action': 'intensive',
        'suggestedValue': null,
        'reason': 'Sınav yaklaşıyor',
      });
    }

    // Weak subject focus suggestion
    if (mockPerformance['weakSubjects'] != null) {
      final weakSubjects = mockPerformance['weakSubjects'] as List<String>;
      suggestions.add({
        'type': 'focus',
        'title': 'Zayıf Derslere Odaklan',
        'description':
            '${weakSubjects.join(", ")} derslerine daha fazla zaman ayır',
        'icon': 'psychology',
        'color': AppTheme.lightTheme.colorScheme.secondary,
        'action': 'focus',
        'suggestedValue': weakSubjects,
        'reason': 'Performans analizi',
      });
    }

    // Balanced approach suggestion
    suggestions.add({
      'type': 'balanced',
      'title': 'Dengeli Yaklaşım',
      'description':
          'Tüm derslere eşit zaman ayırarak dengeli bir çalışma planı oluştur',
      'icon': 'balance',
      'color': AppTheme.lightTheme.primaryColor,
      'action': 'balanced',
      'suggestedValue': {
        'studyHours': 4,
        'questionCount': 80,
        'practiceExams': 2,
      },
      'reason': 'Önerilen strateji',
    });

    // Gradual increase suggestion
    if (mockPerformance['completionRate'] as double > 0.8) {
      suggestions.add({
        'type': 'gradual',
        'title': 'Kademeli Artış',
        'description': 'Hedeflerini %20 artırarak kendini daha fazla zorla',
        'icon': 'stairs',
        'color': AppTheme.getSuccessColor(true),
        'action': 'gradual',
        'suggestedValue': 1.2,
        'reason': 'Yüksek tamamlama oranı',
      });
    }

    return suggestions;
  }

  void _applySuggestion(Map<String, dynamic> suggestion) {
    Map<String, dynamic> newGoals =
        Map<String, dynamic>.from(widget.currentGoals);

    switch (suggestion['action']) {
      case 'studyHours':
        newGoals['studyHours'] = suggestion['suggestedValue'];
        break;
      case 'intensive':
        newGoals['studyHours'] = (newGoals['studyHours'] ?? 2) + 2;
        newGoals['questionCount'] = (newGoals['questionCount'] ?? 50) + 30;
        newGoals['practiceExams'] = (newGoals['practiceExams'] ?? 1) + 1;
        break;
      case 'balanced':
        final balanced = suggestion['suggestedValue'] as Map<String, dynamic>;
        newGoals.addAll(balanced);
        break;
      case 'gradual':
        final multiplier = suggestion['suggestedValue'] as double;
        newGoals['studyHours'] =
            ((newGoals['studyHours'] ?? 2) * multiplier).ceil();
        newGoals['questionCount'] =
            ((newGoals['questionCount'] ?? 50) * multiplier).ceil();
        break;
    }

    widget.onApplySuggestion(newGoals);

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${suggestion['title']} uygulandı!'),
        backgroundColor: AppTheme.getSuccessColor(true),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = _generateSmartSuggestions();

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
                  iconName: 'lightbulb',
                  color: AppTheme.getWarningColor(true),
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Akıllı Öneriler',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.getWarningColor(true).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'AI Destekli',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.getWarningColor(true),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Performansın ve YKS 2026 hedefin doğrultusunda kişiselleştirilmiş öneriler',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),

            // Suggestions List
            ...suggestions
                .map((suggestion) => _buildSuggestionCard(suggestion))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(Map<String, dynamic> suggestion) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: (suggestion['color'] as Color).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (suggestion['color'] as Color).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: (suggestion['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: suggestion['icon'],
                  color: suggestion['color'],
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion['title'],
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: (suggestion['color'] as Color)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        suggestion['reason'],
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: suggestion['color'],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            suggestion['description'],
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: Text('Daha Fazla'),
              ),
              SizedBox(width: 2.w),
              ElevatedButton(
                onPressed: () => _applySuggestion(suggestion),
                style: ElevatedButton.styleFrom(
                  backgroundColor: suggestion['color'],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                ),
                child: Text('Uygula'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}