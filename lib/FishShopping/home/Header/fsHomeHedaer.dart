
import 'package:flutter/material.dart';

import 'FSHomeHeaderAdsOne.dart';
import 'fsHomeHeaderAdsTwo.dart';
import 'FSHomeHeaderCategory.dart';

class FSHomeHedaer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Stack(
        children: <Widget>[
          Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.greenAccent,
                  Colors.greenAccent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)
              )
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              children: <Widget>[
                FSHomeHeaderCategory(),
                SizedBox(height: 12,),
                FSHomeHeaderAdsOne(),
                SizedBox(height: 12,),
                //FSHomeHeaderAdsTwo(),
              ],
            ),
          )
        ],
      )
    );
  }
}
