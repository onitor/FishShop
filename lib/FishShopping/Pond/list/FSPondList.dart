
import 'package:codes/FishShopping/Pond/list/widgets/FSPondAdsWidget.dart';
import 'package:codes/FishShopping/Pond/list/widgets/FSPondPieceWidget.dart';
import 'package:codes/FishShopping/Pond/list/widgets/FSPondTopicWidget.dart';
import 'package:codes/FishShopping/Pond/piece_detail/FSPondPieceDetailPage.dart';
import 'package:codes/FishShopping/common/Carousel.dart';
import 'package:codes/FishShopping/common/Network.dart';
import 'package:codes/FishShopping/common/RefreshDataWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'model/FSPondPieceModel.dart';

class FSPondList extends StatefulWidget {

  FSPondList({
    Key ?key,
    required this.typeKey
  }) : super(key: key);

  final String typeKey;

  @override
  State<StatefulWidget> createState() {
    return _FSPondListState();
  }
}

class _FSPondListState extends State<FSPondList> with AutomaticKeepAliveClientMixin {

  List _dataList = [];
  int page = 0;
 
  GlobalKey _easyRefreshKey = GlobalKey();
  GlobalKey _headerKey = GlobalKey();
  GlobalKey _footerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    refreshFirstData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildBody();
  }

  @override
  bool get wantKeepAlive => true;

  Widget buildBody() {
    if (_dataList.isEmpty) {
      return RefreshDataWidget();
    }   

    return EasyRefresh(
      key: _easyRefreshKey,
      header: ClassicalHeader(
        key: _headerKey,
        refreshText: "下拉刷新",
        refreshReadyText: "释放刷新",
        refreshingText: "正在刷新...",
        refreshedText: "刷新完成",
        refreshFailedText: "刷新失败",
        noMoreText: "没有更多数据",
        infoText: "更新于 %T",
        bgColor: Colors.yellow,
        textColor: Colors.black87,
      ),
      footer: ClassicalFooter(
        key: _footerKey,
        loadText: "上拉加载",
        loadReadyText: "释放加载",
        loadingText: "正在加载...",
        loadedText: "加载完成",
        loadFailedText: "加载失败",
        noMoreText: "没有更多数据",
        infoText: "更新于 %T",
        bgColor: Colors.transparent,
        textColor: Colors.black87,
      ),
      onRefresh: () async {
        await refreshFirstData();
      },
      onLoad: () async {
        await refreshMoreData();
      },
      child: buildList(),
    );
  }

  Widget buildList() {
    return ListView.builder(
      itemCount: 2 + _dataList.length,
      itemBuilder: (BuildContext context, int index) {
        // topic 
        if (index == 0) {
          return FSPondTopicWidget();
        } else if (index == 1) {
          return FSPondAdsWidget(widget.typeKey, () {
            
          });
        } else {
          int rebaseIndex = index - 2;
          var model = _dataList[rebaseIndex];
          if (model is FSPondPieceModel) {
            return FSPondPieceWidget(model: model, callback: (){
               Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return FSPondPieceDetailPage(model);
                })
              );
            });

          } else if (model is List) {
            return Carousel(
              images: mockCarouselData(),
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              aspectRatio: 3,
              interval: 4,
              indicatorBottom: 20,
            );

          } else {
            return Container(
              child: Text("Not Support This Message"),
            );
          }
        }    
      },
    );
  }

  List<String> mockCarouselData() {
    return [
      'images/image_01.png',
      'images/image_02.jpg',
      'images/image_03.jpg',
      'images/image_04.jpg',
    ];
  }

  Future refreshFirstData() async {    
    var responseJson = await EDCRequest.get(action: "fish_pieces",params: {});
    
    List<FSPondPieceModel> pieces = [];
    responseJson.forEach( (data) {
      pieces.add(FSPondPieceModel.fromJSON(data));
    });
    
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted){
        return;
      }
      setState(() {
        _dataList.clear();
        _dataList.addAll(pieces);
        _dataList.insert(1, mockCarouselData());
        page = 0;
      });
    });
  }

  Future refreshMoreData() async {
    var responseJson = await EDCRequest.get(action: "fish_pieces",params: {});
    
    List<FSPondPieceModel> pieces = [];
    responseJson.forEach( (data) {
      pieces.add(FSPondPieceModel.fromJSON(data));
    });
    
    Future.delayed(Duration(seconds: 2), () {
      if (!mounted){
        return;
      }
      setState(() {
        _dataList.addAll(pieces);
        page++;
      });
    });

  }

}