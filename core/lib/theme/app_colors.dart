part of '../core.dart';

class AppColors {
  final Color transparent = Colors.transparent;
  final Color black;
  final Color white;
  final Color primary;
  final Color textLabel;
  final Color neutralDark13;
  final Color error;
  final Color gray700;
  final Color neutral10;
  final Color red;
  final Color enableTextColor;
  final Color background;
  final Color gray400;
  final Color btnSecondary;
  final Color neutral13;
  final Color disabled;
  final Color btnBorderSecondary;
  final Color yellow;
  final Color green;
  final Color label;
  final Color bgUnit;
  final Color contentText;

  const AppColors({
    required this.white,
    required this.black,
    required this.primary,
    required this.textLabel,
    required this.neutralDark13,
    required this.error,
    required this.gray700,
    required this.neutral10,
    required this.red,
    required this.enableTextColor,
    required this.background,
    required this.gray400,
    required this.btnSecondary,
    required this.neutral13,
    required this.disabled,
    required this.btnBorderSecondary,
    required this.yellow,
    required this.green,
    required this.label,
    required this.bgUnit,
    required this.contentText,
  });

  factory AppColors.light() {
    return const AppColors(
      white: Color(0xffffffff),
      black: Color(0xff000000),
      primary: Color(0xff3180e8),
      textLabel: Color(0xff646464),
      neutralDark13: Color(0xFF323E44),
      error: Color(0xffE2331F),
      gray700: Color(0xff646464),
      neutral10: Color(0xFF5C717C),
      red: Color(0xffE20000),
      enableTextColor: Color(0xffC7D0D5),
      background: Color(0xffF8F9FE),
      gray400: Color(0xffD8D8D8),
      btnSecondary: Color(0xFF5C717C),
      neutral13: Color(0xFF323E44),
      disabled: Color(0xffA1B1BA),
      btnBorderSecondary: Color(0xFFD9E0E3),
      yellow: Color(0xffF89500),
      green: Color(0xff00AF31),
      label: Color(0xff414141),
      bgUnit: Color(0x0066CC0D),
      contentText: Color(0xff212121),
    );
  }

  factory AppColors.dark() {
    return const AppColors(
      white: Color(0xffffffff),
      black: Color(0xff000000),
      primary: Color(0xff3180e8),
      textLabel: Color(0xff646464),
      neutralDark13: Color(0xFF323E44),
      error: Color(0xffE2331F),
      gray700: Color(0xff646464),
      neutral10: Color(0xFF5C717C),
      red: Color(0xffE20000),
      enableTextColor: Color(0xffC7D0D5),
      background: Color(0xffF8F9FE),
      gray400: Color(0xffD8D8D8),
      btnSecondary: Color(0xFF5C717C),
      neutral13: Color(0xFF323E44),
      disabled: Color(0xffA1B1BA),
      btnBorderSecondary: Color(0xFFD9E0E3),
      yellow: Color(0xffF89500),
      green: Color(0xff00AF31),
      label: Color(0xff414141),
      bgUnit: Color(0x0066CC0D),
      contentText: Color(0xff212121),
    );
  }
}
