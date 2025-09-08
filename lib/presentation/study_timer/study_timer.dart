import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/audio_controls_widget.dart';
import './widgets/break_reminder_widget.dart';
import './widgets/session_summary_widget.dart';
import './widgets/timer_controls_widget.dart';
import './widgets/timer_display_widget.dart';

class StudyTimer extends StatefulWidget {
  const StudyTimer({super.key});

  @override
  State<StudyTimer> createState() => _StudyTimerState();
}

class _StudyTimerState extends State<StudyTimer> with TickerProviderStateMixin {
  // Timer state
  Timer? _timer;
  Duration _remainingTime = Duration(minutes: 25);
  Duration _totalTime = Duration(minutes: 25);
  bool _isRunning = false;
  bool _isPaused = false;
  bool _isBreakTime = false;
  bool _showSummary = false;

  // Session tracking
  int _currentSession = 1;
  int _totalSessions = 4;
  int _completedSessions = 0;
  Duration _totalStudyTime = Duration.zero;

  // Audio settings
  bool _isAudioEnabled = false;
  String _selectedAudioType = 'Lo-fi';
  double _volume = 0.5;

  // Settings
  Duration _studyDuration = Duration(minutes: 25);
  Duration _breakDuration = Duration(minutes: 5);
  Duration _longBreakDuration = Duration(minutes: 15);

