import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_model.dart';

class SettingPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: '修改用户名'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_usernameController.text.isNotEmpty) {
                  Provider.of<User>(context, listen: false)
                      .setUsername(_usernameController.text);
                  Navigator.pop(context);
                }
              },
              child: Text('保存用户名'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<User>(context, listen: false)
                    .setAvatar('assets/new_avatar.jpg'); // 修改头像
                Navigator.pop(context);
              },
              child: Text('更换头像'),
            ),
          ],
        ),
      ),
    );
  }
}
