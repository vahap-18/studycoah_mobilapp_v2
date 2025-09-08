import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubjectPerformanceCard extends StatefulWidget {
  const SubjectPerformanceCard({Key? key}) : super(key: key);

  @override
  State<SubjectPerformanceCard> createState() => _SubjectPerformanceCardState();
}

class _SubjectPerformanceCardState extends State<SubjectPerformanceCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int selectedSubjectIndex = -1;

  final List<Map<String, dynamic>> subjectData = [
    {
      "subject": "Türkçe",
      "score": 85.5,
      "color": Color(0xFF6366F1),
      "weakAreas": ["Dil Bilgisi", "Sözcük Türleri"],
      "improvement": "+5.2",
      "totalQuestions": 245,
      "correctAnswers": 209,
    },
    {
      "subject": "Matematik",
      "score": 72.3,
      "color": Color(0xFFEC4899),
      "weakAreas": ["Geometri", "Fonksiyonlar"],
      "improvement": "-2.1",
      "totalQuestions": 312,
      "correctAnswers": 226,
    },
    {
      "subject": "Fen Bilimleri",
      "score": 91.2,
      "color": Color(0xFF10B981),
      "weakAreas": ["Fizik - Hareket"],
      "improvement": "+8.7",
      "totalQuestions": 198,
      "correctAnswers": 181,
    },
    {
      "subject": "Sosyal Bilimler",
      "score": 78.9,
      "color": Color(0xFFF59E0B),
      "weakAreas": ["Tarih", "Coğrafya"],
      "improvement": "+3.4",
      "totalQuestions": 167,
      "correctAnswers": 132,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 2.h),
          _buildDonutChart(),
          SizedBox(height: 3.h),
          _buildSubjectDetails(),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: 'pie_chart',
              color: AppTheme.getSuccessColor(true),
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ders Performansı',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Derslere göre başarı analizi',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showDetailedBreakdown(),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'info_outline',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChart() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: 30.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 12.w,
                    sections: subjectData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final subject = entry.value;
                      final isSelected = selectedSubjectIndex == index;
                      final score = (subject["score"] as num).toDouble();

                      return PieChartSectionData(
                        color: subject["color"],
                        value: score * _animation.value,
                        title: isSelected ? '${score.toStringAsFixed(1)}%' : '',
                        radius: isSelected ? 8.w : 6.w,
                        titleStyle:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        badgeWidget: isSelected ? _buildBadge(subject) : null,
                        badgePositionPercentageOffset: 1.3,
                      );
                    }).toList(),
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            selectedSubjectIndex = -1;
                            return;
                          }
                          selectedSubjectIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: subjectData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final subject = entry.value;
                    final isSelected = selectedSubjectIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSubjectIndex = isSelected ? -1 : index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 0.5.h),
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (subject["color"] as Color)
                                  .withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(color: subject["color"], width: 1)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 3.w,
                              height: 3.w,
                              decoration: BoxDecoration(
                                color: subject["color"],
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subject["subject"],
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                  Text(
                                    '${subject["score"]}%',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: subject["color"],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadge(Map<String, dynamic> subject) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: subject["color"],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        subject["subject"],
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  Widget _buildSubjectDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Zayıf Alanlar ve İyileştirmeler',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...subjectData
              .map((subject) => _buildSubjectDetailCard(subject))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildSubjectDetailCard(Map<String, dynamic> subject) {
    final improvement = subject["improvement"] as String;
    final isPositive = improvement.startsWith('+');

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: (subject["color"] as Color).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (subject["color"] as Color).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  subject["subject"],
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: subject["color"],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
                      : AppTheme.getErrorColor(true).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: isPositive ? 'trending_up' : 'trending_down',
                      color: isPositive
                          ? AppTheme.getSuccessColor(true)
                          : AppTheme.getErrorColor(true),
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      improvement,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isPositive
                            ? AppTheme.getSuccessColor(true)
                            : AppTheme.getErrorColor(true),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Text(
                'Doğru: ${subject["correctAnswers"]}/${subject["totalQuestions"]}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                'Başarı: ${subject["score"]}%',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: subject["color"],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Zayıf Alanlar:',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 0.5.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: (subject["weakAreas"] as List).map((area) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.getWarningColor(true).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color:
                        AppTheme.getWarningColor(true).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  area,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.getWarningColor(true),
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showDetailedBreakdown() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 1.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Detaylı Ders Analizi',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: subjectData.length,
                itemBuilder: (context, index) {
                  final subject = subjectData[index];
                  return _buildDetailedSubjectCard(subject);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedSubjectCard(Map<String, dynamic> subject) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: (subject["color"] as Color).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (subject["color"] as Color).withValues(alpha: 0.2),
          width: 1,
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
                  color: subject["color"],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'school',
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject["subject"],
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: subject["color"],
                      ),
                    ),
                    Text(
                      'Son 30 gün performansı',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${subject["score"]}%',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: subject["color"],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'İyileştirme Önerileri:',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          ...[
            'Günlük 30 dakika odaklanmış çalışma',
            'Zayıf konularda test çözümü',
            'Konu tekrarı ve not alma'
          ].map((suggestion) {
            return Padding(
              padding: EdgeInsets.only(bottom: 0.5.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.getSuccessColor(true),
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      suggestion,
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
