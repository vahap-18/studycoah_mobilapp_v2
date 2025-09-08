import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExamEntryFormWidget extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>) onSubmit;
  final VoidCallback onCancel;

  const ExamEntryFormWidget({
    Key? key,
    this.initialData,
    required this.onSubmit,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<ExamEntryFormWidget> createState() => _ExamEntryFormWidgetState();
}

class _ExamEntryFormWidgetState extends State<ExamEntryFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _scoreController = TextEditingController();
  final _questionCountController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedSubject = 'Türkçe';

  final List<String> _subjects = [
    'Türkçe',
    'Matematik',
    'Fen Bilimleri',
    'Sosyal Bilimler',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _scoreController.text =
          (widget.initialData!['score'] as num?)?.toString() ?? '';
      _questionCountController.text =
          (widget.initialData!['questionCount'] as num?)?.toString() ?? '';
      _notesController.text = widget.initialData!['notes'] as String? ?? '';
      _selectedSubject = widget.initialData!['subject'] as String? ?? 'Türkçe';
      _selectedDate =
          widget.initialData!['date'] as DateTime? ?? DateTime.now();
    }
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _questionCountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sınav Sonucu Ekle',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  onPressed: widget.onCancel,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            _buildSubjectSelector(),
            SizedBox(height: 2.h),
            _buildDateSelector(),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildScoreField(),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildQuestionCountField(),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildNotesField(),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    child: Text('İptal'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Kaydet'),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ders',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedSubject,
              isExpanded: true,
              items: _subjects.map((subject) {
                return DropdownMenuItem<String>(
                  value: subject,
                  child: Text(
                    subject,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedSubject = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sınav Tarihi',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Puan',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _scoreController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            hintText: '0-100',
            suffixText: 'puan',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Puan giriniz';
            }
            final score = double.tryParse(value);
            if (score == null || score < 0 || score > 100) {
              return '0-100 arası değer giriniz';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildQuestionCountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Soru Sayısı',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _questionCountController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintText: '40',
            suffixText: 'soru',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Soru sayısı giriniz';
            }
            final count = int.tryParse(value);
            if (count == null || count <= 0 || count > 200) {
              return '1-200 arası değer giriniz';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notlar (İsteğe Bağlı)',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Sınav koşulları, zorlanılan konular vb.',
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: AppTheme.lightTheme.colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'subject': _selectedSubject,
        'score': double.parse(_scoreController.text),
        'questionCount': int.parse(_questionCountController.text),
        'date': _selectedDate,
        'notes': _notesController.text.trim(),
        'timestamp': DateTime.now(),
      };

      widget.onSubmit(data);
    }
  }
}
