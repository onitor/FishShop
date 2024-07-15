
import 'package:codes/FishShopping/utils/PlatformTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:codes/FishShopping/Home/FSHomePage.dart';
import 'package:codes/FishShopping/Message/FSMessagePage.dart';
import 'package:codes/FishShopping/Mine/FSMinePage.dart';
import 'package:codes/FishShopping/Pond/FSPondPage.dart';
import 'package:codes/FishShopping/Post/FSPostPage.dart';

class FishApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fish",
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? PlatformTheme.iOS
          : PlatformTheme.android, // 根据平台选则
      home: FishHome(),
    );
  }
}

class FishHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FishHomeState();
  }
}

class _FishHomeState extends State<FishHome> {

  int _tabIndex = 0;
  PageController ?_pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _tabIndex, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        physics: NeverScrollableScrollPhysics(), // 禁止滑动
      ),
      floatingActionButton: circleButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        inactiveColor: normalColor,
        activeColor: normalColor,
        items: _bottomNaviItems(),
        currentIndex: _tabIndex,
        onTap: didSelectedIndex,
      ),
    );
  }

  didSelectedIndex(int index) {
    setState(() {
      _tabIndex = index;
      _pageController?.jumpToPage(index);
    });
  }

  void didTapPost() {
    // 无动画的切换
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => FSPostPage(),
        )
    );
  }

  Widget circleButton() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.all(6),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: CircleBorder(),
              backgroundColor: Colors.yellow, // 按钮背景颜色
              foregroundColor: Colors.black, // 按钮前景颜色
              splashFactory: NoSplash.splashFactory, // 取消水波效果
            ),
            child: Icon(
              Icons.add,
              color: Colors.black,
              size: 40,
            ),
            onPressed: () {
              //didSelectedIndex(2);
              didTapPost();
            },
          ),
        ),
      ),
    );
  }


  // Pages
  List<StatefulWidget> _pages = [
    FSHomePage(),     // 首页
    FSPondPage(),     // 鱼塘
    FSPostPage(),     // 发布
    FSMessagePage(),  // 消息
    FSMinePage(),     // 我的
    //FSHomeX(),
  ];

  static final Color normalColor = Colors.black;
  static final Color selectColor = Colors.yellow;

  List<Icon> _tabImages = [
    Icon(Icons.home, size: 25.0, color: normalColor,),
    Icon(Icons.category, size: 25.0, color: normalColor,),
    Icon(null, size: 25.0, color: normalColor,),
    Icon(Icons.notifications, size: 25.0, color: normalColor,),
    Icon(Icons.person, size: 25.0, color: normalColor,),
  ];

  List<Icon> _tabSelectedImages = [
    Icon(Icons.home, size: 25.0, color: selectColor,),
    Icon(Icons.category, size: 25.0, color: selectColor,),
    Icon(null, size: 25.0, color: selectColor,),
    Icon(Icons.notifications, size: 25.0, color: selectColor,),
    Icon(Icons.person, size: 25.0, color: selectColor,),
  ];

  // BottomNaviItem
  List<BottomNavigationBarItem> _bottomNaviItems() {
    return [
      BottomNavigationBarItem(icon: getTabIcon(0), label: "首页"),
      BottomNavigationBarItem(icon: getTabIcon(1), label: "分类"),
      BottomNavigationBarItem(icon: getTabIcon(2), label: "发布"),
      BottomNavigationBarItem(icon: getTabIcon(3), label: "消息"),
      BottomNavigationBarItem(icon: getTabIcon(4), label: "我的"),
    ];
  }

  Icon getTabIcon(int index) {
    if (index == _tabIndex) {
      return _tabSelectedImages[index];
    } else {
      return _tabImages[index];
    }
  }
}
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FishApp(),
    );
  }
}

