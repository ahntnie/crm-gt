part of '../core.dart';

abstract class CoreState extends Equatable {
  final AppTheme theme;
  final AppThemeMode themeMode;

  const CoreState({
    required this.theme,
    required this.themeMode,
  });
}
