import 'package:flutter/material.dart';
import './pages/index_page.dart';
import 'package:provider/provider.dart';

// provider
import './provide/counter.dart';
import './provide/child_category.dart';
import 'provide/category_goods_list.dart';
import 'provide/details_info.dart';

// router
import 'package:fluro/fluro.dart';
import './routers/routes.dart';
import './routers/application.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Counter()),
      ChangeNotifierProvider(create: (_) => ChildCategoryProvider()),
      ChangeNotifierProvider(create: (_) => CategoryGoodsListProvider()),
      ChangeNotifierProvider(create: (_) => DetailsInfoProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configrureRoutes(router);
    Application.router = router;

    return Container(
      child: MaterialApp(
          title: '百姓生活+',
          onGenerateRoute: Application.router.generator,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.pink,
          ),
          home: IndexPage()),
    );
  }
}