  // Animation controllers
  late AnimationController _celebrationController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadSettings();
  }

  void _initializeAnimations() {
    _celebrationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _pulseController.repeat(reverse: true);
  }

  void _loadSettings() {
    // Load user preferences from local storage
    // For now using default values
    setState(() {
      _remainingTime = _studyDuration;
      _totalTime = _studyDuration;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _celebrationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startPauseTimer() {
    if (_isRunning && !_isPaused) {
      _pauseTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    // Prevent screen from sleeping during study sessions
    if (!_isBreakTime) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
        } else {
          _completeSession();
        }
      });
    });

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = true;
    });

    _timer?.cancel();

    // Re-enable system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  void _stopTimer() {
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _remainingTime = _isBreakTime ? _breakDuration : _studyDuration;
      _totalTime = _isBreakTime ? _breakDuration : _studyDuration;
    });

    _timer?.cancel();

    // Re-enable system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Haptic feedback
    HapticFeedback.mediumImpact();
  }

  void _completeSession() {
    _timer?.cancel();

    setState(() {
      _isRunning = false;
      _isPaused = false;
    });

    // Re-enable system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Celebration animation
    _celebrationController.forward().then((_) {
      _celebrationController.reset();
    });

    // Haptic feedback
    HapticFeedback.heavyImpact();

    if (_isBreakTime) {
      _completeBreak();
    } else {
      _completeStudySession();
    }
  }

  void _completeStudySession() {
    setState(() {
      _completedSessions++;
      _totalStudyTime = _totalStudyTime + _studyDuration;

      // Check if it's time for a long break
      if (_completedSessions % 4 == 0) {
        _isBreakTime = true;
        _remainingTime = _longBreakDuration;
        _totalTime = _longBreakDuration;
      } else if (_completedSessions < _totalSessions) {
        _isBreakTime = true;
        _remainingTime = _breakDuration;
        _totalTime = _breakDuration;
      } else {
        _showSummary = true;
      }
    });

    // Update daily goal progress
    _updateGoalProgress();
  }

  void _completeBreak() {
    setState(() {
      _isBreakTime = false;
      _currentSession++;
      _remainingTime = _studyDuration;
      _totalTime = _studyDuration;
    });
  }

  void _skipBreak() {
    setState(() {
      _isBreakTime = false;
      _currentSession++;
      _remainingTime = _studyDuration;
      _totalTime = _studyDuration;
    });
  }

  void _updateGoalProgress() {
    // Calculate progress towards daily study goal
    // This would typically update local storage and sync with goal tracking
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSettingsSheet(),
    );
  }

  Widget _buildSettingsSheet() {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Text(
            'Timer Ayarları',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 3.h),

          // Settings options
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              children: [
                _buildSettingItem(
                  'Çalışma Süresi',
                  '${_studyDuration.inMinutes} dakika',
                  'schedule',
                  () => _showDurationPicker('study'),
                ),
                _buildSettingItem(
                  'Kısa Mola',
                  '${_breakDuration.inMinutes} dakika',
                  'coffee',
                  () => _showDurationPicker('break'),
                ),
                _buildSettingItem(
                  'Uzun Mola',
                  '${_longBreakDuration.inMinutes} dakika',
                  'weekend',
                  () => _showDurationPicker('longBreak'),
                ),
                _buildSettingItem(
                  'Toplam Seans',
                  '$_totalSessions seans',
                  'repeat',
                  () => _showSessionPicker(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
      String title, String value, String iconName, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        ),
        child: CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 5.w,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium,
      ),
      subtitle: Text(
        value,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'chevron_right',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 5.w,
      ),
      onTap: onTap,
    );
  }

  void _showDurationPicker(String type) {
    // Implementation for duration picker
    Navigator.pop(context);
  }

  void _showSessionPicker() {
    // Implementation for session count picker
    Navigator.pop(context);
  }

  void _continueSessions() {
    setState(() {
      _showSummary = false;
      _currentSession = 1;
      _completedSessions = 0;
      _isBreakTime = false;
      _remainingTime = _studyDuration;
      _totalTime = _studyDuration;
    });
  }

  void _finishSessions() {
    Navigator.pushReplacementNamed(context, '/home-dashboard');
  }

  int _calculateGoalProgress() {
    // Mock calculation - would be based on actual daily goals
    final targetMinutes = 120; // 2 hours daily goal
    final completedMinutes = _totalStudyTime.inMinutes;
    return ((completedMinutes / targetMinutes) * 100).round().clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Çalışma Zamanlayıcısı'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_showSummary)
            IconButton(
              icon: CustomIconWidget(
                iconName: 'home',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 6.w,
              ),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/home-dashboard'),
            ),
        ],
      ),
      body: SafeArea(
        child: _showSummary ? _buildSummaryView() : _buildTimerView(),
      ),
    );
  }

  Widget _buildTimerView() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          SizedBox(height: 2.h),

          // Timer display
          TimerDisplayWidget(
            remainingTime: _remainingTime,
            totalTime: _totalTime,
            isRunning: _isRunning && !_isPaused,
            sessionType: _isBreakTime ? 'Mola' : 'Çalışma',
            currentSession: _currentSession,
            totalSessions: _totalSessions,
          ),

          SizedBox(height: 4.h),

          // Break reminder (only during break time)
          if (_isBreakTime && !_isRunning)
            BreakReminderWidget(
              remainingTime: _remainingTime,
              onSkipBreak: _skipBreak,
            ),

          if (!_isBreakTime || _isRunning)
            Column(
              children: [
                // Timer controls
                TimerControlsWidget(
                  isRunning: _isRunning,
                  isPaused: _isPaused,
                  onStartPause: _startPauseTimer,
                  onStop: _stopTimer,
                  onSettings: _showSettings,
                ),

                SizedBox(height: 4.h),

                // Audio controls
                AudioControlsWidget(
                  isAudioEnabled: _isAudioEnabled,
                  selectedAudioType: _selectedAudioType,
                  volume: _volume,
                  onToggleAudio: () {
                    setState(() {
                      _isAudioEnabled = !_isAudioEnabled;
                    });
                  },
                  onAudioTypeChanged: (type) {
                    setState(() {
                      _selectedAudioType = type;
                    });
                  },
                  onVolumeChanged: (volume) {
                    setState(() {
                      _volume = volume;
                    });
                  },
                ),
              ],
            ),

          SizedBox(height: 4.h),

          // Session progress
          if (_completedSessions > 0)
            Container(
              padding: EdgeInsets.all(4.w),
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Bugünkü İlerleme',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildProgressItem(
                        'Tamamlanan',
                        '$_completedSessions seans',
                        'check_circle',
                        AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                      _buildProgressItem(
                        'Toplam Süre',
                        '${_totalStudyTime.inMinutes}dk',
                        'schedule',
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryView() {
    return Center(
      child: SessionSummaryWidget(
        completedSessions: _completedSessions,
        totalStudyTime: _totalStudyTime,
        goalProgress: _calculateGoalProgress(),
        onContinue: _continueSessions,
        onFinish: _finishSessions,
      ),
    );
  }

  Widget _buildProgressItem(
      String label, String value, String iconName, Color color) {
    return Column(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.2),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 6.w,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
