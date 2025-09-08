import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CoachingCardWidget extends StatefulWidget {
  final VoidCallback? onRefresh;

  const CoachingCardWidget({
    Key? key,
    this.onRefresh,
  }) : super(key: key);

  @override
  State<CoachingCardWidget> createState() => _CoachingCardWidgetState();
}

class _CoachingCardWidgetState extends State<CoachingCardWidget> {
  int _currentTipIndex = 0;

  final List<Map<String, dynamic>> _coachingTips = [
    {
      "title": "Pomodoro Tekniği",
      "content":
          "25 dakika odaklanmış çalışma, 5 dakika mola. Bu teknik konsantrasyonunu artırır ve zihinsel yorgunluğu azaltır.",
      "icon": "timer",
      "color": Color(0xFF6366F1),
    },
    {
      "title": "Aktif Tekrar",
      "content":
          "Okuduğun konuları kendi kelimelerinle özetlemeye çalış. Bu yöntem bilgilerin kalıcı hafızaya geçmesini sağlar.",
      "icon": "psychology",
      "color": Color(0xFFEC4899),
    },
    {
      "title": "Zor Konular İlk",
      "content":
          "Günün en verimli saatlerinde zor konulara odaklan. Sabah saatleri genellikle en yüksek konsantrasyon zamanıdır.",
      "icon": "trending_up",
      "color": Color(0xFF10B981),
    },
    {
      "title": "Düzenli Mola",
      "content":
          "Her 90 dakikada bir 15-20 dakika mola ver. Beynin dinlenmesi öğrenme kapasitesini artırır.",
      "icon": "self_improvement",
      "color": Color(0xFFF59E0B),
    },
    {
      "title": "Görsel Öğrenme",
      "content":
          "Karmaşık konuları zihin haritaları ve şemalarla görselleştir. Bu yöntem anlama ve hatırlamayı kolaylaştırır.",
      "icon": "account_tree",
      "color": Color(0xFF8B5CF6),
    },
  ];

  void _refreshTip() {
    setState(() {
      _currentTipIndex = (_currentTipIndex + 1) % _coachingTips.length;
    });
    widget.onRefresh?.call();
  }

  @override
  Widget build(BuildContext context) {
    final currentTip = _coachingTips[_currentTipIndex];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (currentTip["color"] as Color).withValues(alpha: 0.1),
            (currentTip["color"] as Color).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (currentTip["color"] as Color).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.5.w),
                    decoration: BoxDecoration(
                      color: currentTip["color"] as Color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CustomIconWidget(
                      iconName: currentTip["icon"] as String,
                      color: Colors.white,
                      size: 5.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Günün Koçluk İpucu',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        currentTip["title"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: currentTip["color"] as Color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: _refreshTip,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color:
                        (currentTip["color"] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'refresh',
                    color: currentTip["color"] as Color,
                    size: 4.w,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            currentTip["content"] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _coachingTips.length,
              (index) => Container(
                width: 2.w,
                height: 2.w,
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == _currentTipIndex
                      ? currentTip["color"] as Color
                      : (currentTip["color"] as Color).withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
