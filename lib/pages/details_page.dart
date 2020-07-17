import 'package:flutter/material.dart';
import 'package:flutter_shop/provide/details_info.dart';
import 'package:provider/provider.dart';
import '../provide/details_info.dart';
import './details_page/details_top_area.dart';
import './details_page/details_explain.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;
  const DetailsPage({Key key, this.goodsId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 直接调用异步操作会导致页面渲染阻塞导致报错；
    // Future.delayed(Duration(seconds: 1), () {
    //   return _getBackInfo(context);
    // });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('商品详情页'),
      ),
      body: FutureBuilder(
        future: _getBackInfo(context),
        builder: (context, asyncSnapshot) {
          // print('asyncSnapshot:>>>${asyncSnapshot.data}');
          if (asyncSnapshot.hasData) {
            return Container(
              child: Column(
                children: <Widget>[DetailsTopArea(), DetailsExplain()],
              ),
            );
          } else {
            return Text('加载中...');
          }
        },
      ),
    );
  }

  Future _getBackInfo(BuildContext context) async {
    context.select((DetailsInfoProvider detailsInfoProvider) =>
        detailsInfoProvider.getGoodsInfo(goodsId));
    return 11;
  }
}
