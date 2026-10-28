import 'package:flutter/material.dart';
import 'package:nuclear_quizdefinitivo/theme/app_theme.dart';

/// Faixa superior com gradiente e cantos inferiores arredondados.
class GradientHeader extends StatelessWidget {
  final Widget child;

  const GradientHeader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.s,
        AppSpacing.l,
        28,
      ),
      decoration: const BoxDecoration(
        gradient: AppTheme.heroGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: child,
    );
  }
}
