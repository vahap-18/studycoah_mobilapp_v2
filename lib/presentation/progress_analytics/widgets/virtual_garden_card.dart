import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VirtualGardenCard extends StatefulWidget {
  const VirtualGardenCard({Key? key}) : super(key: key);

  @override
  State<VirtualGardenCard> createState() => _VirtualGardenCardState();
}

class _VirtualGardenCardState extends State<VirtualGardenCard>
    with TickerProviderStateMixin {
  late AnimationController _growthAnimationController;
  late AnimationController _waterAnimationController;
  late Animation<double> _growthAnimation;
  late Animation<double> _waterAnimation;

  final List<Map<String, dynamic>> plants = [
    {
      "id": 1,
      "name": "Matematik Çiçeği",
      "type": "flower",
      "growthLevel": 85,
      "maxGrowth": 100,
      "studyHours": 42,
      "requiredHours": 50,
      "color": Color(0xFFEC4899),
      "icon": "local_florist",
      "lastWatered": "2 saat önce",
      "isFullyGrown": false,
    },
    {
      "id": 2,
      "name": "Türkçe Ağacı",
      "type": "tree",
      "growthLevel": 100,
      "maxGrowth": 100,
      "studyHours": 65,
      "requiredHours": 60,
      "color": Color(0xFF10B981),
      "icon": "park",
      "lastWatered": "1 gün önce",
      "isFullyGrown": true,
    },
    {
      "id": 3,
      "name": "Fen Filizi",
      "type": "sprout",
      "growthLevel": 35,
      "maxGrowth": 100,
      "studyHours": 18,
      "requiredHours": 50,
      "color": Color(0xFF6366F1),
      "icon": "eco",
      "lastWatered": "4 saat önce",
      "isFullyGrown": false,
    },
    {
      "id": 4,
      "name": "Sosyal Kaktüs",
      "type": "cactus",
      "growthLevel": 60,
      "maxGrowth": 100,
      "studyHours": 28,
      "requiredHours": 45,
      "color": Color(0xFFF59E0B),
      "icon": "grass",
      "lastWatered": "6 saat önce",
      "isFullyGrown": false,
    },
  ];

  int selectedPlantIndex = -1;

  @override
  void initState() {
    super.initState();
    _growthAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _waterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _growthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _growthAnimationController, curve: Curves.easeInOut),
    );
    _waterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _waterAnimationController, curve: Curves.bounceOut),
    );
    _growthAnimationController.forward();
  }

  @override
  void dispose() {
    _growthAnimationController.dispose();
    _waterAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          _buildGardenStats(),
          SizedBox(height: 3.h),
          _buildGardenGrid(),
          SizedBox(height: 3.h),
          _buildGardenTips(),
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
              color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: 'local_florist',
              color: AppTheme.getSuccessColor(true),
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sanal Bahçem',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Çalışma ile büyüyen bitkiler',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showGardenGuide(),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'help_outline',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGardenStats() {
    final totalPlants = plants.length;
    final fullyGrownPlants =
        plants.where((p) => p["isFullyGrown"] == true).length;
    final totalStudyHours =
        plants.fold<int>(0, (sum, plant) => sum + (plant["studyHours"] as int));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.getSuccessColor(true).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                'Toplam Bitki',
                '$totalPlants',
                'local_florist',
                AppTheme.getSuccessColor(true),
              ),
            ),
            Container(
              width: 1,
              height: 6.h,
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
            Expanded(
              child: _buildStatItem(
                'Olgun Bitki',
                '$fullyGrownPlants',
                'eco',
                AppTheme.lightTheme.primaryColor,
              ),
            ),
            Container(
              width: 1,
              height: 6.h,
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
            Expanded(
              child: _buildStatItem(
                'Toplam Saat',
                '$totalStudyHours',
                'schedule',
                AppTheme.getWarningColor(true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String title, String value, String iconName, Color color) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 24,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontSize: 10.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGardenGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 2.h,
          childAspectRatio: 0.9,
        ),
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];
          return AnimatedBuilder(
            animation: _growthAnimation,
            builder: (context, child) {
              return _buildPlantCard(plant, index);
            },
          );
        },
      ),
    );
  }

  Widget _buildPlantCard(Map<String, dynamic> plant, int index) {
    final growthLevel = (plant["growthLevel"] as num).toDouble();
    final maxGrowth = (plant["maxGrowth"] as num).toDouble();
    final growthPercentage = (growthLevel / maxGrowth * 100).round();
    final isSelected = selectedPlantIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlantIndex = isSelected ? -1 : index;
        });
        if (!isSelected) {
          _waterPlant(plant);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? (plant["color"] as Color).withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? plant["color"]
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (plant["color"] as Color).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: (plant["color"] as Color).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
                AnimatedBuilder(
                  animation: _waterAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_waterAnimation.value * 0.2),
                      child: CustomIconWidget(
                        iconName: plant["icon"],
                        color: plant["color"],
                        size: 32,
                      ),
                    );
                  },
                ),
                if (plant["isFullyGrown"] == true)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.getSuccessColor(true),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'check',
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              plant["name"],
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: plant["color"],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 1.h),
            LinearProgressIndicator(
              value: (growthLevel / maxGrowth) * _growthAnimation.value,
              backgroundColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(plant["color"]),
              minHeight: 0.8.h,
              borderRadius: BorderRadius.circular(4),
            ),
            SizedBox(height: 0.5.h),
            Text(
              '$growthPercentage% büyüdü',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 10.sp,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              '${plant["studyHours"]}/${plant["requiredHours"]} saat',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: plant["color"],
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGardenTips() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bahçe İpuçları',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildTipCard(
            'Düzenli Çalışma',
            'Her gün çalışarak bitkilerini büyüt',
            'schedule',
            AppTheme.lightTheme.primaryColor,
          ),
          SizedBox(height: 1.h),
          _buildTipCard(
            'Hedef Tamamlama',
            'Günlük hedefleri tamamlayarak sulama yap',
            'water_drop',
            AppTheme.getSuccessColor(true),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(
      String title, String description, String iconName, Color color) {
    return Container(
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
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 20,
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
        ],
      ),
    );
  }

  void _waterPlant(Map<String, dynamic> plant) {
    _waterAnimationController.reset();
    _waterAnimationController.forward();

    // Show watering feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${plant["name"]} sulandı! 💧'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }

  void _showGardenGuide() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
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
                'Sanal Bahçe Rehberi',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                children: [
                  _buildGuideItem(
                    'Bitki Büyütme',
                    'Her ders için çalışma yaparak bitkilerini büyüt. Daha fazla çalışma, daha hızlı büyüme demek!',
                    'local_florist',
                    AppTheme.getSuccessColor(true),
                  ),
                  _buildGuideItem(
                    'Sulama Sistemi',
                    'Günlük hedeflerini tamamlayarak bitkilerini sula. Düzenli sulama ile bitkiler daha sağlıklı büyür.',
                    'water_drop',
                    AppTheme.lightTheme.primaryColor,
                  ),
                  _buildGuideItem(
                    'Bitki Türleri',
                    'Her ders farklı bir bitki türü. Matematik çiçeği, Türkçe ağacı, Fen filizi ve Sosyal kaktüs!',
                    'eco',
                    AppTheme.getWarningColor(true),
                  ),
                  _buildGuideItem(
                    'Olgunlaşma',
                    'Bitkiler %100 büyüdüğünde olgunlaşır ve özel rozetler kazanırsın. Hedefin tüm bitkileri olgunlaştırmak!',
                    'emoji_events',
                    Color(0xFFFFD700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideItem(
      String title, String description, String iconName, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
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
