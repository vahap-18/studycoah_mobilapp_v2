import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_showcase_card.dart';
import './widgets/exam_score_trends_card.dart';
import './widgets/study_cycle_analysis_card.dart';
import './widgets/subject_performance_card.dart';
import './widgets/virtual_garden_card.dart';
import './widgets/weekly_overview_card.dart';

class ProgressAnalytics extends StatefulWidget {
  const ProgressAnalytics({Key? key}) : super(key: key);

  @override
  State<ProgressAnalytics> createState() => _ProgressAnalyticsState();
}

class _ProgressAnalyticsState extends State<ProgressAnalytics>
    with TickerProviderStateMixin {
  late PageController _weeklyPageController;
  late AnimationController _refreshAnimationController;
  late Animation<double> _refreshAnimation;

  int currentWeekIndex = 0;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _weeklyPageController = PageController(initialPage: 0);
    _refreshAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _refreshAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _weeklyPageController.dispose();
    _refreshAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.lightTheme.primaryColor,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              _buildProgressHeader(),
              SizedBox(height: 2.h),
              WeeklyOverviewCard(
                pageController: _weeklyPageController,
                currentWeekIndex: currentWeekIndex,
                onWeekChanged: _onWeekChanged,
              ),
              const SubjectPerformanceCard(),
              const AchievementShowcaseCard(),
              const VirtualGardenCard(),
              const StudyCycleAnalysisCard(),
              const ExamScoreTrendsCard(),
              SizedBox(height: 2.h),
              _buildBottomActions(),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 20,
          ),
        ),
      ),
      title: Text(
        'İlerleme Analizi',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: _showShareOptions,
          child: Container(
            margin: EdgeInsets.all(2.w),
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildProgressHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: 'analytics',
                color: Colors.white,
                size: 28,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analiz Özeti',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Son 30 günlük performans verilerine dayalı detaylı analiz',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      _buildQuickStat('Toplam Saat', '127',
                          AppTheme.lightTheme.primaryColor),
                      SizedBox(width: 4.w),
                      _buildQuickStat('Ortalama Puan', '82',
                          AppTheme.getSuccessColor(true)),
                      SizedBox(width: 4.w),
                      _buildQuickStat(
                          'Hedef %', '89', AppTheme.getWarningColor(true)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontSize: 9.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hızlı Eylemler',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Hedef Belirle',
                  'Yeni çalışma hedefleri oluştur',
                  'flag',
                  AppTheme.lightTheme.primaryColor,
                  () => Navigator.pushNamed(context, '/goal-setting'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  'Çalışma Başlat',
                  'Pomodoro timer ile çalışmaya başla',
                  'play_arrow',
                  AppTheme.getSuccessColor(true),
                  () => Navigator.pushNamed(context, '/study-timer'),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildActionButton(
            'Deneme Sınavı Ekle',
            'Yeni deneme sınav sonucunu kaydet ve analiz et',
            'quiz',
            AppTheme.getWarningColor(true),
            () => Navigator.pushNamed(context, '/practice-exam-tracker'),
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    String description,
    String iconName,
    Color color,
    VoidCallback onTap, {
    bool isFullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: isFullWidth
            ? Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          description,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'arrow_forward',
                    color: color,
                    size: 20,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontSize: 10.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
      ),
    );
  }

  void _onWeekChanged(int index) {
    setState(() {
      currentWeekIndex = index;
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      isRefreshing = true;
    });

    _refreshAnimationController.forward();

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isRefreshing = false;
    });

    _refreshAnimationController.reset();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Analiz verileri güncellendi'),
          backgroundColor: AppTheme.getSuccessColor(true),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                'İlerleme Paylaş',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _buildShareOption(
              'Ekran Görüntüsü Al',
              'Mevcut analizi görüntü olarak kaydet',
              'screenshot',
              AppTheme.lightTheme.primaryColor,
              () {
                Navigator.pop(context);
                _takeScreenshot();
              },
            ),
            _buildShareOption(
              'PDF Raporu Oluştur',
              'Detaylı analiz raporunu PDF olarak indir',
              'picture_as_pdf',
              AppTheme.getErrorColor(true),
              () {
                Navigator.pop(context);
                _generatePDFReport();
              },
            ),
            _buildShareOption(
              'Aile ile Paylaş',
              'İlerleme özetini aile üyeleriyle paylaş',
              'family_restroom',
              AppTheme.getSuccessColor(true),
              () {
                Navigator.pop(context);
                _shareWithFamily();
              },
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(
    String title,
    String description,
    String iconName,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: Colors.white,
                size: 24,
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
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward',
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _takeScreenshot() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ekran görüntüsü alındı ve galeriye kaydedildi'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }

  void _generatePDFReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF raporu oluşturuluyor...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _shareWithFamily() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('İlerleme özeti aile ile paylaşıldı'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }
}
