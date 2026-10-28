import 'package:flutter/material.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';

/// Alternativa de resposta do quiz. O visual muda conforme o estado.
class AnswerOption extends StatelessWidget {
  final String letter;
  final String text;
  final bool selected;
  final bool showCorrect;
  final bool showWrong;
  final VoidCallback? onTap;

  const AnswerOption({
    super.key,
    required this.letter,
    required this.text,
    required this.selected,
    required this.showCorrect,
    required this.showWrong,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.border;
    Color background = Colors.white;
    IconData? trailing;

    if (showCorrect) {
      borderColor = AppColors.success;
      background = AppColors.successBg;
      trailing = Icons.check_circle_rounded;
    } else if (showWrong) {
      borderColor = AppColors.error;
      background = AppColors.errorBg;
      trailing = Icons.cancel_rounded;
    } else if (selected) {
      borderColor = AppColors.cyan;
      background = AppColors.cyanBg;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.8),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x1812A9C9),
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ]
              : const [],
        ),
        child: Material(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: borderColor,
                    ),
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: borderColor == AppColors.border
                            ? AppColors.text
                            : Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: trailing == null
                        ? const SizedBox(
                            key: ValueKey('empty'),
                            width: 24,
                            height: 24,
                          )
                        : Icon(
                            trailing,
                            key: ValueKey<IconData>(trailing),
                            color: borderColor,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
