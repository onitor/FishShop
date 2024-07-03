import 'package:flutter/material.dart';

class PlatformTheme {
  static ThemeData iOS = ThemeData(
    primaryColor: Colors.grey[100],
    primarySwatch: Colors.blue,
    brightness: Brightness.light,  // 使用 brightness 代替 primaryColorBrightness
  );

  static ThemeData android = ThemeData(
    primaryColor: Colors.white, // 主题色
    scaffoldBackgroundColor: Colors.grey[200], // 背景色
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.purple,
      accentColor: Colors.deepOrangeAccent,
    ).copyWith(secondary: Colors.deepOrangeAccent), // 强调颜色
    secondaryHeaderColor: Colors.white70, // 次标题颜色
  );
}
