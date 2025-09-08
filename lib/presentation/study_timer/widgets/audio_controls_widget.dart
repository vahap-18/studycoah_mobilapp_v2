import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AudioControlsWidget extends StatelessWidget {
  final bool isAudioEnabled;
  final String selectedAudioType;
  final double volume;
  final VoidCallback onToggleAudio;
  final Function(String) onAudioTypeChanged;
  final Function(double) onVolumeChanged;

  const AudioControlsWidget({
    super.key,
    required this.isAudioEnabled,
    required this.selectedAudioType,
    required this.volume,
    required this.onToggleAudio,
    required this.onAudioTypeChanged,
    required this.onVolumeChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (!isAudioEnabled) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'volume_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            TextButton(
              onPressed: onToggleAudio,
              child: Text(
                'Enable Background Audio',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Audio type selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAudioTypeButton('Lo-fi', 'library_music'),
              _buildAudioTypeButton('Nature', 'nature'),
              _buildAudioTypeButton('White Noise', 'graphic_eq'),
            ],
          ),

          SizedBox(height: 2.h),

          // Volume control
          Row(
            children: [
              CustomIconWidget(
                iconName: 'volume_down',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              Expanded(
                child: Slider(
                  value: volume,
                  onChanged: onVolumeChanged,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  activeColor: AppTheme.lightTheme.colorScheme.primary,
                  inactiveColor: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              CustomIconWidget(
                iconName: 'volume_up',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ],
          ),

          // Disable audio button
          TextButton(
            onPressed: onToggleAudio,
            child: Text(
              'Disable Audio',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioTypeButton(String label, String iconName) {
    final isSelected = selectedAudioType == label;

    return GestureDetector(
      onTap: () => onAudioTypeChanged(label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
