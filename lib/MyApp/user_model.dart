import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String _username = '用户01';
  String _avatar = 'assets/mine.jpg';

  String get username => _username;
  String get avatar => _avatar;

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setAvatar(String avatar) {
    _avatar = avatar;
    notifyListeners();
  }
}
