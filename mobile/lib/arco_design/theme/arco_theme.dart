import 'package:flutter/material.dart';

/// Arco Design 颜色令牌
class ArcoColors {
  // Primary
  static const Color primary = Color(0xFF165DFF);
  static const Color primaryHover = Color(0xFF4080FF);
  static const Color primaryActive = Color(0xFF0E42D2);
  static const Color primaryLight = Color(0xFFE8F3FF);
  
  // Success
  static const Color success = Color(0xFF00B42A);
  static const Color successLight = Color(0xFFE8FFEA);
  
  // Warning
  static const Color warning = Color(0xFFFF7D00);
  static const Color warningLight = Color(0xFFFFF7E8);
  
  // Danger
  static const Color danger = Color(0xFFF53F3F);
  static const Color dangerLight = Color(0xFFFFECE8);
  
  // Neutral
  static const Color textPrimary = Color(0xFF1D2129);
  static const Color textSecondary = Color(0xFF4E5969);
  static const Color textTertiary = Color(0xFF86909C);
  static const Color textPlaceholder = Color(0xFFC9CDD4);
  
  static const Color border = Color(0xFFE5E6EB);
  static const Color borderLight = Color(0xFFF2F3F5);
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Colors.white;
  
  // Fill colors
  static const Color fill1 = Color(0xFFF2F3F5);
  static const Color fill2 = Color(0xFFE5E6EB);
  static const Color fill3 = Color(0xFFC9CDD4);
}

/// Arco Design 间距系统 (8px 网格)
class ArcoSpacing {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Arco Design 字体系统
class ArcoTypography {
  static const TextStyle display1 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    height: 1.27,
    color: ArcoColors.textPrimary,
  );
  
  static const TextStyle display2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.33,
    color: ArcoColors.textPrimary,
  );
  
  static const TextStyle title1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: ArcoColors.textPrimary,
  );
  
  static const TextStyle title2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: ArcoColors.textPrimary,
  );
  
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: ArcoColors.textPrimary,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.57,
    color: ArcoColors.textSecondary,
  );
  
  static const TextStyle body3 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.67,
    color: ArcoColors.textTertiary,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: ArcoColors.textTertiary,
  );
}

/// Arco Design 主题
class ArcoTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: ArcoColors.primary,
      scaffoldBackgroundColor: ArcoColors.background,
      colorScheme: ColorScheme.light(
        primary: ArcoColors.primary,
        secondary: Color(0xFF0FC6C2),
        error: ArcoColors.danger,
        surface: ArcoColors.surface,
      ),
      textTheme: TextTheme(
        displayLarge: ArcoTypography.display1,
        displayMedium: ArcoTypography.display2,
        titleLarge: ArcoTypography.title1,
        titleMedium: ArcoTypography.title2,
        bodyLarge: ArcoTypography.body1,
        bodyMedium: ArcoTypography.body2,
        bodySmall: ArcoTypography.body3,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ArcoColors.surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: ArcoTypography.title1,
        foregroundColor: ArcoColors.textPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ArcoColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ArcoSpacing.m,
            vertical: ArcoSpacing.s,
          ),
          minimumSize: Size(0, 32),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ArcoColors.primary,
          side: BorderSide(color: ArcoColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ArcoSpacing.m,
            vertical: ArcoSpacing.s,
          ),
          minimumSize: Size(0, 32),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ArcoColors.primary,
          padding: EdgeInsets.symmetric(
            horizontal: ArcoSpacing.s,
            vertical: ArcoSpacing.xs,
          ),
          minimumSize: Size(0, 32),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ArcoColors.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: ArcoSpacing.s,
          vertical: ArcoSpacing.s,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: ArcoColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: ArcoColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: ArcoColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: ArcoColors.danger),
        ),
        labelStyle: ArcoTypography.body2.copyWith(
          color: ArcoColors.textSecondary,
        ),
        hintStyle: ArcoTypography.body2.copyWith(
          color: ArcoColors.textPlaceholder,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: ArcoColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: ArcoColors.border),
        ),
        margin: EdgeInsets.all(ArcoSpacing.m),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: ArcoSpacing.m,
          vertical: ArcoSpacing.s,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: ArcoColors.border,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ArcoColors.borderLight,
        deleteIconColor: ArcoColors.textTertiary,
        labelStyle: ArcoTypography.body3,
        padding: EdgeInsets.symmetric(
          horizontal: ArcoSpacing.s,
          vertical: ArcoSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ArcoColors.surface,
        selectedItemColor: ArcoColors.primary,
        unselectedItemColor: ArcoColors.textTertiary,
        selectedLabelStyle: ArcoTypography.body3,
        unselectedLabelStyle: ArcoTypography.body3,
        type: BottomNavigationBarType.fixed,
        elevation: 1,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ArcoColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ArcoColors.surface,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ArcoColors.textPrimary,
        contentTextStyle: ArcoTypography.body2.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
