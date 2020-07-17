import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../model/category.dart';

class ChildCategoryProvider with ChangeNotifier, DiagnosticableTreeMixin {
  List<BxMallSubDto> _childCategoryList = [];
  int _childIndex = 0;
  String _categoryId = '4'; // 大类的Id
  String _categorySubId = ''; // 子类id
  int _page = 1; // 列表页数
  String _noMoreText = ''; // 显示没有数据的文子
  List get childCategoryList => _childCategoryList;
  int get categorySubIndex => _childIndex;
  String get categoryId => _categoryId;
  String get categorySubId => _categorySubId;
  String get noMoreText => _noMoreText;
  int get page => _page;

  getChildCategory(List<BxMallSubDto> list, String id) {
    BxMallSubDto all = BxMallSubDto();
    _childIndex = 0;
    _categoryId = id;
    _categorySubId = '';
    _page = 1;
    _noMoreText = '';

    all.mallSubId = '';
    all.mallCategoryId = '00';
    all.comments = 'null';
    all.mallSubName = '全部';
    _childCategoryList = [all];
    _childCategoryList.addAll(list);
    notifyListeners();
  }

  // 改变子类索引
  chageChildIndex(index, String categorySubId) {
    _page = 1;
    _noMoreText = '';
    _childIndex = index;
    _categorySubId = categorySubId;
    notifyListeners();
  }

  // 增加page
  addPage() {
    _page++;
  }

  changeNoNore(String text) {
    _noMoreText = text;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty('childCategoryList', childCategoryList));
    properties.add(IntProperty('categorySubIndex', categorySubIndex));
    properties.add(StringProperty('categoryId', categoryId));
    properties.add(StringProperty('categorySubId', categorySubId));
    properties.add(StringProperty('noMoreText', noMoreText));
    properties.add(IntProperty('page', page));
  }
}
