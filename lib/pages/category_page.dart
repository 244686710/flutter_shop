import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/provide/category_goods_list.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import '../model/categoryGoodsList.dart';
import 'package:provider/provider.dart';
import '../provide/child_category.dart';
import '../provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('商品分类')),
        body: Container(
          child: Row(children: <Widget>[
            LeftCategoryNav(),
            Column(children: <Widget>[RightCategoryNav(), CategoryGoodsList()])
          ]),
        ));
  }
}

// 左侧大类导航
class LeftCategoryNav extends StatefulWidget {
  LeftCategoryNav({Key key}) : super(key: key);

  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  int listIndex = 0;
  @override
  void initState() {
    _getCategory(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1, color: Colors.black12),
        ),
      ),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _leftInkWell(context, index);
        },
      ),
    );
  }

  Widget _leftInkWell(BuildContext context, int index) {
    bool isClick = false;

    isClick = (index == listIndex) ? true : false;
    return InkWell(
      onTap: () {
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;
        context
            .read<ChildCategoryProvider>()
            .getChildCategory(childList, categoryId);
        _getGoodsList(categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10.0, top: 20.0),
        decoration: BoxDecoration(
            color: isClick ? Color.fromRGBO(236, 236, 236, 1.0) : Colors.white,
            border:
                Border(bottom: BorderSide(width: .5, color: Colors.black26))),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28.0)),
        ),
      ),
    );
  }

  Future<void> _getCategory(BuildContext context) async {
    await request('getCategory').then((value) {
      var data = json.decode(value.toString());

      CategoryModel category = CategoryModel.fromJson(data);
      setState(() {
        list = category.data;
      });
      var categoryId = list[0].mallCategoryId;
      context
          .read<ChildCategoryProvider>()
          .getChildCategory(list[0].bxMallSubDto, categoryId);
      _getGoodsList(categoryId);
    });
  }

  // 获取商品
  void _getGoodsList(String categoryId) async {
    var data = {
      'categoryId': categoryId == null ? '4' : categoryId,
      'categorySubId':
          Provider.of<ChildCategoryProvider>(context, listen: false)
              .categorySubId,
      'page': 1
    };
    await request('getMallGoods', formData: data).then((value) {
      var data = json.decode(value.toString());
      CategoryGoodsListModal goodsList = CategoryGoodsListModal.fromJson(data);
      // context.read<CategoryGoodsListProvider>().getGoodsList(goodsList.data);
      Provider.of<CategoryGoodsListProvider>(context, listen: false)
          .getGoodsList(goodsList.data);
    });
  }
}

// 二级导航
class RightCategoryNav extends StatefulWidget {
  RightCategoryNav({Key key}) : super(key: key);

  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  @override
  Widget build(BuildContext context) {
    var list = context.watch<ChildCategoryProvider>().childCategoryList;
    return Container(
      height: ScreenUtil().setHeight(80),
      width: ScreenUtil().setWidth(570),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          itemBuilder: (context, index) => _rightInkWell(index, list[index])),
    );
  }

  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isActive = false;
    isActive = (index ==
            Provider.of<ChildCategoryProvider>(context, listen: false)
                .categorySubIndex)
        ? true
        : false;
    return InkWell(
      onTap: () {
        Provider.of<ChildCategoryProvider>(context, listen: false)
            .chageChildIndex(index, item.mallSubId);
        print(item);
        _getGoodsList(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              color: isActive ? Colors.pink : Colors.black),
        ),
      ),
    );
  }

  // 获取商品
  void _getGoodsList(String categorySubId) async {
    var data = {
      'categoryId':
          Provider.of<ChildCategoryProvider>(context, listen: false).categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };
    await request('getMallGoods', formData: data).then((value) {
      var data = json.decode(value.toString());
      CategoryGoodsListModal goodsList = CategoryGoodsListModal.fromJson(data);

      if (goodsList.data == null) {
        Provider.of<CategoryGoodsListProvider>(context, listen: false)
            .getGoodsList([]);
      } else {
        Provider.of<CategoryGoodsListProvider>(context, listen: false)
            .getGoodsList(goodsList.data);
      }
      // context.read<CategoryGoodsListProvider>().getGoodsList(goodsList.data);
    });
  }
}

