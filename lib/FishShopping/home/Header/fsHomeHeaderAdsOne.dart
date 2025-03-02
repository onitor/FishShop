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

    var screenSize = MediaQuery.of(context).size;
    var screenHight = screenSize.height;
    var screenWidth = screenSize.width;

    return Container(
      height: screenHight * 0.21, // 设置容器高度
      child: PageView.builder(
        controller: _pageController,
        itemCount: (_adsOne.length / 3).ceil(), // 计算页数
        itemBuilder: (context, index) {
          return _buildPageItem(index,screenWidth);
        },
      ),
    );
  }

  Widget _buildPageItem(int index,double screenWidth) {
    int startIndex = index * 3;
    int endIndex = startIndex + 3;
    if (endIndex > _adsOne.length) endIndex = _adsOne.length;
    List<FSHomeAdsModel> sublist = _adsOne.sublist(startIndex, endIndex);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: sublist.map((item) => Padding(
        padding: EdgeInsets.only(right:screenWidth*0.02),
        child: buildAdsItemWidget(item,screenWidth),
      )).toList(),
    );
  }

  Widget buildAdsItemWidget(FSHomeAdsModel model,double screenWidth) {
    return Container(
      margin: EdgeInsets.only(left: 0.0), // 设置左边距将第一张卡片贴近左边
      padding: EdgeInsets.all(screenWidth*0.02),
      width: screenWidth*0.29, // 卡片的宽度
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth*0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: screenWidth*0.01,
            blurRadius: screenWidth*0.02,
            offset: Offset(0,screenWidth*0.01),
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
              fontSize: screenWidth*0.04,
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(height: screenWidth*0.01),
          Text(
            model.detail,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: screenWidth*0.035,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: screenWidth*0.01),
          ClipRRect(
            borderRadius: BorderRadius.circular(screenWidth*0.02), // 添加圆角
            child: Image.asset(
              model.imgUrl,
              height: screenWidth*0.28,
              width: screenWidth*0.3, // 增加图片宽度
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
