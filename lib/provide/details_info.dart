import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class DetailsInfoProvider with ChangeNotifier, DiagnosticableTreeMixin {
  DetailsModel _goodsInfo = null;
  bool _isLeft = true;
  bool _isRight = false;
  get goodsInfo => _goodsInfo;
  bool get isLeft => _isLeft;
  bool get isRight => _isRight;
  // 获取商品详情
  Future<void> getGoodsInfo(String id) async {
    var formData = {'goodId': id};
    await request('getGoodsDetailById', formData: formData).then((value) {
      var responseData = json.decode(value.toString());

      _goodsInfo = DetailsModel.fromJson(responseData);
    });

    return notifyListeners(); // 通知
  }

  // tabber的切换方法
  changeLeftAndRight(String changeState) {
    if (changeState == 'left') {
      _isLeft = true;
      _isRight = false;
    } else {
      _isLeft = false;
      _isRight = true;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty('goodsInfo', goodsInfo));
    properties.add(FlagProperty('isLeft', value: isLeft));
    properties.add(FlagProperty('isRight', value: isRight));
  }
}
