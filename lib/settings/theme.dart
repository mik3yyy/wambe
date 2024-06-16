import 'package:flutter/material.dart';
import 'package:wambe/settings/palette.dart';
part 'text_styles.dart';
part 'colors.dart';
part 'fonts.dart';
part 'app_colors.dart';

final ThemeData appThemeData = ThemeData(
  brightness: Brightness.light,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Palette.purple),
  ),
  fontFamily: 'Inter',
  buttonTheme: const ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
  ),
  primaryColor: Palette.purple,
  primarySwatch: Colors.blue,
  buttonBarTheme: const ButtonBarThemeData(
    buttonTextTheme: ButtonTextTheme.primary,
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Palette.white,
  ),
  listTileTheme: ListTileThemeData(
    textColor: Palette.black,
    selectedColor: Palette.grey,
    titleTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Palette.black,
    ),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
        color: Palette.black),
    titleMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Palette.black),
    titleSmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
        color: Palette.black),
    bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: Palette.black),
    bodySmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 10.0,
        fontWeight: FontWeight.w400,
        color: Palette.black),
  ),
  snackBarTheme: SnackBarThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    behavior: SnackBarBehavior.floating,
    contentTextStyle: _AppTextStyles.bodyMedium,
    insetPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Palette.black,
  ),
  appBarTheme: AppBarTheme(foregroundColor: Palette.black),
  colorScheme: ColorScheme(
    primary: Palette.purple,
    secondary: Palette.white,
    tertiary: Palette.black,
    surface: Colors.white,
    background: Colors.white,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Palette.darkPurple,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
);
