import 'package:aierp_mobile/core/theme/app_theme.dart';
/// 主题配置 - TDesign 风格
/// 移动端优先设计，Web 端响应式适配

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class AppTheme {
  // 颜色常量
  static const Color brandColor = Color(0x0052D9FF);
  static const Color brandColor1 = Color(0x0052D9FF);
  static const Color brandColor6 = Color(0x00A870FF);
  static const Color brandColor7 = Color(0x0052D9FF);
  static const Color brandColor8 = Color(0xF0F5FF);
  static const Color brandColorLight = Color(0xF0F5FF);
  static const Color errorColor = Color(0xFFFF4D4F);
  static const Color warningColor = Color(0xFFFFB300);
  static const Color successColor = Color(0xFF00A870);
  static const Color borderColor = Color(0xFFE7E7E7);
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textPlaceholder = Color(0xFF999999);
  static const Color bgPage = Color(0xFFF5F5F5);
  static const Color bgContainer = Color(0xFFFFFFFF);
  static const Color bgSecondaryContainer = Color(0xFFF5F5F5);
  static const Color gray5 = Color(0xFFCCCCCC);
  
  // 间距常量
  static const double spacer1 = 4.0;
  static const double spacer2 = 8.0;
  static const double spacer3 = 12.0;
  static const double spacer4 = 16.0;
  static const double spacer5 = 24.0;
  
  // 字体大小常量
  static const double fontSizeXs = 10.0;
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXl = 18.0;
  static const double fontSizeLink = 14.0;
  
  // 圆角常量
  static const double radiusSmall = 4.0;
  static const double radiusDefault = 8.0;
  static const double radiusLarge = 12.0;

  /// TDesign Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: false,
      primaryColor: const Color(0x0052D9FF),
      colorScheme: ColorScheme.light(
        primary: const Color(0x0052D9FF),
        secondary: const Color(0x00A870FF),
        error: const Color(0xFFFF4D4F),
        surface: const Color(0xFFFFFFFF),
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0x0052D9FF),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE7E7E7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE7E7E7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0x0052D9FF)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE7E7E7),
        thickness: 1,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Color(0xFF1C1C1E)),
        displayMedium: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1E)),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
        headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
        headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
        headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E)),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E)),
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E)),
        bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF1C1C1E)),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF666666)),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF999999)),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E)),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF666666)),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Color(0xFF999999)),
      ),
      // TDesign 组件样式 - 通过 TDTheme.defaultTheme() 初始化
      // TDesign Flutter 会自动使用内置主题，无需手动配置 extensions
    );
  }

  /// 获取响应式间距
  static double getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // 移动端：16px，平板/桌面端：24px
    return width < 600 ? 16.0 : 24.0;
  }

  /// 获取响应式卡片宽度
  static double getResponsiveCardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // 移动端：全宽，桌面端：固定宽度
    if (width < 600) return width - 32;
    if (width < 1200) return width / 2 - 48;
    return width / 3 - 72;
  }

  /// 是否为移动端
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  /// 是否为平板
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  /// 是否为桌面端
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  /// 响应式字体大小
  static TextStyle getResponsiveTextStyle(BuildContext context, double baseSize, FontWeight weight) {
    final width = MediaQuery.of(context).size.width;
    final scale = width < 600 ? 1.0 : width < 1200 ? 1.1 : 1.2;
    return TextStyle(fontSize: baseSize * scale, fontWeight: weight);
  }
}

/// TDesign 颜色常量
class TDColors {
  static const brandColor = Color(0x0052D9FF); // 腾讯蓝
  static const errorColor = Color(0xFFFF4D4F); // 错误红
  static const warningColor = Color(0xFFFFB300); // 告警橙
  static const successColor = Color(0xFF00A870); // 成功绿
  
  static const fontGy1 = Color(0xFF1C1C1E); // 文字主色
  static const fontGy2 = Color(0xFF666666); // 文字次色
  static const fontGy3 = Color(0xFF999999); // 文字辅助色
  static const fontGy4 = Color(0xFFCCCCCC); // 文字禁用色
  
  static const bgWhite = Color(0xFFFFFFFF); // 白色背景
  static const bgGray = Color(0xFFF5F5F5); // 灰色背景
  static const bgDark = Color(0xFFEEEEEE); // 深灰背景
  
  static const border = Color(0xFFE7E7E7); // 边框色
  static const divider = Color(0xFFE7E7E7); // 分割线色
}