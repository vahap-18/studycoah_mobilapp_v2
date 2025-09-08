import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TimerDisplayWidget extends StatelessWidget {
  final Duration remainingTime;
  final Duration totalTime;
  final bool isRunning;
  final String sessionType;
  final int currentSession;
  final int totalSessions;

  const TimerDisplayWidget({
    super.key,
    required this.remainingTime,
    required this.totalTime,
    required this.isRunning,
    required this.sessionType,
    required this.currentSession,
    required this.totalSessions,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalTime.inSeconds > 0
        ? (totalTime.inSeconds - remainingTime.inSeconds) / totalTime.inSeconds
        : 0.0;

    return Column(
      children: [
        // Session type and counter
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: sessionType == 'Study'
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                sessionType,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: sessionType == 'Study'
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Session $currentSession/$totalSessions',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 4.h),

        // Circular timer with progress ring
        Container(
          width: 70.w,
          height: 70.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.lightTheme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
              ),

              // Progress ring
              SizedBox(
                width: 70.w,
                height: 70.w,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    sessionType == 'Study'
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                ),
              ),

              // Timer text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatTime(remainingTime),
                    style: AppTheme.dataTextStyle(
                      isLight: true,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRunning
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.colorScheme.outline,
                    ),
                    child: isRunning
                        ? Center(
                            child: Container(
                              width: 2.w,
                              height: 2.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes);
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
