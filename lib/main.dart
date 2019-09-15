import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'HomePage/home_page_main.dart';
import 'HotNews/hot_news_page_main.dart';
import 'column/column_main_page.dart';

void main() {

  /**
   * 设置状态栏颜色
   */
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  List<String> titleList = new List();
  int _index = 0;
  String title = "";

  List<Widget> list = new List();

  @override
  void initState() {
    super.initState();
    list..add(HomePageMain())..add(HotNewsMain())..add(ColumnPageMain());

    titleList..add("首页")..add("热门")..add("栏目");
    title = titleList[_index];
  }




  void _onItemTapped(int index){
    if(mounted){
      setState(() {
        _index = index;
        title = titleList[_index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil.instance = ScreenUtil()..init(context);

    return Scaffold(
      /*appBar: AppBar(
        title: Text(title),
      ),*/

      body: list[_index],

      bottomNavigationBar:
      new BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: ScreenUtil().setSp(48),
          currentIndex: _index,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(title: Text("首页"),icon: Icon(Icons.home,size: ScreenUtil.getInstance().setWidth(80),)),
            BottomNavigationBarItem(title: Text("热门"),icon: Icon(Icons.bookmark_border,size: ScreenUtil.getInstance().setWidth(80),),),
            BottomNavigationBarItem(title: Text("栏目"),icon: Icon(Icons.format_list_bulleted,size: ScreenUtil.getInstance().setWidth(80),)),
          ]
      ),

    );
  }
}
