import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'order_provider.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'setting_page.dart';
import 'user_model.dart';  // 导入User模型

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => User()),
      ],
      child: OrderProvider(
        child: MaterialApp(
          title: '跨境电商APP',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => LoginPage(),
            '/home': (context) => HomePage(),
            '/profile': (context) => ProfilePage(),
            '/settings': (context) => SettingPage(),
          },
        ),
      ),
    );
  }
}
