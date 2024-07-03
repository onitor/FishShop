import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_model.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Consumer<User>(
                    builder: (context, user, child) {
                      return CircleAvatar(
                        radius: 100,
                        backgroundImage: AssetImage(user.avatar), // 使用用户头像
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Consumer<User>(
                    builder: (context, user, child) {
                      return Text(
                        user.username, // 使用用户名
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('设置'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('关于'),
              onTap: () {
                // 处理点击事件
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('退出登录'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
