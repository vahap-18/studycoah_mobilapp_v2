import 'package:flutter/material.dart';
import '../presentation/progress_analytics/progress_analytics.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/goal_setting/goal_setting.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/study_timer/study_timer.dart';
import '../presentation/practice_exam_tracker/practice_exam_tracker.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String progressAnalytics = '/progress-analytics';
  static const String splash = '/splash-screen';
  static const String goalSetting = '/goal-setting';
  static const String homeDashboard = '/home-dashboard';
  static const String studyTimer = '/study-timer';
  static const String practiceExamTracker = '/practice-exam-tracker';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    progressAnalytics: (context) => const ProgressAnalytics(),
    splash: (context) => const SplashScreen(),
    goalSetting: (context) => const GoalSetting(),
    homeDashboard: (context) => const HomeDashboard(),
    studyTimer: (context) => const StudyTimer(),
    practiceExamTracker: (context) => const PracticeExamTracker(),
    // TODO: Add your other routes here
  };
}
