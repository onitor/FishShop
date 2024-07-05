
import 'package:codes/FishShopping/Message/FSMessageListItem.dart';
import 'package:codes/FishShopping/Message/FSMessageModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'FSMessageHeader.dart';

class FSMessagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FSMessagePageState();
  }
}

class _FSMessagePageState extends State<FSMessagePage> with AutomaticKeepAliveClientMixin {

  List<FSMessageModel> _messageList = [
    FSMessageModel(avatar: "https://cataas.com/cat", name: "我关注的", content: "imsdh666发布了全新金色Xs Max 64 无敌iPhone", date: "1天前", image: "https://cataas.com/cat"),
    FSMessageModel(avatar: "https://cataas.com/cat", name: "qiqi1015122", content: "no", date: "1个月前", image: "https://cataas.com/cat"),
    FSMessageModel(avatar: "https://cataas.com/cat", name: "122222", content: "no", date: "1个月前", image: "https://cataas.com/cat"),
    FSMessageModel(avatar: "https://cataas.com/cat", name: "edceezz", content: "你有一条消息", date: "1个月前", image: "https://cataas.com/cat"),
  ];

  GlobalKey _easyRefreshKey = GlobalKey();
  GlobalKey _headerKey = GlobalKey();
  GlobalKey _footerKey = GlobalKey();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print("Init Message page");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightGreenAccent, Colors.greenAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                "消息",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
          ),

        ),
        body: buildBody()
    );
  }
  // Widget body() {
  //   return Refresh(
  //     onHeaderRefresh: () {},
  //     child: buildList(),
  //   );
  // }

  Widget buildBody() {
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
        bgColor: Colors.greenAccent,
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
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            child: FSMessageHeader(),
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            height: 10,
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext buildContext, int index) {
              //return FSMessageListItem(message: _messageList[index], isMyFollow: index == 0,);
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: FSMessageListItem(message: _messageList[index], isMyFollow: index == 0,),
                onTap: () {
                  print(index);
                },
              );
            },
            childCount:_messageList.length,
          ),
        )
      ],
    );
  }

  Future refreshFirstData() async {
    await Future.delayed(Duration(seconds: 2), () {
      setState(() {

      });
    });
  }

  Future refreshMoreData() async {
    await Future.delayed(Duration(seconds: 2), () {
      setState(() {

      });
    });
  }
}

