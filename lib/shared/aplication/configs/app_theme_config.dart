import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppThemeConfig {
  ThemeData get theme => ThemeData(
        hoverColor: Colors.transparent,
        // highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        fontFamily: 'Raleway',
        colorScheme: _colorScheme,
        textTheme: _textTheme,
        appBarTheme: _appBarTheme,

        scaffoldBackgroundColor: Color(0xffFFFFFF),
      );

  AppBarTheme get _appBarTheme => const AppBarTheme(
        color: Color(0xffFFFFFF),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(
          size: 20,
        ),
      );

  ColorScheme get _colorScheme => ColorScheme.fromSeed(
        seedColor: Color(0xff053D31),
        // ignore: deprecated_member_use
        background: Color(0xffFFFFFF),
        // ignore: deprecated_member_use
        onBackground: Color(0xff1A1E25),
        inverseSurface: Color(0xffF6F6F6),
        primary: Color(0xff126856),
        secondary: Color(0xff727272),
        onPrimary: Color(0xffFFFFFF),
        surface: Color(0xffDFF1ED),
        onSurface: Color(0xff1A1E25),
        error: Color(0xffDF4646),
        brightness: Brightness.light,
        tertiary: Color(0xff053D31),
      );

  TextTheme get _textTheme => TextTheme(
        displayLarge: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: Color(0xff1A1E25),
          letterSpacing: 0,
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
          letterSpacing: 0,
          color: Color(0XFF1A1E25),
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
          color: Color(0xff1A1E25),
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          color: Color(0XFF1A1E25),
          letterSpacing: 0,
        ),
        titleSmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12.sp,
          color: Color(0XFF727272),
          letterSpacing: 0,
        ),
        bodyLarge: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
          letterSpacing: 0,
          height: 1.5,
          color: Color(0XFF727272),
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
          letterSpacing: 0,
          color: Color(0XFf1A1E25),
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
          letterSpacing: 0,
          color: Color(0XFF1A1E25),
        ),
        labelSmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13.sp,
          letterSpacing: 0,
          color: Color(0XFF727272),
        ),
      );
}
