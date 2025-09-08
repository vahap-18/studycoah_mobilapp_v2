import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExamScoreTrendsCard extends StatefulWidget {
  const ExamScoreTrendsCard({Key? key}) : super(key: key);

  @override
  State<ExamScoreTrendsCard> createState() => _ExamScoreTrendsCardState();
}

class _ExamScoreTrendsCardState extends State<ExamScoreTrendsCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int selectedSubject = 0;

  final List<String> subjects = ['Türkçe', 'Matematik', 'Fen', 'Sosyal'];
  final List<Color> subjectColors = [
    Color(0xFF6366F1),
    Color(0xFFEC4899),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
  ];

  final Map<String, List<Map<String, dynamic>>> examScores = {
    'Türkçe': [
      {"date": "15 Ağu", "score": 72, "fullDate": "15 Ağustos 2024"},
      {"date": "22 Ağu", "score": 78, "fullDate": "22 Ağustos 2024"},
      {"date": "29 Ağu", "score": 85, "fullDate": "29 Ağustos 2024"},
      {"date": "5 Eyl", "score": 82, "fullDate": "5 Eylül 2024"},
      {"date": "8 Eyl", "score": 88, "fullDate": "8 Eylül 2024"},
    ],
    'Matematik': [
      {"date": "15 Ağu", "score": 65, "fullDate": "15 Ağustos 2024"},
      {"date": "22 Ağu", "score": 68, "fullDate": "22 Ağustos 2024"},
      {"date": "29 Ağu", "score": 72, "fullDate": "29 Ağustos 2024"},
      {"date": "5 Eyl", "score": 75, "fullDate": "5 Eylül 2024"},
      {"date": "8 Eyl", "score": 79, "fullDate": "8 Eylül 2024"},
    ],
    'Fen': [
      {"date": "15 Ağu", "score": 88, "fullDate": "15 Ağustos 2024"},
      {"date": "22 Ağu", "score": 92, "fullDate": "22 Ağustos 2024"},
      {"date": "29 Ağu", "score": 89, "fullDate": "29 Ağustos 2024"},
      {"date": "5 Eyl", "score": 94, "fullDate": "5 Eylül 2024"},
      {"date": "8 Eyl", "score": 96, "fullDate": "8 Eylül 2024"},
    ],
    'Sosyal': [
      {"date": "15 Ağu", "score": 76, "fullDate": "15 Ağustos 2024"},
      {"date": "22 Ağu", "score": 79, "fullDate": "22 Ağustos 2024"},
      {"date": "29 Ağu", "score": 81, "fullDate": "29 Ağustos 2024"},
      {"date": "5 Eyl", "score": 78, "fullDate": "5 Eylül 2024"},
      {"date": "8 Eyl", "score": 83, "fullDate": "8 Eylül 2024"},
    ],
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
          _buildSubjectTabs(),
          SizedBox(height: 3.h),
          _buildScoreChart(),
          SizedBox(height: 3.h),
          _buildScoreAnalysis(),
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
              color: AppTheme.getWarningColor(true).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: 'trending_up',
              color: AppTheme.getWarningColor(true),
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sınav Puan Trendleri',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Deneme sınavı gelişim grafiği',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showAddScoreDialog(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'add',
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Puan',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectTabs() {
    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final isSelected = selectedSubject == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedSubject = index;
              });
              _animationController.reset();
              _animationController.forward();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(right: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? subjectColors[index]
                    : subjectColors[index].withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: subjectColors[index]
                      .withValues(alpha: isSelected ? 1.0 : 0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  subjects[index],
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: isSelected ? Colors.white : subjectColors[index],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScoreChart() {
    final currentSubject = subjects[selectedSubject];
    final scores = examScores[currentSubject] ?? [];
    final currentColor = subjectColors[selectedSubject];

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
                horizontalInterval: 10,
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
                    getTitlesWidget: (double value, TitleMeta meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < scores.length) {
                        return Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: Text(
                            scores[index]["date"],
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
                    interval: 10,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(
                        '${value.toInt()}',
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
              maxX: (scores.length - 1).toDouble(),
              minY: 0,
              maxY: 100,
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: currentColor.withValues(alpha: 0.9),
                  tooltipRoundedRadius: 8,
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                    return touchedBarSpots.map((barSpot) {
                      final scoreData = scores[barSpot.x.toInt()];
                      return LineTooltipItem(
                        '${scoreData["fullDate"]}\n',
                        AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: 'Puan: ${barSpot.y.toInt()}',
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
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: scores.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    final score = (data["score"] as num).toDouble();
                    return FlSpot(index.toDouble(), score * _animation.value);
                  }).toList(),
                  isCurved: true,
                  color: currentColor,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 5,
                        color: currentColor,
                        strokeWidth: 2,
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
                        currentColor.withValues(alpha: 0.3),
                        currentColor.withValues(alpha: 0.1),
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

  Widget _buildScoreAnalysis() {
    final currentSubject = subjects[selectedSubject];
    final scores = examScores[currentSubject] ?? [];
    final currentColor = subjectColors[selectedSubject];

    if (scores.isEmpty) return const SizedBox.shrink();

    final latestScore = (scores.last["score"] as num).toDouble();
    final previousScore = scores.length > 1
        ? (scores[scores.length - 2]["score"] as num).toDouble()
        : latestScore;
    final improvement = latestScore - previousScore;
    final averageScore =
        scores.fold<double>(0, (sum, score) => sum + (score["score"] as num)) /
            scores.length;
    final highestScore = scores
        .map((s) => s["score"] as num)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$currentSubject Analizi',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: currentColor,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildAnalysisCard(
                  'Son Puan',
                  '${latestScore.toInt()}',
                  'grade',
                  currentColor,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildAnalysisCard(
                  'Değişim',
                  '${improvement >= 0 ? '+' : ''}${improvement.toInt()}',
                  improvement >= 0 ? 'trending_up' : 'trending_down',
                  improvement >= 0
                      ? AppTheme.getSuccessColor(true)
                      : AppTheme.getErrorColor(true),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildAnalysisCard(
                  'Ortalama',
                  '${averageScore.toInt()}',
                  'analytics',
                  AppTheme.lightTheme.primaryColor,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildAnalysisCard(
                  'En Yüksek',
                  '${highestScore.toInt()}',
                  'star',
                  Color(0xFFFFD700),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildProgressInsight(
              currentSubject, improvement, averageScore, currentColor),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard(
      String title, String value, String iconName, Color color) {
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
            size: 24,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
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

  Widget _buildProgressInsight(
      String subject, double improvement, double average, Color color) {
    String insightText;
    String recommendationText;
    Color insightColor;
    String iconName;

    if (improvement > 5) {
      insightText = 'Harika İlerleme!';
      recommendationText =
          '$subject dersinde mükemmel bir yükseliş gösteriyorsun. Bu tempoyu korumaya devam et.';
      insightColor = AppTheme.getSuccessColor(true);
      iconName = 'celebration';
    } else if (improvement > 0) {
      insightText = 'Pozitif Gelişim';
      recommendationText =
          '$subject dersinde ilerleme kaydediyorsun. Daha fazla pratik ile bu artışı hızlandırabilirsin.';
      insightColor = AppTheme.lightTheme.primaryColor;
      iconName = 'trending_up';
    } else if (improvement == 0) {
      insightText = 'Sabit Performans';
      recommendationText =
          '$subject dersinde performansın sabit. Yeni çalışma teknikleri deneyerek gelişim sağlayabilirsin.';
      insightColor = AppTheme.getWarningColor(true);
      iconName = 'horizontal_rule';
    } else {
      insightText = 'Gelişim Fırsatı';
      recommendationText =
          '$subject dersinde son sınavda düşüş var. Zayıf konulara odaklanarak toparlanabilirsin.';
      insightColor = AppTheme.getErrorColor(true);
      iconName = 'trending_down';
    }

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: insightColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: insightColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: insightColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                insightText,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: insightColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            recommendationText,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddScoreDialog() {
    final TextEditingController scoreController = TextEditingController();
    String selectedSubjectForScore = subjects[selectedSubject];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Yeni Sınav Puanı Ekle',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedSubjectForScore,
              decoration: InputDecoration(
                labelText: 'Ders Seçin',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: subjects.map((subject) {
                return DropdownMenuItem(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
              onChanged: (value) {
                selectedSubjectForScore = value!;
              },
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: scoreController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Puan (0-100)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: CustomIconWidget(
                  iconName: 'grade',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'İptal',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final score = int.tryParse(scoreController.text);
              if (score != null && score >= 0 && score <= 100) {
                // Add score logic would go here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('$selectedSubjectForScore puanı eklendi: $score'),
                    backgroundColor: AppTheme.getSuccessColor(true),
                  ),
                );
              }
            },
            child: Text('Ekle'),
          ),
        ],
      ),
    );
  }
}