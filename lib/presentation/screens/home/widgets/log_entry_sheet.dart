import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/enums/activity_tag.dart';
import '../../../widgets/icons/app_icon.dart';

class LogEntrySheet extends StatefulWidget {
  const LogEntrySheet({
    super.key,
    required this.tag,
    required this.onSubmit,
    this.initialNote = '',
    this.initialDurationMinutes = 0,
    this.submitLabel = '記録する',
  });

  final ActivityTag tag;
  final Future<void> Function(String note, int durationMinutes) onSubmit;
  final String initialNote;
  final int initialDurationMinutes;
  final String submitLabel;

  @override
  State<LogEntrySheet> createState() => _LogEntrySheetState();
}

class _LogEntrySheetState extends State<LogEntrySheet> {
  late final _noteController = TextEditingController(text: widget.initialNote);
  late int _selectedMinutes = widget.initialDurationMinutes;
  bool _submitting = false;

  static const _durationOptions = [
    (label: '未設定', minutes: 0),
    (label: '15分', minutes: 15),
    (label: '30分', minutes: 30),
    (label: '1時間', minutes: 60),
    (label: '2時間', minutes: 120),
    (label: '3時間', minutes: 180),
    (label: '4時間+', minutes: 240),
  ];

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    Navigator.of(context).pop();
    await widget.onSubmit(_noteController.text.trim(), _selectedMinutes);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              AppIcon(widget.tag.icon, size: 32, color: AppColors.textPrimary),
              const SizedBox(width: 12),
              Text(
                widget.tag.label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'どのくらい？',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _durationOptions.map((opt) {
              final selected = _selectedMinutes == opt.minutes;
              return GestureDetector(
                onTap: () => setState(() => _selectedMinutes = opt.minutes),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : AppColors.textSecondary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    opt.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: selected ? AppColors.onPrimary : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(
              hintText: 'メモ（任意）',
              hintStyle:
                  TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.6)),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: const Key('log_submit_button'),
              onPressed: _submitting ? null : _submit,
              child: Text(
                widget.submitLabel,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
