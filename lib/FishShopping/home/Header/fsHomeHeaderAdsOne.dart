import 'package:flutter/material.dart';
import 'FSHomeAdsModel.dart';

class FSHomeHeaderAdsOne extends StatefulWidget {
  @override
  _FSHomeHeaderAdsOneState createState() => _FSHomeHeaderAdsOneState();
}

class _FSHomeHeaderAdsOneState extends State<FSHomeHeaderAdsOne> {
  final List<FSHomeAdsModel> _adsOne = [
    FSHomeAdsModel("闲鱼特卖", "新人专享福利", "assets/phone.jpg"),
    FSHomeAdsModel("极速回收", "免费上门", "assets/phone.jpg"),
    FSHomeAdsModel("旧衣回收", "旧衣换好礼", "assets/computer.jpg"),
    FSHomeAdsModel("二手新品", "本机 iPhone...", "assets/phone.jpg"),
    FSHomeAdsModel("闲鱼直播", "爆款好物直播中", "assets/computer.jpg"),
    FSHomeAdsModel("闲鱼帮卖", "帮你找买家", "assets/phone.jpg"),
  ];

  final PageController _pageController = PageController(viewportFraction: 1.0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160, // 设置容器高度
      child: PageView.builder(
        controller: _pageController,
        itemCount: (_adsOne.length / 3).ceil(), // 计算页数
        itemBuilder: (context, index) {
          return _buildPageItem(index);
        },
      ),
    );
  }

  Widget _buildPageItem(int index) {
    int startIndex = index * 3;
    int endIndex = startIndex + 3;
    if (endIndex > _adsOne.length) endIndex = _adsOne.length;
    List<FSHomeAdsModel> sublist = _adsOne.sublist(startIndex, endIndex);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: sublist.map((item) => Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: buildAdsItemWidget(item),
      )).toList(),
    );
  }

  Widget buildAdsItemWidget(FSHomeAdsModel model) {
    return Container(
      margin: EdgeInsets.only(left: 0.0), // 设置左边距将第一张卡片贴近左边
      padding: EdgeInsets.all(10.0),
      width: 130, // 卡片的宽度
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        gradient: LinearGradient(
          colors: [Colors.white, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            model.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Text(
            model.detail,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 5),
          Image.asset(
            model.imgUrl,
            height: 80,
            width: 90,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
