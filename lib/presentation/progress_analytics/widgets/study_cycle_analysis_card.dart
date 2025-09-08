import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StudyCycleAnalysisCard extends StatefulWidget {
  const StudyCycleAnalysisCard({Key? key}) : super(key: key);

  @override
  State<StudyCycleAnalysisCard> createState() => _StudyCycleAnalysisCardState();
}

class _StudyCycleAnalysisCardState extends State<StudyCycleAnalysisCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int selectedHour = -1;

  final List<Map<String, dynamic>> hourlyPerformance = [
    {"hour": 6, "performance": 45, "sessions": 2, "label": "06:00"},
    {"hour": 7, "performance": 65, "sessions": 5, "label": "07:00"},
    {"hour": 8, "performance": 85, "sessions": 8, "label": "08:00"},
    {"hour": 9, "performance": 92, "sessions": 12, "label": "09:00"},
    {"hour": 10, "performance": 88, "sessions": 15, "label": "10:00"},
    {"hour": 11, "performance": 75, "sessions": 10, "label": "11:00"},
    {"hour": 12, "performance": 55, "sessions": 6, "label": "12:00"},
    {"hour": 13, "performance": 40, "sessions": 3, "label": "13:00"},
    {"hour": 14, "performance": 50, "sessions": 4, "label": "14:00"},
    {"hour": 15, "performance": 70, "sessions": 8, "label": "15:00"},
    {"hour": 16, "performance": 82, "sessions": 11, "label": "16:00"},
    {"hour": 17, "performance": 78, "sessions": 9, "label": "17:00"},
    {"hour": 18, "performance": 65, "sessions": 7, "label": "18:00"},
    {"hour": 19, "performance": 72, "sessions": 10, "label": "19:00"},
    {"hour": 20, "performance": 85, "sessions": 14, "label": "20:00"},
    {"hour": 21, "performance": 90, "sessions": 16, "label": "21:00"},
    {"hour": 22, "performance": 75, "sessions": 8, "label": "22:00"},
    {"hour": 23, "performance": 45, "sessions": 3, "label": "23:00"},
  ];

  final List<Map<String, dynamic>> recommendations = [
    {
      "title": "Altın Saatler",
      "description": "09:00-10:00 ve 20:00-21:00 arası en verimli saatlerin",
      "icon": "star",
      "color": Color(0xFFFFD700),
      "hours": ["09:00", "21:00"],
    },
    {
      "title": "Kaçınılacak Saatler",
      "description": "12:00-14:00 arası performansın düşük",
      "icon": "warning",
      "color": Color(0xFFF59E0B),
      "hours": ["12:00", "13:00"],
    },
    {
      "title": "Gelişim Fırsatı",
      "description": "15:00-17:00 arası potansiyel yüksek",
      "icon": "trending_up",
      "color": Color(0xFF10B981),
      "hours": ["15:00", "16:00"],
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
          _buildPerformanceChart(),
          SizedBox(height: 3.h),
          _buildOptimalHours(),
          SizedBox(height: 3.h),
          _buildRecommendations(),
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
              iconName: 'timeline',
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
                  'Çalışma Döngüsü Analizi',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Saatlik performans analizi',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showDetailedAnalysis(),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'analytics',
                color: AppTheme.getSuccessColor(true),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: 25.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: LineChart(
            LineChartData(
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
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 6.h,
                    interval: 3,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < hourlyPerformance.length) {
                        final hourData = hourlyPerformance[index];
                        return Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: Text(
                            '${hourData["hour"]}:00',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              fontSize: 9.sp,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 10.w,
                    interval: 20,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(
                        '${value.toInt()}%',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontSize: 9.sp,
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
              minX: 0,
              maxX: (hourlyPerformance.length - 1).toDouble(),
              minY: 0,
              maxY: 100,
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.9),
                  tooltipRoundedRadius: 8,
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                    return touchedBarSpots.map((barSpot) {
                      final hourData = hourlyPerformance[barSpot.x.toInt()];
                      return LineTooltipItem(
                        '${hourData["label"]}\n',
                        AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: 'Performans: %${barSpot.y.toInt()}\n',
                            style: AppTheme.lightTheme.textTheme.bodySmall!
                                .copyWith(
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: 'Seans: ${hourData["sessions"]}',
                            style: AppTheme.lightTheme.textTheme.bodySmall!
                                .copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
                touchCallback:
                    (FlTouchEvent event, LineTouchResponse? touchResponse) {
                  setState(() {
                    if (touchResponse != null &&
                        touchResponse.lineBarSpots != null) {
                      selectedHour =
                          touchResponse.lineBarSpots!.first.x.toInt();
                    } else {
                      selectedHour = -1;
                    }
                  });
                },
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: hourlyPerformance.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    final performance = (data["performance"] as num).toDouble();
                    return FlSpot(
                        index.toDouble(), performance * _animation.value);
                  }).toList(),
                  isCurved: true,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.lightTheme.primaryColor,
                      AppTheme.getSuccessColor(true),
                    ],
                  ),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      final isSelected = selectedHour == index;
                      return FlDotCirclePainter(
                        radius: isSelected ? 6 : 4,
                        color: isSelected
                            ? AppTheme.getWarningColor(true)
                            : AppTheme.lightTheme.primaryColor,
                        strokeWidth: isSelected ? 2 : 0,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptimalHours() {
    final topPerformanceHours = [...hourlyPerformance]..sort(
        (a, b) => (b["performance"] as num).compareTo(a["performance"] as num));
    final top3Hours = topPerformanceHours.take(3).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'En Verimli Saatler',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: top3Hours.asMap().entries.map((entry) {
              final index = entry.key;
              final hourData = entry.value;
              final colors = [
                Color(0xFFFFD700), // Gold
                Color(0xFFC0C0C0), // Silver
                Color(0xFFCD7F32), // Bronze
              ];
              final ranks = ['1.', '2.', '3.'];

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index < 2 ? 2.w : 0),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: colors[index].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colors[index].withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ranks[index],
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colors[index],
                            ),
                          ),
                          SizedBox(width: 1.w),
                          CustomIconWidget(
                            iconName: index == 0 ? 'emoji_events' : 'star',
                            color: colors[index],
                            size: 20,
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '${hourData["hour"]}:00',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors[index],
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '%${hourData["performance"]}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kişiselleştirilmiş Öneriler',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...recommendations
              .map((recommendation) => _buildRecommendationCard(recommendation))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(Map<String, dynamic> recommendation) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: (recommendation["color"] as Color).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (recommendation["color"] as Color).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: recommendation["color"],
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: recommendation["icon"],
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
                  recommendation["title"],
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: recommendation["color"],
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  recommendation["description"],
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 1.w,
                  children: (recommendation["hours"] as List).map((hour) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: (recommendation["color"] as Color)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        hour,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: recommendation["color"],
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailedAnalysis() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
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
                'Detaylı Çalışma Döngüsü Analizi',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: hourlyPerformance.length,
                itemBuilder: (context, index) {
                  final hourData = hourlyPerformance[index];
                  return _buildDetailedHourCard(hourData);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedHourCard(Map<String, dynamic> hourData) {
    final performance = (hourData["performance"] as num).toDouble();
    final sessions = hourData["sessions"] as int;
    final hour = hourData["hour"] as int;

    Color performanceColor;
    String performanceLevel;

    if (performance >= 80) {
      performanceColor = AppTheme.getSuccessColor(true);
      performanceLevel = 'Mükemmel';
    } else if (performance >= 60) {
      performanceColor = AppTheme.lightTheme.primaryColor;
      performanceLevel = 'İyi';
    } else if (performance >= 40) {
      performanceColor = AppTheme.getWarningColor(true);
      performanceLevel = 'Orta';
    } else {
      performanceColor = AppTheme.getErrorColor(true);
      performanceLevel = 'Düşük';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: performanceColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: performanceColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: performanceColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$hour:00',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: performanceColor,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        performanceLevel,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: performanceColor,
                        ),
                      ),
                    ),
                    Text(
                      '%${performance.toInt()}',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: performanceColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '$sessions çalışma seansı',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 1.h),
                LinearProgressIndicator(
                  value: performance / 100,
                  backgroundColor: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(performanceColor),
                  minHeight: 0.6.h,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}