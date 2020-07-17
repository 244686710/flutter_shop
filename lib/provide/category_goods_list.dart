import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../model/categoryGoodsList.dart';

class CategoryGoodsListProvider with ChangeNotifier, DiagnosticableTreeMixin {
  List<CategoryGoodsListData> _categoryGoodsListData = [];
  int _childIndex = 0;
  List get categoryGoodsListData => _categoryGoodsListData;
  int get categorySubIndex => _childIndex;
  getGoodsList(List<CategoryGoodsListData> list) {
    _categoryGoodsListData = list;
    notifyListeners();
  }

  getMoreList(List<CategoryGoodsListData> list) {
    _categoryGoodsListData.addAll(list);
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(ObjectFlagProperty('categoryGoodsList', categoryGoodsListData));
  }
}
