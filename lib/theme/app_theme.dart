// import 'package:flutter/material.dart';
//
// class AppColors {
//   static const primary = Color(0xFF6C63FF);
//   static const primaryDark = Color(0xFF4B44CC);
//   static const secondary = Color(0xFF03DAC6);
//   static const background = Color(0xFFF8F9FF);
//   static const surface = Color(0xFFFFFFFF);
//   static const error = Color(0xFFE53935);
//   static const success = Color(0xFF43A047);
//   static const textPrimary = Color(0xFF1A1A2E);
//   static const textSecondary = Color(0xFF6B7280);
//   static const cardBg = Color(0xFFFFFFFF);
//   static const borderColor = Color(0xFFE5E7EB);
// }
//
// class AppTheme {
//   static ThemeData get theme => ThemeData(
//     useMaterial3: true,
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: AppColors.primary,
//       primary: AppColors.primary,
//       secondary: AppColors.secondary,
//       surface: AppColors.surface,
//       error: AppColors.error,
//     ),
//     fontFamily: 'Poppins',
//     scaffoldBackgroundColor: AppColors.background,
//     appBarTheme: const AppBarTheme(
//       backgroundColor: AppColors.surface,
//       foregroundColor: AppColors.textPrimary,
//       elevation: 0,
//       centerTitle: false,
//       titleTextStyle: TextStyle(
//         fontFamily: 'Poppins',
//         fontSize: 20,
//         fontWeight: FontWeight.w700,
//         color: AppColors.textPrimary,
//       ),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         minimumSize: const Size(double.infinity, 52),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//         textStyle: const TextStyle(
//           fontFamily: 'Poppins',
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//         ),
//         elevation: 0,
//       ),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: AppColors.surface,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: AppColors.borderColor),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: AppColors.borderColor),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: AppColors.primary, width: 2),
//       ),
//       labelStyle: const TextStyle(color: AppColors.textSecondary, fontFamily: 'Poppins'),
//       hintStyle: const TextStyle(color: AppColors.textSecondary, fontFamily: 'Poppins'),
//     ),
//     cardTheme: CardThemeData(
//       color: AppColors.cardBg,
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: const BorderSide(color: AppColors.borderColor),
//       ),
//     ),
//   );
// }
// import 'package:flutter/material.dart';
//
// class AppColors {
//   static const primary = Color(0xFF7C5CFC);
//   static const primaryDark = Color(0xFF5B3FE0);
//   static const secondary = Color(0xFF00E5C7);
//   static const accent = Color(0xFFFF6B9D);
//   static const accentOrange = Color(0xFFFFA451);
//   static const background = Color(0xFFF7F6FF);
//   static const surface = Color(0xFFFFFFFF);
//   static const error = Color(0xFFFF5A5F);
//   static const success = Color(0xFF2ED573);
//   static const textPrimary = Color(0xFF1E1B2E);
//   static const textSecondary = Color(0xFF7A7688);
//   static const cardBg = Color(0xFFFFFFFF);
//   static const borderColor = Color(0xFFEDEBFA);
//
//   static const primaryGradient = LinearGradient(
//     colors: [Color(0xFF7C5CFC), Color(0xFF9F7EFF)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );
//
//   static const sunsetGradient = LinearGradient(
//     colors: [Color(0xFFFF6B9D), Color(0xFFFFA451)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );
//
//   static const oceanGradient = LinearGradient(
//     colors: [Color(0xFF00E5C7), Color(0xFF7C5CFC)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );
// }
//
// class AppTheme {
//   static ThemeData get theme => ThemeData(
//     useMaterial3: true,
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: AppColors.primary,
//       primary: AppColors.primary,
//       secondary: AppColors.secondary,
//       surface: AppColors.surface,
//       error: AppColors.error,
//     ),
//     fontFamily: 'Poppins',
//     scaffoldBackgroundColor: AppColors.background,
//     pageTransitionsTheme: const PageTransitionsTheme(
//       builders: {
//         TargetPlatform.android: _FadeThroughTransitionsBuilder(),
//         TargetPlatform.iOS: _FadeThroughTransitionsBuilder(),
//       },
//     ),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.transparent,
//       foregroundColor: AppColors.textPrimary,
//       elevation: 0,
//       centerTitle: false,
//       titleTextStyle: TextStyle(
//         fontFamily: 'Poppins',
//         fontSize: 21,
//         fontWeight: FontWeight.w800,
//         color: AppColors.textPrimary,
//       ),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         minimumSize: const Size(double.infinity, 54),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//         textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700),
//         elevation: 4,
//         shadowColor: AppColors.primary.withOpacity(0.4),
//       ),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: AppColors.surface,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(color: AppColors.borderColor),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(color: AppColors.primary, width: 2),
//       ),
//     ),
//     cardTheme: CardThemeData(
//       color: AppColors.cardBg,
//       elevation: 6,
//       shadowColor: Colors.black.withOpacity(0.06),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//     ),
//   );
// }
//
// class _FadeThroughTransitionsBuilder extends PageTransitionsBuilder {
//   const _FadeThroughTransitionsBuilder();
//   @override
//   Widget buildTransitions<T>(
//       PageRoute<T> route,
//       BuildContext context,
//       Animation<double> animation,
//       Animation<double> secondaryAnimation,
//       Widget child,
//       ) {
//     return FadeTransition(
//       opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
//       child: SlideTransition(
//         position: Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero)
//             .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
//         child: child,
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF7C5CFC);
  static const primaryDark = Color(0xFF5B3FE0);
  static const secondary = Color(0xFF00E5C7);
  static const accent = Color(0xFFFF6B9D);
  static const accentOrange = Color(0xFFFFA451);
  static const background = Color(0xFFF7F6FF);
  static const surface = Color(0xFFFFFFFF);
  static const error = Color(0xFFFF5A5F);
  static const success = Color(0xFF2ED573);
  static const textPrimary = Color(0xFF1E1B2E);
  static const textSecondary = Color(0xFF7A7688);
  static const cardBg = Color(0xFFFFFFFF);
  static const borderColor = Color(0xFFEDEBFA);

  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF7C5CFC), Color(0xFF9F7EFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF6B9D), Color(0xFFFFA451)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const oceanGradient = LinearGradient(
    colors: [Color(0xFF00E5C7), Color(0xFF7C5CFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 21,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700),
        elevation: 4,
        shadowColor: AppColors.primary.withOpacity(0.4),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBg,
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}