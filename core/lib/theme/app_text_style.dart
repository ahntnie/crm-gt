part of '../core.dart';

final class AppTextStyle {
  // Singleton
  static final AppTextStyle _singleton = AppTextStyle._internal();

  factory AppTextStyle() {
    return _singleton;
  }

  AppTextStyle._internal();

  ThemeMode _themeMode = ThemeMode.light;

  factory AppTextStyle.of(ThemeMode themeMode) {
    _singleton._themeMode = themeMode;
    return _singleton;
  }

  /// S10
  TextStyle get s10w400 => TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  TextStyle get s10w600 => TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  TextStyle get s10wBold => TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  /// S12
  TextStyle get s12w400 => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  TextStyle get s12w600 => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  TextStyle get s12wBold => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  /// S14
  TextStyle get s14w400 => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  TextStyle get s14w500 => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  TextStyle get s14w600 => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  TextStyle get s14wBold => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  /// S15
  TextStyle get s15w400 => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  TextStyle get s15w500 => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  TextStyle get s15w600 => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  TextStyle get s15wBold => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  /// S16
  TextStyle get s16w400 => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  TextStyle get s16w600 => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  TextStyle get s16wBold => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  /// S20
  TextStyle get s20w400 => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  TextStyle get s20w600 => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );

  TextStyle get s20wBold => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppTheme.of(_themeMode).colors.black,
        fontFamily: 'SF Pro Display',
      );
}

extension TextStyleExt on TextStyle {
  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withFontWeight(FontWeight fontWeight) => copyWith(fontWeight: fontWeight);
}