// 商品列表
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  var viewlistScrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var len =
        context.watch<CategoryGoodsListProvider>().categoryGoodsListData.length;
    var page = Provider.of<ChildCategoryProvider>(context, listen: true).page;
    print('页面发生了改变$page');
    if (page == 1) {
      try {
        print(viewlistScrollController);
        viewlistScrollController.jumpTo(0);
      } catch (e) {}
    }
    if (len == 0) {
      return Container(
        padding: EdgeInsets.only(top: 100.0),
        child: Text('暂时没有数据'),
      );
    } else {
      return Expanded(
        // Expanded 弹性，撑满
        child: Container(
          width: ScreenUtil().setWidth(570),
          child: EasyRefresh(
            onLoad: () async {
              await _getMoreList();
            },
            // onRefresh: () async {
            //   await request('homePageContent',
            //       formData: {'lon': '115.02932', 'lat': '35.76189'});
            // },
            footer: ClassicalFooter(
              bgColor: Colors.white,
              textColor: Colors.pink,
              loadText: '加载中',
              loadedText:
                  Provider.of<ChildCategoryProvider>(context, listen: true)
                      .noMoreText,
              showInfo: false,
              loadingText: '加载中...',
              loadReadyText: '加载中...',
              // enableInfiniteLoad: true,
              noMoreText: '没有了',
            ),
            child: ListView.builder(
                itemCount: len,
                controller: viewlistScrollController,
                itemBuilder: (context, index) {
                  return _listItemWidget(
                      context
                          .watch<CategoryGoodsListProvider>()
                          .categoryGoodsListData,
                      index);
                }),
          ),
        ),
      );
    }
  }

  // 获取商品
  Future<void> _getMoreList() async {
    Provider.of<ChildCategoryProvider>(context, listen: false).addPage();
    var data = {
      'categoryId':
          Provider.of<ChildCategoryProvider>(context, listen: false).categoryId,
      'categorySubId':
          Provider.of<ChildCategoryProvider>(context, listen: false)
              .categorySubId,
      'page': Provider.of<ChildCategoryProvider>(context, listen: false).page
    };
    await request('getMallGoods', formData: data).then((value) {
      var data = json.decode(value.toString());
      CategoryGoodsListModal goodsList = CategoryGoodsListModal.fromJson(data);

      if (goodsList.data == null) {
        // _showToast('没有更多了');
        Fluttertoast.showToast(
            msg: "已经到底了",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 16.0);
        Provider.of<ChildCategoryProvider>(context, listen: false)
            .changeNoNore('没有更多了');
      } else {
        Provider.of<CategoryGoodsListProvider>(context, listen: false)
            .getMoreList(goodsList.data);
      }
    });
  }

  Widget _goodsImage(List list, index) {
    return Container(
      child: Image.network(
        list[index].image,
        width: ScreenUtil().setWidth(200),
        height: ScreenUtil().setHeight(200),
      ),
    );
  }

  Widget _goodsName(List list, index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        list[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _goodsPrice(List list, int index) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      width: ScreenUtil().setWidth(370),
      child: Row(children: <Widget>[
        Text(
          '价格：￥${list[index].presentPrice}',
          style:
              TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
        ),
        Text(
          '￥${list[index].oriPrice}',
          style: TextStyle(
              color: Colors.black26, decoration: TextDecoration.lineThrough),
        )
      ]),
    );
  }

  Widget _listItemWidget(list, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
          margin: EdgeInsets.only(bottom: 5.0),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              _goodsImage(list, index),
              Column(children: <Widget>[
                _goodsName(list, index),
                _goodsPrice(list, index)
              ])
            ],
          )),
    );
  }
}
