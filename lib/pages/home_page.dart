import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/service_method.dart';
import 'package:url_launcher/url_launcher.dart'; // 打电话，或者打开网页
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../routers/application.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  String homePageContent = '正在获取数据';
  int page = 1;
  List<Map> hotGoodsList = [];
  @override
  void initState() {
    super.initState();
    // 加载首页数据
    request('homePageContent',
            formData: {'lon': '115.02932', 'lat': '35.76189'})
        .then((value) => setState(() {
              homePageContent = value.toString();
            }));
    // _getHotGoods();
  }

  // 获取热销商品数据
  Future<void> _getHotGoods() {
    var formData = {'page': page};
    return request('homePageBelowConten', formData: formData).then((value) {
      var data = json.decode(value.toString());
      List<Map> newGoodsList = (data['data'] as List).cast();
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++;
      });
    });
  }

  Widget _hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    alignment: Alignment.center,
    color: Colors.transparent,
    padding: EdgeInsets.all(5.0),
    child: Text('火爆专区'),
  );

  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((val) {
        return InkWell(
          onTap: () {
            Application.router
                .navigateTo(context, "/detail?id=${val['goodsId']}");
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(children: <Widget>[
              Image.network(
                val['image'],
                width: ScreenUtil().setWidth(370),
                height: ScreenUtil().setHeight(370),
              ),
              Text(
                val['name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
              ),
              Row(
                children: <Widget>[
                  Text('￥${val['mallPrice']}'),
                  Text(
                    '￥${val['price']}',
                    style: TextStyle(
                        color: Colors.black26,
                        decoration: TextDecoration.lineThrough),
                  )
                ],
              )
            ]),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text('');
    }
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[_hotTitle, _wrapList()],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text('百姓生活+')),
      body: Container(
        child: FutureBuilder(
          future: request('homePageContent',
              formData: {'lon': '115.02932', 'lat': '35.76189'}),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.toString());

              List<Map> swiper = (data['data']['slides'] as List).cast();
              List<Map> navigatorList =
                  (data['data']['category'] as List).cast();
              String adPicture =
                  data['data']['advertesPicture']['PICTURE_ADDRESS'];
              String leaderImage = data['data']['shopInfo']['leaderImage'];
              String leaderPhone = data['data']['shopInfo']['leaderPhone'];
              List<Map> recommendList =
                  (data['data']['recommend'] as List).cast();
              String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];
              String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];
              String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];
              List<Map> floor1List = (data['data']['floor1'] as List).cast();
              List<Map> floor2List = (data['data']['floor2'] as List).cast();
              List<Map> floor3List = (data['data']['floor3'] as List).cast();

              return EasyRefresh(
                onLoad: () async {
                  await _getHotGoods();
                },
                onRefresh: () async {
                  await request('homePageContent',
                      formData: {'lon': '115.02932', 'lat': '35.76189'});
                },
                header: ClassicalHeader(
                    bgColor: Colors.pink,
                    enableHapticFeedback: false,
                    refreshText: 'saa',
                    // enableInfiniteRefresh: false,
                    refreshedText: '加载完成',
                    refreshingText: '加载中...',
                    refreshFailedText: '',
                    showInfo: false,
                    refreshReadyText: '下拉刷新...'),
                footer: ClassicalFooter(
                  bgColor: Colors.white,
                  textColor: Colors.pink,
                  loadText: '加载中',
                  loadedText: '上拉加载',
                  showInfo: false,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    SwiperDiy(swiperDataList: swiper),
                    TopNavigator(navigatorList: navigatorList),
                    AdBanner(adPicture: adPicture),
                    LeaderPhone(
                        leaderImage: leaderImage, leaderPhone: leaderPhone),
                    Recommend(recommendList: recommendList),
                    FloorTitle(pictureAddress: floor1Title),
                    FloorContent(floorGoodsList: floor1List),
                    FloorTitle(pictureAddress: floor2Title),
                    FloorContent(floorGoodsList: floor2List),
                    FloorTitle(pictureAddress: floor3Title),
                    FloorContent(floorGoodsList: floor3List),
                    _hotGoods()
                  ],
                ),
              );
            } else {
              return Center(
                child: Text('加载中...'),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// 首页轮播
class SwiperDiy extends StatelessWidget {
  const SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  final List swiperDataList;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Application.router.navigateTo(
                  context, '/detail?id=${swiperDataList[index]['goodsId']}');
            },
            child: Image.network(
              '${swiperDataList[index]["image"]}',
              fit: BoxFit.fill,
            ),
          );
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

// 顶部导航
class TopNavigator extends StatelessWidget {
  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  final List navigatorList;

  Widget _gridViewItem(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (navigatorList.length > 10) {
      navigatorList.removeRange(10, navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          return _gridViewItem(context, item);
        }).toList(),
      ),
    );
  }
}

// 顶部广告
class AdBanner extends StatelessWidget {
  AdBanner({Key key, this.adPicture}) : super(key: key);
  final String adPicture;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

// 店长电话
class LeaderPhone extends StatelessWidget {
  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);
  final String leaderImage;
  final String leaderPhone;

  Future<void> _launchURL() async {
    // String url = 'http://jspang.com';
    String url = 'tel:' + leaderPhone;
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'url不能进行访问，异常';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Image.network(leaderImage),
        onTap: _launchURL,
      ),
    );
  }
}

// 商品推荐列表
class Recommend extends StatelessWidget {
  Recommend({Key key, this.recommendList}) : super(key: key);
  final List recommendList;

  // 标题
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 0.5, color: Colors.black12)),
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  // 商品单独项
  Widget _item(BuildContext context, index) {
    return InkWell(
      onTap: () {
        Application.router.navigateTo(
            context, '/detail?id=${recommendList[index]['goodsId']}');
      },
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: .5, color: Colors.black12),
          ),
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  // 横向列表方法
  Widget _recommendList(context) {
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recommendList.length,
          itemBuilder: (context, index) {
            return _item(context, index);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(380),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[_titleWidget(), _recommendList(context)],
      ),
    );
  }
}

// 楼层标题
class FloorTitle extends StatelessWidget {
  const FloorTitle({Key key, this.pictureAddress}) : super(key: key);
  final String pictureAddress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(pictureAddress),
    );
  }
}

// 楼层商品列表
class FloorContent extends StatelessWidget {
  const FloorContent({Key key, this.floorGoodsList}) : super(key: key);
  final List floorGoodsList;

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          Column(children: <Widget>[_firstRow(context), _otherGoods(context)]),
    );
  }

  Widget _firstRow(context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, floorGoodsList[0]),
        Column(children: <Widget>[
          _goodsItem(context, floorGoodsList[1]),
          _goodsItem(context, floorGoodsList[2]),
        ])
      ],
    );
  }

  Widget _otherGoods(context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, floorGoodsList[3]),
        _goodsItem(context, floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(BuildContext context, Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          Application.router
              .navigateTo(context, '/detail?id=${goods['goodsId']}');
          print('点击了楼层图片');
        },
        child: Image.network(goods['image']),
      ),
    );
  }
}
