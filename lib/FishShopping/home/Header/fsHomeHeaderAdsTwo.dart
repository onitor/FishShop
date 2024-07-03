
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'FSHomeAdsModel.dart';

class FSHomeHeaderAdsTwo extends StatelessWidget {

  final List<FSHomeAdsModel> _adsList = [
    FSHomeAdsModel("发布闲置", "30秒发布宝贝", "https://cataas.com/cat"),
    FSHomeAdsModel("淘宝专卖", "网购淘宝一件发布", "https://cataas.com/cat"),
    FSHomeAdsModel("信用回收", "先收钱 再寄货", "https://cataas.com/cat"),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            buildRowOneWidget(),
            builtRowTwoWidget(),
            Divider(),
            buildRowThreeWidget(),
          ],
        ),
      )
    );
  }  

  Widget buildRowOneWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "卖闲置能换钱",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "最新发布",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14
                )
              ),
              
              TextSpan(
                text: "3564",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14
                )
              ),

              TextSpan(
                text: "件闲置",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14
                )
              ),
            ]
          )
        )
      ],
    );
  }

  Widget builtRowTwoWidget() {
    return Padding(
      padding: EdgeInsets.all(0),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            buildAdsItemWidget(_adsList[0]),
            VerticalDivider(),
            SizedBox(width: 5,),
            buildAdsItemWidget(_adsList[1]),
          ],
        )
      ),
    );
  }

  Widget buildRowThreeWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 1), // 增加顶部间距
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildAdsItemWidget(_adsList[2]),
                  Container(
                      height: 20,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange, Colors.red],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.only(left: 20, right: 6)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "57类上门回收",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 8,),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 16,
                            )
                          ],
                        ),
                      )
                  ),
                ],
              )
          ),
          SizedBox(width: 20,),
          buildRowThreeItem("手机回收"),
          buildRowThreeItem("旧衣回收"),
          buildRowThreeItem("卡券回收"),
        ],
      ),
    );
  }


  Widget buildRowThreeItem(String title) {
    return
    Padding(

      padding: EdgeInsets.only(left: 6, right: 6),
      child: Column(
        children: <Widget>[
          Image(
            width: 50,
            height: 50,
            image: CachedNetworkImageProvider("https://cataas.com/cat"),
            fit: BoxFit.cover,
          ),
          SizedBox(height: 5,),
          Text(
            title,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 12,
            ),
          )
        ],
      )
    );
  }

  // item 
  Widget buildAdsItemWidget(FSHomeAdsModel model) {
    return Expanded(child:
      Container(
        padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(model.imgUrl),
                  fit: BoxFit.cover,//保持图片比例
                ),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
            SizedBox(width: 10,),//增加间距

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  model.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.orange
                  )
                ),
                Text(
                  model.detail,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: Colors.black54
                  )
                ),
              ],
            ),

          ],
        ),
      )
    );
  }
}