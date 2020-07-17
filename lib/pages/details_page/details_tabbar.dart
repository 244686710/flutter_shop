import 'package:flutter/material.dart';
import 'package:flutter_shop/provide/details_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/screenutil.dart';

class DetailsTabber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isLeft = context.watch<DetailsInfoProvider>().isLeft;
    var isRight = context.watch<DetailsInfoProvider>().isRight;
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        children: <Widget>[
          _myTabBarLeft(context, isLeft),
          _myTabBarRight(context, isRight)
        ],
      ),
    );
  }

  Widget _myTabBarLeft(BuildContext context, bool isLeft) {
    return InkWell(
      onTap: () {
        Provider.of<DetailsInfoProvider>(context, listen: false)
            .changeLeftAndRight('left');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  width: 1.0, color: isLeft ? Colors.pink : Colors.black12)),
        ),
        child: Text('详情', style: TextStyle(color: Colors.black12)),
      ),
    );
  }

  Widget _myTabBarRight(BuildContext context, bool isRight) {
    return InkWell(
      onTap: () {
        Provider.of<DetailsInfoProvider>(context, listen: false)
            .changeLeftAndRight('right');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  width: 1.0, color: isRight ? Colors.pink : Colors.black12)),
        ),
        child: Text('评论', style: TextStyle(color: Colors.black12)),
      ),
    );
  }
}
