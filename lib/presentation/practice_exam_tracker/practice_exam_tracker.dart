import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/exam_entry_form_widget.dart';
import './widgets/performance_overview_widget.dart';
import './widgets/subject_card_widget.dart';
import './widgets/weak_subjects_analysis_widget.dart';

class PracticeExamTracker extends StatefulWidget {
  const PracticeExamTracker({Key? key}) : super(key: key);

  @override
  State<PracticeExamTracker> createState() => _PracticeExamTrackerState();
}

class _PracticeExamTrackerState extends State<PracticeExamTracker>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Mock data for performance overview
  final Map<String, dynamic> _overviewData = {
    "overallAverage": 72.5,
    "targetAverage": 85.0,
    "trend": "improving",
    "totalExams": 24,
    "lastExamDate": DateTime.now().subtract(const Duration(days: 3)),
  };

  // Mock data for subjects
  final List<Map<String, dynamic>> _subjects = [
    {
      "id": 1,
      "name": "Türkçe",
      "currentScore": 78.5,
      "targetScore": 85.0,
      "trend": "improving",
      "recentScores": [72, 75, 76, 78, 79, 78],
      "examCount": 6,
      "lastExamDate": DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      "id": 2,
      "name": "Matematik",
      "currentScore": 65.2,
      "targetScore": 80.0,
      "trend": "declining",
      "recentScores": [70, 68, 67, 65, 63, 65],
      "examCount": 6,
      "lastExamDate": DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      "id": 3,
      "name": "Fen Bilimleri",
      "currentScore": 82.1,
      "targetScore": 90.0,
      "trend": "stable",
      "recentScores": [80, 82, 81, 83, 82, 82],
      "examCount": 6,
      "lastExamDate": DateTime.now().subtract(const Duration(days: 4)),
    },
    {
      "id": 4,
      "name": "Sosyal Bilimler",
      "currentScore": 74.8,
      "targetScore": 85.0,
      "trend": "improving",
      "recentScores": [68, 70, 72, 74, 76, 75],
      "examCount": 6,
      "lastExamDate": DateTime.now().subtract(const Duration(days: 5)),
    },
  ];

  // Mock data for weak subjects
  final List<Map<String, dynamic>> _weakSubjects = [
    {
      "name": "Matematik",
      "currentScore": 65.2,
      "targetScore": 80.0,
      "priority": "high",
      "recommendations": [
        "Günlük 30 dakika temel matematik problemleri çözün",
        "Zayıf olduğunuz konuları tekrar edin (Geometri, Fonksiyonlar)",
        "Haftalık deneme sınavlarına katılın",
        "Matematik öğretmeninizden ek kaynak isteyin"
      ],
    },
    {
      "name": "Sosyal Bilimler",
      "currentScore": 74.8,
      "targetScore": 85.0,
      "priority": "medium",
      "recommendations": [
        "Tarih konularında kronolojik sıralama çalışın",
        "Coğrafya haritalarını düzenli inceleyin",
        "Güncel olayları takip edin",
        "Özet çıkarma tekniğini kullanın"
      ],
    },
  ];

  // Mock data for recent exams
  final List<Map<String, dynamic>> _recentExams = [
    {
      "id": 1,
      "subject": "Matematik",
      "score": 65.0,
      "questionCount": 40,
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "notes": "Geometri sorularında zorlandım",
    },
    {
      "id": 2,
      "subject": "Türkçe",
      "score": 78.0,
      "questionCount": 40,
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "notes": "Anlam bilgisi konuları iyiydi",
    },
    {
      "id": 3,
      "subject": "Fen Bilimleri",
      "score": 82.0,
      "questionCount": 40,
      "date": DateTime.now().subtract(const Duration(days: 4)),
      "notes": "Fizik sorularında başarılıydım",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Sınav Takibi',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showExamEntryForm,
            icon: CustomIconWidget(
              iconName: 'add',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Genel Bakış'),
            Tab(text: 'Dersler'),
            Tab(text: 'Analiz'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildSubjectsTab(),
          _buildAnalysisTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showExamEntryForm,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
        label: Text(
          'Sınav Ekle',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          PerformanceOverviewWidget(overviewData: _overviewData),
          SizedBox(height: 2.h),
          _buildRecentExamsSection(),
          SizedBox(height: 2.h),
          _buildQuickActionsSection(),
        ],
      ),
    );
  }

  Widget _buildSubjectsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Ders Performansları',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _subjects.length,
            itemBuilder: (context, index) {
              final subject = _subjects[index];
              return SubjectCardWidget(
                subject: subject,
                onTap: () => _showSubjectDetail(subject),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          WeakSubjectsAnalysisWidget(
            weakSubjects: _weakSubjects,
            onSubjectTap: _handleWeakSubjectTap,
          ),
          SizedBox(height: 2.h),
          _buildPerformanceTrendsSection(),
        ],
      ),
    );
  }

  Widget _buildRecentExamsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Son Sınavlar',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to detailed exam history
                },
                child: Text('Tümünü Gör'),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 12.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _recentExams.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final exam = _recentExams[index];
                return _buildRecentExamCard(exam);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentExamCard(Map<String, dynamic> exam) {
    final subject = exam['subject'] as String? ?? 'Bilinmeyen';
    final score = (exam['score'] as num?)?.toDouble() ?? 0.0;
    final date = exam['date'] as DateTime? ?? DateTime.now();

    return Container(
      width: 40.w,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          Text(
            '${score.toStringAsFixed(0)} puan',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          const Spacer(),
          Text(
            '${date.day}/${date.month}/${date.year}',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hızlı İşlemler',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'Tam Sınav Ekle',
                  'Tüm dersleri içeren sınav sonucu girin',
                  'quiz',
                  AppTheme.lightTheme.colorScheme.primary,
                  () => _showFullExamEntry(),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildQuickActionCard(
                  'Detaylı Analiz',
                  'Performans raporunuzu görüntüleyin',
                  'analytics',
                  AppTheme.lightTheme.colorScheme.secondary,
                  () => _showDetailedAnalysis(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    String description,
    String iconName,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 24,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
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
    );
  }

  Widget _buildPerformanceTrendsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performans Trendleri',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          _buildTrendItem('Genel ortalama son 2 haftada 3.2 puan arttı',
              'trending_up', AppTheme.getSuccessColor(true)),
          SizedBox(height: 1.h),
          _buildTrendItem('Matematik performansı dikkat gerektiriyor',
              'warning', AppTheme.getWarningColor(true)),
          SizedBox(height: 1.h),
          _buildTrendItem('Fen Bilimleri en istikrarlı dersiniz', 'star',
              AppTheme.lightTheme.colorScheme.primary),
        ],
      ),
    );
  }

  Widget _buildTrendItem(String text, String iconName, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(1.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 16,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            text,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  void _showExamEntryForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExamEntryFormWidget(
        onSubmit: _handleExamSubmit,
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _showSubjectDetail(Map<String, dynamic> subject) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(subject['name'] as String? ?? 'Ders Detayı'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Mevcut Ortalama: ${(subject['currentScore'] as num?)?.toStringAsFixed(1) ?? '0.0'}'),
            Text(
                'Hedef: ${(subject['targetScore'] as num?)?.toStringAsFixed(0) ?? '0'}'),
            Text(
                'Sınav Sayısı: ${(subject['examCount'] as num?)?.toString() ?? '0'}'),
            Text(
                'Trend: ${_getTrendText(subject['trend'] as String? ?? 'stable')}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kapat'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showExamEntryForm();
            },
            child: Text('Sınav Ekle'),
          ),
        ],
      ),
    );
  }

  void _handleWeakSubjectTap(String subjectName) {
    final subject = _subjects.firstWhere(
      (s) => (s['name'] as String?) == subjectName,
      orElse: () => {'name': subjectName},
    );
    _showSubjectDetail(subject);
  }

  void _handleExamSubmit(Map<String, dynamic> examData) {
    Navigator.pop(context);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sınav sonucu başarıyla kaydedildi!'),
        backgroundColor: AppTheme.getSuccessColor(true),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Here you would typically save the data to local storage or send to API
    setState(() {
      // Update mock data with new exam result
      _recentExams.insert(0, {
        "id": _recentExams.length + 1,
        "subject": examData['subject'],
        "score": examData['score'],
        "questionCount": examData['questionCount'],
        "date": examData['date'],
        "notes": examData['notes'],
      });

      // Keep only last 5 recent exams
      if (_recentExams.length > 5) {
        _recentExams.removeLast();
      }
    });
  }

  void _showFullExamEntry() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tam Sınav Girişi'),
        content: Text(
            'Bu özellik yakında eklenecek. Tüm derslerin sonuçlarını tek seferde girebileceksiniz.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showDetailedAnalysis() {
    Navigator.pushNamed(context, '/progress-analytics');
  }

  String _getTrendText(String trend) {
    switch (trend) {
      case 'improving':
        return 'Yükseliş';
      case 'declining':
        return 'Düşüş';
      default:
        return 'Sabit';
    }
  }
}
