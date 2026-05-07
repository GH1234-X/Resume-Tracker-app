import 'package:flutter/material.dart';
import 'utils/status_colors.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.accent,
    surface: AppColors.surface,
    background: AppColors.background,
    error: AppColors.statusRejected,
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: false,
    elevation: 0,
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.primary,
    titleTextStyle: TextStyle(
      color: AppColors.primary,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.border, width: 1),
    ),
    margin: EdgeInsets.zero,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.accent, width: 2),
    ),
    filled: true,
    fillColor: AppColors.surface,
    labelStyle: const TextStyle(color: AppColors.secondaryText),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.accent,
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.accent,
    foregroundColor: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(color: AppColors.primary),
    bodyMedium: TextStyle(color: AppColors.secondaryText),
  ),
);
