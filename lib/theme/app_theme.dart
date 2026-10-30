import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Paleta única do app: todas as telas usam estas cores.
class AppColors {
  static const navy = Color(0xFF102F4F);
  static const blue = Color(0xFF174B75);
  static const cyan = Color(0xFF007D96);
  static const cyanBg = Color(0xFFDDF3F6);
  static const background = Color(0xFFF4F7FB);
  static const text = Color(0xFF172A3D);
  static const muted = Color(0xFF4B5F73);
  static const border = Color(0xFFC6D2DE);
  static const success = Color(0xFF217447);
  static const successBg = Color(0xFFE5F4EA);
  static const error = Color(0xFFB4232F);
  static const errorBg = Color(0xFFFCE8E8);
  static const gold = Color(0xFFF2B01E);
  static const silver = Color(0xFF9AA7B5);
  static const bronze = Color(0xFFC07A3B);

  // Cor de cada área de aplicação (usadas nas competições e na Home).
  static const health = Color(0xFF00656F);
  static const agro = Color(0xFF246B38);
  static const industry = Color(0xFF925000);
  static const energy = Color(0xFF3446A0);
}

/// Espaçamentos padrão.
class AppSpacing {
  static const double s = 8;
  static const double m = 16;
  static const double l = 24;
}

/// Versão bem clara de uma cor, usada em fundos de destaque.
Color tintOf(BuildContext context, Color color) {
  final scheme = Theme.of(context).colorScheme;
  final base = scheme.surfaceContainerHigh;
  return Color.alphaBlend(color.withAlpha(32), base);
}

Color semanticStatusColor(BuildContext context, {required bool success}) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return success ? const Color(0xFF72D99A) : const Color(0xFFFF8585);
  }
  return success ? AppColors.success : AppColors.error;
}

Color accentOnSurface(BuildContext context, Color color) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return Color.lerp(color, Colors.white, 0.42)!;
  }
  return color;
}

/// Decoração de cartão que acompanha a superfície do tema ativo.
BoxDecoration appCardDecoration({
  required BuildContext context,
  Color? borderColor,
}) {
  final colors = Theme.of(context).colorScheme;
  return BoxDecoration(
    color: Theme.of(context).cardTheme.color ?? colors.surface,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: (borderColor ?? colors.outline).withAlpha(190)),
    boxShadow: const [
      BoxShadow(color: Color(0x100B2545), blurRadius: 24, offset: Offset(0, 8)),
    ],
  );
}

class AppTheme {
  static ThemeData get dark {
    const background = Color(0xFF0B1420);
    const surface = Color(0xFF142235);
    const raisedSurface = Color(0xFF1C2D42);
    const foreground = Color(0xFFF2F6FA);
    const secondaryForeground = Color(0xFFC4D0DC);
    const accent = Color(0xFF72D9E8);
    final scheme =
        ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.dark,
          surface: surface,
        ).copyWith(
          primary: accent,
          onPrimary: const Color(0xFF002F38),
          primaryContainer: const Color(0xFF124653),
          onPrimaryContainer: const Color(0xFFCCF5FB),
          secondary: const Color(0xFF8EDCE8),
          onSecondary: const Color(0xFF00363E),
          secondaryContainer: const Color(0xFF1B414B),
          onSecondaryContainer: const Color(0xFFD0F4F8),
          surface: surface,
          onSurface: foreground,
          surfaceContainerLowest: background,
          surfaceContainerLow: const Color(0xFF101C2B),
          surfaceContainer: surface,
          surfaceContainerHigh: raisedSurface,
          surfaceContainerHighest: const Color(0xFF26394F),
          onSurfaceVariant: secondaryForeground,
          outline: const Color(0xFF8292A5),
          outlineVariant: const Color(0xFF405166),
          error: const Color(0xFFFFB4AB),
          onError: const Color(0xFF690005),
          errorContainer: const Color(0xFF93000A),
          onErrorContainer: const Color(0xFFFFDAD6),
        );
    return _base(
      scheme: scheme,
      background: background,
      card: surface,
      bar: const Color(0xFF101B29),
      barForeground: foreground,
      elevated: raisedSurface,
      outlineButton: const Color(0xFF9ADDE7),
      navigationIndicator: const Color(0xFF164653),
    );
  }

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.navy, AppColors.blue],
  );

  static ThemeData get light {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.navy,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.navy,
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFFDCEAF5),
          onPrimaryContainer: AppColors.navy,
          secondary: AppColors.cyan,
          onSecondary: Colors.white,
          secondaryContainer: AppColors.cyanBg,
          onSecondaryContainer: const Color(0xFF064A59),
          surface: Colors.white,
          onSurface: AppColors.text,
          surfaceContainerLowest: Colors.white,
          surfaceContainerLow: const Color(0xFFF8FAFC),
          surfaceContainer: AppColors.background,
          surfaceContainerHigh: const Color(0xFFEDF2F7),
          surfaceContainerHighest: const Color(0xFFE5ECF3),
          onSurfaceVariant: AppColors.muted,
          outline: AppColors.border,
          outlineVariant: const Color(0xFFDCE3EA),
          error: AppColors.error,
          onError: Colors.white,
          errorContainer: AppColors.errorBg,
          onErrorContainer: const Color(0xFF5B1018),
        );
    return _base(
      scheme: scheme,
      background: AppColors.background,
      card: Colors.white,
      bar: AppColors.navy,
      barForeground: Colors.white,
      elevated: Colors.white,
      outlineButton: AppColors.navy,
      navigationIndicator: AppColors.cyanBg,
    );
  }

  static ThemeData _base({
    required ColorScheme scheme,
    required Color background,
    required Color card,
    required Color bar,
    required Color barForeground,
    required Color elevated,
    required Color outlineButton,
    required Color navigationIndicator,
  }) {
    final isDark = scheme.brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      fontFamily: 'Roboto',
      visualDensity: VisualDensity.standard,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bar,
        foregroundColor: barForeground,
        centerTitle: true,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: bar,
        indicatorColor: navigationIndicator,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        elevation: isDark ? 0 : 8,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? barForeground
                : barForeground.withAlpha(190),
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? (isDark ? scheme.primary : const Color(0xFF62D6E7))
                : barForeground.withAlpha(190),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: outlineButton,
          side: BorderSide(color: outlineButton, width: 1.5),
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isDark ? scheme.primary : AppColors.blue,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: elevated,
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        prefixIconColor: scheme.onSurfaceVariant,
        suffixIconColor: scheme.onSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: card,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: card,
        modalBackgroundColor: card,
        showDragHandle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? elevated : AppColors.navy,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dividerColor: scheme.outlineVariant,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
      ),
    );
  }
}

/// Estilo padrão dos campos de formulário.
InputDecoration appInput(
  BuildContext context,
  String label,
  IconData icon, {
  Widget? suffix,
}) {
  final colors = Theme.of(context).colorScheme;
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    suffixIcon: suffix,
    filled: true,
    fillColor: colors.surfaceContainerHighest,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.cyan, width: 2),
    ),
  );
}
