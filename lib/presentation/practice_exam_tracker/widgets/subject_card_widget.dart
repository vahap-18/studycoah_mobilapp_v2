import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubjectCardWidget extends StatelessWidget {
  final Map<String, dynamic> subject;
  final VoidCallback onTap;

  const SubjectCardWidget({
    Key? key,
    required this.subject,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentScore = (subject['currentScore'] as num?)?.toDouble() ?? 0.0;
    final targetScore = (subject['targetScore'] as num?)?.toDouble() ?? 100.0;
    final trend = subject['trend'] as String? ?? 'stable';
    final recentScores = (subject['recentScores'] as List?)?.cast<num>() ?? [];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
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
                Expanded(
                  child: Text(
                    subject['name'] as String? ?? 'Konu',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getTrendColor(trend).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: _getTrendIcon(trend),
                        color: _getTrendColor(trend),
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        _getTrendText(trend),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: _getTrendColor(trend),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mevcut Ortalama',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${currentScore.toStringAsFixed(1)} / ${targetScore.toInt()}',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 20.w,
                  height: 8.h,
                  child: _buildMiniChart(recentScores),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            LinearProgressIndicator(
              value: currentScore / targetScore,
              backgroundColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(currentScore / targetScore),
              ),
              minHeight: 6,
            ),
            SizedBox(height: 1.h),
            Text(
              'Hedefe ${((currentScore / targetScore) * 100).toStringAsFixed(0)}% ulaştınız',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniChart(List<num> scores) {
    if (scores.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'Veri Yok',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final maxScore = scores.reduce((a, b) => a > b ? a : b).toDouble();
    final minScore = scores.reduce((a, b) => a < b ? a : b).toDouble();
    final range = maxScore - minScore;

    return CustomPaint(
      painter: MiniChartPainter(
        scores: scores.map((s) => s.toDouble()).toList(),
        maxScore: maxScore,
        minScore: minScore,
        color: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'improving':
        return AppTheme.getSuccessColor(true);
      case 'declining':
        return AppTheme.getErrorColor(true);
      default:
        return AppTheme.getWarningColor(true);
    }
  }

  String _getTrendIcon(String trend) {
    switch (trend) {
      case 'improving':
        return 'trending_up';
      case 'declining':
        return 'trending_down';
      default:
        return 'trending_flat';
    }
  }

  String _getTrendText(String trend) {
    switch (trend) {
      case 'improving':
        return 'Yükseliş';
      case 'declining':
        return 'Düşüş';
      default:
        return 'Sabit';
    }
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.8) {
      return AppTheme.getSuccessColor(true);
    } else if (progress >= 0.6) {
      return AppTheme.getWarningColor(true);
    } else {
      return AppTheme.getErrorColor(true);
    }
  }
}

class MiniChartPainter extends CustomPainter {
  final List<double> scores;
  final double maxScore;
  final double minScore;
  final Color color;

  MiniChartPainter({
    required this.scores,
    required this.maxScore,
    required this.minScore,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (scores.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final range = maxScore - minScore;

    for (int i = 0; i < scores.length; i++) {
      final x = (i / (scores.length - 1)) * size.width;
      final normalizedScore = range > 0 ? (scores[i] - minScore) / range : 0.5;
      final y = size.height - (normalizedScore * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (int i = 0; i < scores.length; i++) {
      final x = (i / (scores.length - 1)) * size.width;
      final normalizedScore = range > 0 ? (scores[i] - minScore) / range : 0.5;
      final y = size.height - (normalizedScore * size.height);
      canvas.drawCircle(Offset(x, y), 3, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
