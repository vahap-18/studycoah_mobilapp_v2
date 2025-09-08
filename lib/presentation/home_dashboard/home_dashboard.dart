import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/coaching_card_widget.dart';
import './widgets/countdown_timer_widget.dart';
import './widgets/daily_goals_card_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/study_streak_widget.dart';
import './widgets/user_avatar_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshDashboard() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    // Trigger haptic feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dashboard güncellendi'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _navigateToStudyTimer() {
    Navigator.pushNamed(context, '/study-timer');
  }

  void _navigateToGoalSetting() {
    Navigator.pushNamed(context, '/goal-setting');
  }

  void _navigateToProgressAnalytics() {
    Navigator.pushNamed(context, '/progress-analytics');
  }

  void _navigateToPracticeExamTracker() {
    Navigator.pushNamed(context, '/practice-exam-tracker');
  }

  void _showAvatarDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAvatarDetailsSheet(),
    );
  }

  void _showStreakHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildStreakHistorySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar with Tab Navigation
            _buildCustomAppBar(),
            // Main Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHomeTab(),
                  _buildPlaceholderTab('Hedefler'),
                  _buildPlaceholderTab('Zamanlayıcı'),
                  _buildPlaceholderTab('İlerleme'),
                  _buildPlaceholderTab('Sınavlar'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: _navigateToStudyTimer,
              icon: CustomIconWidget(
                iconName: 'timer',
                color: Colors.white,
                size: 5.w,
              ),
              label: Text(
                'Pomodoro',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'StudyCoach',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Merhaba, başarılı öğrenci! 👋',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Show notifications
                    },
                    child: Container(
                      padding: EdgeInsets.all(2.5.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CustomIconWidget(
                        iconName: 'notifications',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 5.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  GestureDetector(
                    onTap: () {
                      // Show settings
                    },
                    child: Container(
                      padding: EdgeInsets.all(2.5.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CustomIconWidget(
                        iconName: 'settings',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 5.w,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppTheme.lightTheme.colorScheme.primary,
            unselectedLabelColor:
                AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            indicatorColor: AppTheme.lightTheme.colorScheme.primary,
            indicatorWeight: 3,
            labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle:
                AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w400,
            ),
            tabs: const [
              Tab(text: 'Ana Sayfa'),
              Tab(text: 'Hedefler'),
              Tab(text: 'Zamanlayıcı'),
              Tab(text: 'İlerleme'),
              Tab(text: 'Sınavlar'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshDashboard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 1.h),
            // YKS Countdown Timer
            CountdownTimerWidget(),
            // User Avatar with Level
            UserAvatarWidget(
              currentLevel: 3,
              currentXP: 750,
              xpToNextLevel: 1000,
              onTap: _showAvatarDetails,
            ),
            // Daily Goals Card
            DailyGoalsCardWidget(
              studyHoursGoal: 6,
              studyHoursCompleted: 4,
              questionsGoal: 50,
              questionsCompleted: 35,
              practiceExamsGoal: 2,
              practiceExamsCompleted: 1,
              onEditGoals: _navigateToGoalSetting,
            ),
            // Today's Coaching Card
            CoachingCardWidget(
              onRefresh: () {
                // Handle coaching tip refresh
              },
            ),
            // Study Streak
            StudyStreakWidget(
              currentStreak: 7,
              bestStreak: 15,
              weeklyProgress: const [true, true, false, true, true, true, true],
              onTap: _showStreakHistory,
            ),
            // Quick Actions
            QuickActionsWidget(
              onStartStudy: _navigateToStudyTimer,
              onSetGoals: _navigateToGoalSetting,
              onViewProgress: _navigateToProgressAnalytics,
            ),
            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderTab(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'construction',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            '$tabName sayfası',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Yakında geliyor...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarDetailsSheet() {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Avatar İlerlemesi',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3.h),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 25.w,
                        height: 25.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.lightTheme.colorScheme.primary,
                              AppTheme.lightTheme.colorScheme.secondary,
                            ],
                          ),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'person',
                            color: Colors.white,
                            size: 12.w,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Seviye 3 Öğrenci',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '750 / 1000 XP',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Kazanımlar',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                _buildAchievementItem('🏆', 'İlk Hafta', 'Tamamlandı'),
                _buildAchievementItem('🔥', '7 Gün Seri', 'Tamamlandı'),
                _buildAchievementItem('📚', '100 Soru', '35/100'),
                _buildAchievementItem('⏰', '50 Saat', '28/50'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(String emoji, String title, String progress) {
    final isCompleted = progress == 'Tamamlandı';

    return Container(
      padding: EdgeInsets.all(3.w),
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 6.w)),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            progress,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: isCompleted
                  ? AppTheme.lightTheme.colorScheme.tertiary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakHistorySheet() {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Çalışma Serisi Geçmişi',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Mevcut Seri', '7 gün', '🔥'),
                    _buildStatItem('En İyi Seri', '15 gün', '🏆'),
                    _buildStatItem('Toplam Gün', '45 gün', '📅'),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  'Son Başarılar',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                _buildStreakHistoryItem(
                    '7 Gün Seri Tamamlandı', '2 gün önce', true),
                _buildStreakHistoryItem(
                    'İlk Hafta Başarısı', '1 hafta önce', true),
                _buildStreakHistoryItem('3 Gün Seri', '2 hafta önce', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, String emoji) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 8.w)),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStreakHistoryItem(String title, String date, bool isCompleted) {
    return Container(
      padding: EdgeInsets.all(3.w),
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: isCompleted ? 'check_circle' : 'schedule',
              color: isCompleted
                  ? AppTheme.lightTheme.colorScheme.tertiary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  date,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
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
}
