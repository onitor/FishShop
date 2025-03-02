import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'fsHomeGoodModel.dart';

enum FHHomeGoodTagType {
  none,
  allNew,  // 全新
  reSell,  // 专卖
}

class FHHomeGoodItem extends StatelessWidget {

  FHHomeGoodItem({Key? key, required this.model}) : super(key: key);

  final FHHomeGoodModel model;

  final double fontSize = 18;
  final double tagFontSize = 16;

  @override
  Widget build(BuildContext context) {
    return buildCard();
  }

  Widget buildCard() {
    return Container(
      height: 250.0,  // 固定高度
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildGoodImage(),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: buildGoodTitle(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: buildGoodPriceRow(),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Divider(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: buildUserInfo(),
          )
        ],
      ),
    );
  }

  Widget buildGoodImage() {
    return Container(
      height: 120.0,  // 固定高度
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
        image: DecorationImage(
          image: CachedNetworkImageProvider(model.mediaURL ?? "https://cataas.com/cat"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildGoodPriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "¥ ${model.price}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
        Text(
          "${model.wantedCount}人想要",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget buildUserInfo() {
    return Row(
      children: <Widget>[
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            image: DecorationImage(
              image: CachedNetworkImageProvider(model.avatarURL ?? "https://cataas.com/cat"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        buildUserDetail()
      ],
    );
  }

  Widget buildUserDetail() {
    if (model.isCredictExeclent != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            model.userName ?? "baby",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          Container(
            color: Colors.grey[100],
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.opacity,
                  size: 12,
                  color: Colors.cyan,
                ),
                Text(
                  "芝麻信用 | 极好",
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        ],
      );
    } else {
      return Text(
        model.userName ?? "baby",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      );
    }
  }

  Widget buildGoodTitle() {
    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          if (FHHomeGoodTagType.values[model.tag ?? 0] != FHHomeGoodTagType.none) goodTag(),
          goodDetail(),
        ],
      ),
    );
  }

  TextSpan goodDetail() {
    return TextSpan(
      text: " ${model.detail}",
      style: TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  TextSpan goodTag() {
    Color? bgColor;
    Color? textColor;
    String? title;

    switch (FHHomeGoodTagType.values[model.tag ?? 1]) {
      case FHHomeGoodTagType.allNew:
        bgColor = Colors.orange;
        textColor = Colors.white;
        title = "全新";
        break;
      case FHHomeGoodTagType.reSell:
        bgColor = Colors.red;
        textColor = Colors.white;
        title = "转卖";
        break;
      default:
        break;
    }

    return TextSpan(
      text: "$title",
      style: TextStyle(
        backgroundColor: bgColor,
        color: textColor,
        fontSize: 12,
      ),
    );
  }
}
