import 'package:flutter/material.dart';
import 'package:flutter_shop/provide/details_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/screenutil.dart';

class DetailsTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    try {} catch (e) {}
    var goodsInfo =
        context.watch<DetailsInfoProvider>().goodsInfo.data.goodInfo;
    if (goodsInfo != null) {
      var data = goodsInfo.data.goodInfo;
      return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            _goodsImage(data.image1),
            _goodsName(data.goodsName),
            _goodsNum(data.goodsSerialNumber),
            _goodsPrice(data.oriPrice.toString(), data.presentPrice.toString())
          ],
        ),
      );
    } else {
      return Text('正在加载');
    }
  }

  // 商品图片
  Widget _goodsImage(url) {
    return Image.network(
      url,
      width: ScreenUtil().setWidth(740),
    );
  }

  // 商品名称
  Widget _goodsName(name) {
    return Container(
      width: ScreenUtil().setWidth(740),
      padding: EdgeInsets.only(left: 15.0),
      child: Text(name, style: TextStyle(fontSize: ScreenUtil().setSp(30))),
    );
  }

  Widget _goodsNum(num) {
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 15),
      margin: EdgeInsets.only(top: 8.0),
      child: Text(
        '编码：$num',
        style: TextStyle(color: Colors.black12),
      ),
    );
  }

  Widget _goodsPrice(oriPrice, presentPrice) {
    return Container(
      margin: EdgeInsets.only(left: 15.0),
      padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10),
      child: Row(
        children: <Widget>[
          Text(
            '￥$oriPrice',
            style:
                TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(32)),
          ),
          Text('  市场价：'),
          Text('￥$presentPrice',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey))
        ],
      ),
    );
  }
}
