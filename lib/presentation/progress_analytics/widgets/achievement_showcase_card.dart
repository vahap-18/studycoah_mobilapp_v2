import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementShowcaseCard extends StatefulWidget {
  const AchievementShowcaseCard({Key? key}) : super(key: key);

  @override
  State<AchievementShowcaseCard> createState() =>
      _AchievementShowcaseCardState();
}

class _AchievementShowcaseCardState extends State<AchievementShowcaseCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> achievements = [
    {
      "id": 1,
      "title": "Altın Rozet",
      "description": "100 saat çalışma tamamlandı",
      "icon": "emoji_events",
      "color": Color(0xFFFFD700),
      "isUnlocked": true,
      "progress": 100,
      "maxProgress": 100,
      "unlockedDate": "28 Ağustos 2024",
      "category": "Çalışma Saati",
    },
    {
      "id": 2,
      "title": "Motivasyon Ustası",
      "description": "7 gün üst üste hedef tamamlandı",
      "icon": "local_fire_department",
      "color": Color(0xFFFF6B35),
      "isUnlocked": true,
      "progress": 7,
      "maxProgress": 7,
      "unlockedDate": "5 Eylül 2024",
      "category": "Süreklilik",
    },
    {
      "id": 3,
      "title": "Soru Avcısı",
      "description": "1000 soru çözüldü",
      "icon": "quiz",
      "color": Color(0xFF10B981),
      "isUnlocked": true,
      "progress": 1000,
      "maxProgress": 1000,
      "unlockedDate": "2 Eylül 2024",
      "category": "Soru Çözümü",
    },
    {
      "id": 4,
      "title": "Gece Kartalı",
      "description": "Gece çalışma seansları",
      "icon": "nights_stay",
      "color": Color(0xFF6366F1),
      "isUnlocked": false,
      "progress": 8,
      "maxProgress": 15,
      "unlockedDate": "",
      "category": "Çalışma Zamanı",
    },
    {
      "id": 5,
      "title": "Matematik Dehası",
      "description": "Matematik testlerinde %90+ başarı",
      "icon": "calculate",
      "color": Color(0xFFEC4899),
      "isUnlocked": false,
      "progress": 85,
      "maxProgress": 90,
      "unlockedDate": "",
      "category": "Ders Başarısı",
    },
    {
      "id": 6,
      "title": "Sabah Kuşu",
      "description": "Sabah erken çalışma alışkanlığı",
      "icon": "wb_sunny",
      "color": Color(0xFFF59E0B),
      "isUnlocked": false,
      "progress": 12,
      "maxProgress": 20,
      "unlockedDate": "",
      "category": "Çalışma Zamanı",
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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
    final unlockedAchievements =
        achievements.where((a) => a["isUnlocked"] == true).toList();
    final lockedAchievements =
        achievements.where((a) => a["isUnlocked"] == false).toList();

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
          _buildAchievementStats(),
          SizedBox(height: 3.h),
          _buildUnlockedAchievements(unlockedAchievements),
          SizedBox(height: 3.h),
          _buildProgressAchievements(lockedAchievements),
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
              color: Color(0xFFFFD700).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: 'emoji_events',
              color: Color(0xFFFFD700),
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Başarı Rozetleri',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Kazandığın başarılar ve ilerlemen',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showAllAchievements(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Tümü',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementStats() {
    final unlockedCount =
        achievements.where((a) => a["isUnlocked"] == true).length;
    final totalCount = achievements.length;
    final completionPercentage = (unlockedCount / totalCount * 100).round();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Toplam İlerleme',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Text(
                        '$unlockedCount',
                        style: AppTheme.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.getSuccessColor(true),
                        ),
                      ),
                      Text(
                        '/$totalCount',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '(%$completionPercentage)',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  LinearProgressIndicator(
                    value: unlockedCount / totalCount,
                    backgroundColor: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.getSuccessColor(true)),
                    minHeight: 1.h,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            SizedBox(width: 4.w),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'trending_up',
                color: AppTheme.getSuccessColor(true),
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnlockedAchievements(
      List<Map<String, dynamic>> unlockedAchievements) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Kazanılan Rozetler',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          height: 15.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: unlockedAchievements.length,
            itemBuilder: (context, index) {
              final achievement = unlockedAchievements[index];
              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: _buildAchievementCard(achievement, true),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProgressAchievements(
      List<Map<String, dynamic>> lockedAchievements) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'İlerleme Halinde',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        ...lockedAchievements
            .take(2)
            .map((achievement) => _buildProgressCard(achievement))
            .toList(),
      ],
    );
  }

  Widget _buildAchievementCard(
      Map<String, dynamic> achievement, bool isUnlocked) {
    return Container(
      width: 25.w,
      margin: EdgeInsets.only(right: 3.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isUnlocked
            ? (achievement["color"] as Color).withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked
              ? (achievement["color"] as Color).withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? achievement["color"]
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: achievement["icon"],
              color: isUnlocked
                  ? Colors.white
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            achievement["title"],
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isUnlocked
                  ? achievement["color"]
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isUnlocked) ...[
            SizedBox(height: 0.5.h),
            Text(
              achievement["unlockedDate"],
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 9.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressCard(Map<String, dynamic> achievement) {
    final progress = (achievement["progress"] as num).toDouble();
    final maxProgress = (achievement["maxProgress"] as num).toDouble();
    final progressPercentage = (progress / maxProgress * 100).round();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: (achievement["color"] as Color).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (achievement["color"] as Color).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: (achievement["color"] as Color).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: achievement["icon"],
              color: achievement["color"],
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        achievement["title"],
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: achievement["color"],
                        ),
                      ),
                    ),
                    Text(
                      '$progressPercentage%',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: achievement["color"],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  achievement["description"],
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress / maxProgress,
                        backgroundColor: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(achievement["color"]),
                        minHeight: 0.8.h,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${progress.toInt()}/${maxProgress.toInt()}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 10.sp,
                      ),
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

  void _showAllAchievements() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
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
                'Tüm Başarı Rozetleri',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3.w,
                  mainAxisSpacing: 2.h,
                  childAspectRatio: 0.8,
                ),
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  final achievement = achievements[index];
                  return _buildDetailedAchievementCard(achievement);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedAchievementCard(Map<String, dynamic> achievement) {
    final isUnlocked = achievement["isUnlocked"] as bool;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isUnlocked
            ? (achievement["color"] as Color).withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked
              ? (achievement["color"] as Color).withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? achievement["color"]
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: achievement["icon"],
              color: isUnlocked
                  ? Colors.white
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 32,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            achievement["title"],
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isUnlocked
                  ? achievement["color"]
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            achievement["description"],
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
                  : AppTheme.getWarningColor(true).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isUnlocked ? 'Kazanıldı' : 'İlerleme Halinde',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isUnlocked
                    ? AppTheme.getSuccessColor(true)
                    : AppTheme.getWarningColor(true),
                fontWeight: FontWeight.w600,
                fontSize: 9.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
