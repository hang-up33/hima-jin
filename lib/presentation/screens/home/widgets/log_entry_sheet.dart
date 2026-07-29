import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/enums/activity_tag.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/icons/app_icon.dart';

class LogEntrySheet extends StatefulWidget {
  const LogEntrySheet({
    super.key,
    required this.tag,
    required this.onSubmit,
    this.initialNote = '',
    this.initialDurationMinutes = 0,
    this.submitLabel,
  });

  final ActivityTag tag;
  final Future<void> Function(String note, int durationMinutes) onSubmit;
  final String initialNote;
  final int initialDurationMinutes;

  /// Text for the submit button. When null, defaults to the localized
  /// "log it" label.
  final String? submitLabel;

  @override
  State<LogEntrySheet> createState() => _LogEntrySheetState();
}

class _LogEntrySheetState extends State<LogEntrySheet> {
  late final _noteController = TextEditingController(text: widget.initialNote);
  late int _selectedMinutes = widget.initialDurationMinutes;
  bool _submitting = false;

  /// Quick-pick durations in minutes. [plus] marks the "or more" option.
  static const _durationOptions = [
    (minutes: 0, plus: false),
    (minutes: 15, plus: false),
    (minutes: 30, plus: false),
    (minutes: 60, plus: false),
    (minutes: 120, plus: false),
    (minutes: 180, plus: false),
    (minutes: 240, plus: true),
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
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
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
                widget.tag.labelFor(locale),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.durationPrompt,
            style: const TextStyle(
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
                    l10n.durationChip(opt.minutes, plus: opt.plus),
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
              hintText: l10n.noteHint,
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
                widget.submitLabel ?? l10n.logButton,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
