
import 'package:codes/FishShopping/Category/FSCategoryPage.dart';
import 'package:flutter/material.dart';

class FSHomeHeaderCategory extends StatelessWidget {
  final List<Map<String, dynamic>> _categoryList = [
    {"name": "人才市场", "icon": Icons.work},
    {"name": "手机", "icon": Icons.smartphone},
    {"name": "省钱神券", "icon": Icons.local_offer},
    {"name": "充值中心", "icon": Icons.account_balance_wallet},
    {"name": "奢品", "icon": Icons.shopping_bag},
    // 添加更多分类和图标
    {"name": "母婴玩具", "icon": Icons.child_friendly},
    {"name": "家具家电", "icon": Icons.kitchen},
    {"name": "服饰鞋包", "icon": Icons.style},
    {"name": "美妆闲置", "icon": Icons.brush},
    {"name": "二手车", "icon": Icons.directions_car},
    {"name": "超值租", "icon": Icons.house},
    {"name": "全部分类", "icon": Icons.category}
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: _categoryList.map((Map<String, dynamic> category) {
            return GestureDetector(
              onTap: () {
                if (category["name"] == "全部分类") {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return FSCategoryPage();
                    }),
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: <Widget>[
                    Icon(
                      category["icon"],
                      size: 50,
                      color: Colors.cyan[100],
                    ),
                    SizedBox(height: 5),
                    Text(
                      category["name"]!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}