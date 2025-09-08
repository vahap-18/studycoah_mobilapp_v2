import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/daily_goals_section.dart';
import './widgets/goal_decomposition_section.dart';
import './widgets/smart_suggestions_section.dart';
import './widgets/weekly_goals_section.dart';

class GoalSetting extends StatefulWidget {
  const GoalSetting({Key? key}) : super(key: key);

  @override
  State<GoalSetting> createState() => _GoalSettingState();
}

class _GoalSettingState extends State<GoalSetting>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Goal data
  Map<String, dynamic> _dailyGoals = {
    'studyHours': 2,
    'questionCount': 50,
    'practiceExams': 1,
  };

  Map<String, dynamic> _weeklyGoals = {
    'studyHours': 14,
    'questionCount': 350,
    'practiceExams': 3,
  };

  Map<String, bool> _decompositionSettings = {
    'autoBreakStudyHours': false,
    'autoBreakQuestions': false,
    'autoScheduleExams': false,
  };

  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSavedGoals();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadSavedGoals() {
    // Mock loading saved goals from local storage
    // In real implementation, this would load from SharedPreferences or local database
    setState(() {
      // Goals are already initialized with default values
    });
  }

  void _onDailyGoalsChanged(Map<String, dynamic> goals) {
    setState(() {
      _dailyGoals = goals;
      _hasUnsavedChanges = true;
      // Auto-update weekly goals based on daily goals
      _weeklyGoals['studyHours'] = (goals['studyHours'] ?? 2) * 7;
      _weeklyGoals['questionCount'] = (goals['questionCount'] ?? 50) * 7;
      _weeklyGoals['practiceExams'] =
          ((goals['practiceExams'] ?? 1) * 3.5).ceil();
    });
  }

  void _onWeeklyGoalsChanged(Map<String, dynamic> goals) {
    setState(() {
      _weeklyGoals = goals;
      _hasUnsavedChanges = true;
    });
  }

  void _onDecompositionSettingsChanged(Map<String, bool> settings) {
    setState(() {
      _decompositionSettings = settings;
      _hasUnsavedChanges = true;
    });
  }

  void _onApplySuggestion(Map<String, dynamic> suggestedGoals) {
    setState(() {
      _dailyGoals.addAll(suggestedGoals);
      _hasUnsavedChanges = true;
      // Update weekly goals accordingly
      _weeklyGoals['studyHours'] = (_dailyGoals['studyHours'] ?? 2) * 7;
      _weeklyGoals['questionCount'] = (_dailyGoals['questionCount'] ?? 50) * 7;
      _weeklyGoals['practiceExams'] =
          ((_dailyGoals['practiceExams'] ?? 1) * 3.5).ceil();
    });
  }

  Future<void> _saveGoals() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Mock saving to local storage
      await Future.delayed(const Duration(milliseconds: 1500));

      // In real implementation, save to SharedPreferences or local database
      // await SharedPreferences.getInstance().then((prefs) {
      //   prefs.setString('dailyGoals', jsonEncode(_dailyGoals));
      //   prefs.setString('weeklyGoals', jsonEncode(_weeklyGoals));
      //   prefs.setString('decompositionSettings', jsonEncode(_decompositionSettings));
      // });

      setState(() {
        _hasUnsavedChanges = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: Colors.white,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text('Hedefler başarıyla kaydedildi!'),
              ],
            ),
            backgroundColor: AppTheme.getSuccessColor(true),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            action: SnackBarAction(
              label: 'Ana Sayfa',
              textColor: Colors.white,
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/home-dashboard'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hedefler kaydedilirken bir hata oluştu'),
            backgroundColor: AppTheme.getErrorColor(true),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resetToRecommended() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.getWarningColor(true),
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text('Önerilen Değerlere Sıfırla'),
          ],
        ),
        content: Text(
          'Tüm hedefler önerilen değerlere sıfırlanacak. Bu işlem geri alınamaz. Devam etmek istiyor musunuz?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _dailyGoals = {
                  'studyHours': 3,
                  'questionCount': 75,
                  'practiceExams': 1,
                };
                _weeklyGoals = {
                  'studyHours': 21,
                  'questionCount': 525,
                  'practiceExams': 4,
                };
                _decompositionSettings = {
                  'autoBreakStudyHours': true,
                  'autoBreakQuestions': true,
                  'autoScheduleExams': true,
                };
                _hasUnsavedChanges = true;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Hedefler önerilen değerlere sıfırlandı'),
                  backgroundColor: AppTheme.getSuccessColor(true),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.getWarningColor(true),
            ),
            child: Text('Sıfırla'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Hedef Belirleme'),
        leading: IconButton(
          onPressed: () {
            if (_hasUnsavedChanges) {
              _showUnsavedChangesDialog();
            } else {
              Navigator.pop(context);
            }
          },
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        actions: [
          if (_hasUnsavedChanges)
            Container(
              margin: EdgeInsets.only(right: 2.w),
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: AppTheme.getWarningColor(true),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'edit',
                color: Colors.white,
                size: 4.w,
              ),
            ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => _buildMoreOptionsSheet(),
              );
            },
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'today',
                color: AppTheme.lightTheme.primaryColor,
                size: 5.w,
              ),
              text: 'Hedefler',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'auto_awesome',
                color: AppTheme.lightTheme.primaryColor,
                size: 5.w,
              ),
              text: 'Öneriler',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Goals Tab
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 2.h),

                // YKS 2026 Countdown Card
                _buildCountdownCard(),

                // Daily Goals Section
                DailyGoalsSection(
                  dailyGoals: _dailyGoals,
                  onGoalsChanged: _onDailyGoalsChanged,
                ),

                // Weekly Goals Section
                WeeklyGoalsSection(
                  weeklyGoals: _weeklyGoals,
                  onGoalsChanged: _onWeeklyGoalsChanged,
                ),

                // Goal Decomposition Section
                GoalDecompositionSection(
                  dailyGoals: _dailyGoals,
                  weeklyGoals: _weeklyGoals,
                  decompositionSettings: _decompositionSettings,
                  onSettingsChanged: _onDecompositionSettingsChanged,
                ),

                SizedBox(height: 10.h), // Space for bottom buttons
              ],
            ),
          ),

          // Smart Suggestions Tab
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 2.h),
                SmartSuggestionsSection(
                  currentGoals: _dailyGoals,
                  onApplySuggestion: _onApplySuggestion,
                ),
                SizedBox(height: 10.h), // Space for bottom buttons
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildCountdownCard() {
    final DateTime yksDate = DateTime(2026, 6, 15);
    final int daysLeft = yksDate.difference(DateTime.now()).inDays;
    final int monthsLeft = (daysLeft / 30).floor();
    final int remainingDays = daysLeft % 30;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              AppTheme.lightTheme.primaryColor,
              AppTheme.lightTheme.colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'event',
                  color: Colors.white,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'YKS 2026 Geri Sayım',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCountdownItem('$monthsLeft', 'Ay', Colors.white),
                _buildCountdownItem('$remainingDays', 'Gün', Colors.white),
                _buildCountdownItem(
                    '${(daysLeft / 7).floor()}', 'Hafta', Colors.white),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              'Hedeflerini belirle ve başarıya odaklan!',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: color.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_hasUnsavedChanges)
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 2.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.getWarningColor(true).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        AppTheme.getWarningColor(true).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.getWarningColor(true),
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Kaydedilmemiş değişiklikler var',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.getWarningColor(true),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetToRecommended,
                    child: Text('Önerilen Değerler'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveGoals,
                    child: _isLoading
                        ? SizedBox(
                            height: 5.w,
                            width: 5.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'save',
                                color: Colors.white,
                                size: 5.w,
                              ),
                              SizedBox(width: 2.w),
                              Text('Hedefleri Kaydet'),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreOptionsSheet() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Daha Fazla Seçenek',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          _buildOptionTile(
            icon: 'subject',
            title: 'Ders Bazlı Hedefler',
            subtitle: 'Her ders için ayrı hedef belirle',
            onTap: () {
              Navigator.pop(context);
              // Navigate to subject-specific goals
            },
          ),
          _buildOptionTile(
            icon: 'weekend',
            title: 'Hafta Sonu Ayarları',
            subtitle: 'Hafta sonu çalışma planını düzenle',
            onTap: () {
              Navigator.pop(context);
              // Navigate to weekend settings
            },
          ),
          _buildOptionTile(
            icon: 'notifications',
            title: 'Hatırlatma Ayarları',
            subtitle: 'Hedef hatırlatmalarını özelleştir',
            onTap: () {
              Navigator.pop(context);
              // Navigate to notification settings
            },
          ),
          _buildOptionTile(
            icon: 'history',
            title: 'Hedef Geçmişi',
            subtitle: 'Geçmiş hedeflerini görüntüle',
            onTap: () {
              Navigator.pop(context);
              // Navigate to goal history
            },
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.primaryColor,
          size: 5.w,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'arrow_forward_ios',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 4.w,
      ),
      onTap: onTap,
    );
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.getWarningColor(true),
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text('Kaydedilmemiş Değişiklikler'),
          ],
        ),
        content: Text(
          'Yaptığınız değişiklikler kaydedilmedi. Çıkmak istediğinizden emin misiniz?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Çık'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _saveGoals();
            },
            child: Text('Kaydet ve Çık'),
          ),
        ],
      ),
    );
  }
}