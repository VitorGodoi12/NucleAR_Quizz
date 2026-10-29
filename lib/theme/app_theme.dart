import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Paleta única do app: todas as telas usam estas cores.
class AppColors {
  static const navy = Color(0xFF0B2545);
  static const blue = Color(0xFF13497A);
  static const cyan = Color(0xFF12A9C9);
  static const cyanBg = Color(0xFFE0F4F8);
  static const background = Color(0xFFF4F7FB);
  static const text = Color(0xFF1B2A3B);
  static const muted = Color(0xFF5B6B7F);
  static const border = Color(0xFFD5DEE9);
  static const success = Color(0xFF2E9E5B);
  static const successBg = Color(0xFFE3F6EA);
  static const error = Color(0xFFD64545);
  static const errorBg = Color(0xFFFBE6E6);
  static const gold = Color(0xFFF2B01E);
  static const silver = Color(0xFF9AA7B5);
  static const bronze = Color(0xFFC07A3B);

  // Cor de cada área de aplicação (usadas nas competições e na Home).
  static const health = Color(0xFF0E9AA7);
  static const agro = Color(0xFF3C9D4E);
  static const industry = Color(0xFFE08A1E);
  static const energy = Color(0xFF3D5AFE);
}

/// Espaçamentos padrão.
class AppSpacing {
  static const double s = 8;
  static const double m = 16;
  static const double l = 24;
}

/// Versão bem clara de uma cor, usada em fundos de destaque.
Color tintOf(Color color) =>
    Color.alphaBlend(color.withAlpha(28), Colors.white);

/// Decoração padrão de cartões brancos com sombra suave.
BoxDecoration appCardDecoration({Color borderColor = AppColors.border}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: borderColor.withAlpha(190)),
    boxShadow: const [
      BoxShadow(color: Color(0x100B2545), blurRadius: 24, offset: Offset(0, 8)),
    ],
  );
}

class AppTheme {
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.navy, AppColors.blue],
  );

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      visualDensity: VisualDensity.standard,
      fontFamily: 'Roboto',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navy,
        primary: AppColors.navy,
        secondary: AppColors.cyan,
      ),
      scaffoldBackgroundColor: AppColors.background,
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.cyanBg,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        elevation: 8,
        shadowColor: const Color(0x140B2545),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? AppColors.navy
                : AppColors.muted,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.blue,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          side: const BorderSide(color: AppColors.navy, width: 1.5),
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

/// Estilo padrão dos campos de formulário.
InputDecoration appInput(String label, IconData icon, {Widget? suffix}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    suffixIcon: suffix,
    filled: true,
    fillColor: AppColors.background,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.cyan, width: 2),
    ),
  );
}
