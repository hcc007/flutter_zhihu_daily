import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zhihu_daily/Common/config.dart';

import 'column_detail_page.dart';
class ColumnPageMain extends StatefulWidget{

  @override
  _ColumnPageMainState createState()=>_ColumnPageMainState();
}

class _ColumnPageMainState extends State<ColumnPageMain>
{

  ///网络请求
  Response response;
  Dio dio = new Dio();

  Future getColumnFuture;
  @override
  void initState() {
    super.initState();
    getColumnFuture = getColumnNews();
  }

  Future<Map<String,dynamic>> getColumnNews() async{
    response = await dio.get(Config.COLUMN,options: Options(responseType: ResponseType.json));
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("栏目"),
      ),
      body:    FutureBuilder<Map<String,dynamic>>(
        future: getColumnFuture,
        builder: (context,AsyncSnapshot<Map<String,dynamic>> async){
          ///正在请求时的视图
          if (async.connectionState == ConnectionState.active || async.connectionState == ConnectionState.waiting) {
            return Container();
          }
          ///发生错误时的视图
          if (async.connectionState == ConnectionState.done) {
            if (async.hasError) {
              return Container();
            } else if (async.hasData && async.data != null && async.data.length > 0) {

              Map<String,dynamic> newsMap = async.data;
              List<dynamic> columnNewList = newsMap["data"];

              return  ListView.builder(
                  itemCount:columnNewList.length,
                  itemExtent: ScreenUtil.getInstance().setHeight(250),
                  itemBuilder: (BuildContext context, int index) {
                    return         InkWell(
                      child: Card(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    //color:Colors.grey,
                                    child: Text(columnNewList[index]["name"].toString(),style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(55)),),
                                    padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(40)),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  Container(
                                    child: Text(columnNewList[index]["description"].toString().trim()== ""
                                        ?"暂无描述":columnNewList[index]["description"].toString(),
                                      style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(40)),),
                                    padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(40)),
                                    margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(15)),
                                  ),
                                ],
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child:Image.network(columnNewList[index]["thumbnail"].toString()),
                                padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(15)),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                      onTap: (){
                        print("获取的 id 是：" + columnNewList[index]["id"].toString());
                        Navigator.push(context,
                            PageRouteBuilder(
                                transitionDuration: Duration(microseconds: 100),
                                pageBuilder: (BuildContext context, Animation animation,
                                    Animation secondaryAnimation) {
                                  return new FadeTransition(
                                      opacity: animation,
                                      child: ColumnDetailPage(id: columnNewList[index]["id"].toString(),)
                                  );
                                })
                        );
                      },
                    );
                  }
              );
            }else{
              return Container();
            }
          }
          return Container();
        },
      ),
    );
  }



}