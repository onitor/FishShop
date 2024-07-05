import 'package:flutter/material.dart';

class FSPostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FSPostPageState();
  }
}

class _FSPostPageState extends State<FSPostPage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  AnimationController? _rotateAnimation;
  Tween<double>? _rotationTween;
  AnimationController? _moveAnimation;
  Animation<EdgeInsets>? movement;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _rotateAnimation = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _rotationTween = Tween(begin: 0.2, end: 0.3);

    //启动动画
    _rotateAnimation!.forward();

    _moveAnimation = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    movement = EdgeInsetsTween(
      begin: EdgeInsets.only(top: 0.0),
      end: EdgeInsets.only(top: 100.0),
    ).animate(
      CurvedAnimation(
        parent: _moveAnimation!,
        curve: Interval(
          0.2,
          0.375,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    _moveAnimation!.forward();
  }

  @override
  void dispose() {
    _rotateAnimation?.dispose();
    _moveAnimation?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Stack(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightGreenAccent, Colors.greenAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                buildHeader(),
                SizedBox(height: 200),
                buildAdSection(),
                SizedBox(height: 20),
                buildSecondaryAdSection(),
                Spacer(),
                buildCloseButton(),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 100, 150, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "来闲鱼 搞点钱！",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '3亿',
                  style:TextStyle(
                    fontSize: 20,
                    color: Colors.red,
            )
                ),
                TextSpan(
                  text: '人在闲鱼赚钱',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  )
                )
              ]
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAdSection() {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.yellow.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildAdItem("发闲置 >", "30s发布宝贝，啥都能换钱", Colors.yellow.shade700, Icons.camera_alt),
          Image.asset(
            'assets/mine.jpg',
            width: 100,
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget buildAdItem(String title, String subtitle, Color color, IconData icon) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSecondaryAdSection() {
    return Column(
      children: <Widget>[
        buildSecondaryAdItem("一键转卖 >", "2年前买的手机耳机还能卖12元", Colors.grey.shade200),
        buildSecondaryAdItem("闲鱼帮卖 >", "支持自己定价卖", Colors.grey.shade200),
        buildSecondaryAdItem("极速回收 >", "免费上门回收", Colors.grey.shade200),
        buildSecondaryAdItem("晒好物 >", "只晒不卖的宝贝", Colors.grey.shade200),
      ],
    );
  }

  Widget buildSecondaryAdItem(String title, String subtitle, Color color) {
    return Container(
      color: color,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildAdItem(title, subtitle, Colors.black, Icons.local_offer),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
        ],
      ),
    );
  }

  Widget buildCloseButton() {
    return RotationTransition(
      turns: _rotateAnimation!,
      child: Icon(
        Icons.close,
        size: 40,
      ),
    );
  }
}
