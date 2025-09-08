import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TimerControlsWidget extends StatelessWidget {
  final bool isRunning;
  final bool isPaused;
  final VoidCallback onStartPause;
  final VoidCallback onStop;
  final VoidCallback onSettings;

  const TimerControlsWidget({
    super.key,
    required this.isRunning,
    required this.isPaused,
    required this.onStartPause,
    required this.onStop,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main Start/Pause button
        Container(
          width: 20.w,
          height: 20.w,
          child: ElevatedButton(
            onPressed: onStartPause,
            style: ElevatedButton.styleFrom(
              backgroundColor: isRunning && !isPaused
                  ? AppTheme.lightTheme.colorScheme.secondary
                  : AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: Colors.white,
              shape: CircleBorder(),
              elevation: 8,
              shadowColor: Colors.black.withValues(alpha: 0.3),
              padding: EdgeInsets.zero,
            ),
            child: CustomIconWidget(
              iconName: isRunning && !isPaused ? 'pause' : 'play_arrow',
              color: Colors.white,
              size: 8.w,
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // Secondary controls row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Settings button
            Container(
              width: 12.w,
              height: 12.w,
              child: OutlinedButton(
                onPressed: onSettings,
                style: OutlinedButton.styleFrom(
                  shape: CircleBorder(),
                  side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 1.5,
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: CustomIconWidget(
                  iconName: 'settings',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 5.w,
                ),
              ),
            ),

            // Stop button
            Container(
              width: 12.w,
              height: 12.w,
              child: OutlinedButton(
                onPressed: isRunning || isPaused ? onStop : null,
                style: OutlinedButton.styleFrom(
                  shape: CircleBorder(),
                  side: BorderSide(
                    color: isRunning || isPaused
                        ? AppTheme.lightTheme.colorScheme.error
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: CustomIconWidget(
                  iconName: 'stop',
                  color: isRunning || isPaused
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.5),
                  size: 5.w,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
