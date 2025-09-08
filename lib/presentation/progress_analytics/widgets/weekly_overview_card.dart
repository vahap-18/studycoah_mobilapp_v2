import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeeklyOverviewCard extends StatefulWidget {
  final PageController pageController;
  final int currentWeekIndex;
  final Function(int) onWeekChanged;

  const WeeklyOverviewCard({
    Key? key,
    required this.pageController,
    required this.currentWeekIndex,
    required this.onWeekChanged,
  }) : super(key: key);

  @override
  State<WeeklyOverviewCard> createState() => _WeeklyOverviewCardState();
}

class _WeeklyOverviewCardState extends State<WeeklyOverviewCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Map<String, dynamic>> weeklyData = [
    {
      "weekTitle": "Bu Hafta",
      "weekRange": "2 - 8 Eylül 2024",
      "dailyData": [
        {"day": "Pzt", "studyHours": 4.5, "questions": 85, "goalAchieved": 90},
        {"day": "Sal", "studyHours": 3.2, "questions": 65, "goalAchieved": 75},
        {"day": "Çar", "studyHours": 5.1, "questions": 95, "goalAchieved": 95},
        {"day": "Per", "studyHours": 2.8, "questions": 45, "goalAchieved": 60},
        {"day": "Cum", "studyHours": 4.8, "questions": 88, "goalAchieved": 88},
        {
          "day": "Cmt",
          "studyHours": 6.2,
          "questions": 110,
          "goalAchieved": 100
        },
        {"day": "Paz", "studyHours": 3.5, "questions": 70, "goalAchieved": 80},
      ],
      "totalHours": 30.1,
      "totalQuestions": 558,
      "avgGoalAchievement": 84,
    },
    {
      "weekTitle": "Geçen Hafta",
      "weekRange": "26 Ağu - 1 Eyl 2024",
      "dailyData": [
        {"day": "Pzt", "studyHours": 3.8, "questions": 72, "goalAchieved": 85},
        {"day": "Sal", "studyHours": 4.2, "questions": 78, "goalAchieved": 82},
        {"day": "Çar", "studyHours": 2.9, "questions": 55, "goalAchieved": 65},
        {"day": "Per", "studyHours": 5.5, "questions": 98, "goalAchieved": 95},
        {"day": "Cum", "studyHours": 4.1, "questions": 82, "goalAchieved": 88},
        {"day": "Cmt", "studyHours": 3.7, "questions": 68, "goalAchieved": 75},
        {"day": "Paz", "studyHours": 4.6, "questions": 89, "goalAchieved": 92},
      ],
      "totalHours": 28.8,
      "totalQuestions": 542,
      "avgGoalAchievement": 83,
    },
    {
      "weekTitle": "2 Hafta Önce",
      "weekRange": "19 - 25 Ağustos 2024",
      "dailyData": [
        {"day": "Pzt", "studyHours": 3.2, "questions": 58, "goalAchieved": 70},
        {"day": "Sal", "studyHours": 4.8, "questions": 92, "goalAchieved": 90},
        {"day": "Çar", "studyHours": 3.5, "questions": 67, "goalAchieved": 78},
        {"day": "Per", "studyHours": 2.1, "questions": 38, "goalAchieved": 45},
        {"day": "Cum", "studyHours": 5.2, "questions": 105, "goalAchieved": 98},
        {"day": "Cmt", "studyHours": 4.3, "questions": 85, "goalAchieved": 85},
        {"day": "Paz", "studyHours": 3.9, "questions": 74, "goalAchieved": 82},
      ],
      "totalHours": 27.0,
      "totalQuestions": 519,
      "avgGoalAchievement": 78,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
          _buildWeekSelector(),
          SizedBox(height: 3.h),
          _buildChart(),
          SizedBox(height: 3.h),
          _buildSummaryStats(),
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
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: 'bar_chart',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Haftalık Genel Bakış',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Günlük çalışma performansın',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekSelector() {
    return Container(
      height: 8.h,
      child: PageView.builder(
        controller: widget.pageController,
        onPageChanged: widget.onWeekChanged,
        itemCount: weeklyData.length,
        itemBuilder: (context, index) {
          final weekData = weeklyData[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  weekData["weekTitle"],
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  weekData["weekRange"],
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChart() {
    final currentWeekData = weeklyData[widget.currentWeekIndex];
    final dailyData = currentWeekData["dailyData"] as List;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: 25.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 120,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.9),
                  tooltipRoundedRadius: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final dayData = dailyData[group.x.toInt()];
                    return BarTooltipItem(
                      '${dayData["day"]}\n',
                      AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: '${dayData["studyHours"]} saat\n',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: '${dayData["questions"]} soru\n',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: '%${dayData["goalAchieved"]} hedef',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      final dayData = dailyData[value.toInt()];
                      return Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: Text(
                          dayData["day"],
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 10.w,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(
                        '${value.toInt()}%',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontSize: 10.sp,
                        ),
                      );
                    },
                  ),
                ),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 20,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    strokeWidth: 1,
                  );
                },
              ),
              barGroups: dailyData.asMap().entries.map((entry) {
                final index = entry.key;
                final dayData = entry.value as Map<String, dynamic>;
                final goalAchieved =
                    (dayData["goalAchieved"] as num).toDouble();

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: goalAchieved * _animation.value,
                      color: _getBarColor(goalAchieved),
                      width: 4.w,
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          _getBarColor(goalAchieved),
                          _getBarColor(goalAchieved).withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Color _getBarColor(double percentage) {
    if (percentage >= 90) {
      return AppTheme.getSuccessColor(true);
    } else if (percentage >= 70) {
      return AppTheme.lightTheme.primaryColor;
    } else if (percentage >= 50) {
      return AppTheme.getWarningColor(true);
    } else {
      return AppTheme.getErrorColor(true);
    }
  }

  Widget _buildSummaryStats() {
    final currentWeekData = weeklyData[widget.currentWeekIndex];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Toplam Saat',
              '${currentWeekData["totalHours"]}',
              'saat',
              AppTheme.lightTheme.primaryColor,
              'schedule',
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildStatCard(
              'Toplam Soru',
              '${currentWeekData["totalQuestions"]}',
              'soru',
              AppTheme.getSuccessColor(true),
              'quiz',
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildStatCard(
              'Ortalama Hedef',
              '%${currentWeekData["avgGoalAchievement"]}',
              'başarı',
              AppTheme.getWarningColor(true),
              'trending_up',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String unit, Color color, String iconName) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 20,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}