import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zhihu_daily/Common/config.dart';

import '../home_news_detail.dart';
class ColumnDetailPage extends StatefulWidget{

  ColumnDetailPage({Key key,this.id}) : super(key: key);

  final String id;

  @override
  _ColumnDetailPageState createState()=>_ColumnDetailPageState();

}

class _ColumnDetailPageState extends State<ColumnDetailPage>
{
  ///网络请求
  Response response;
  Dio dio = new Dio();

  Future getColumnFuture;

  String title = "";
  @override
  void initState() {
    super.initState();
    getColumnFuture = getColumnDetailNews();
  }

  Future<Map<String,dynamic>> getColumnDetailNews() async{
    response = await dio.get(Config.COLUMN_DETAIL + widget.id,options: Options(responseType: ResponseType.json));
    if(response.data != null && response.data["name"] != null){
      title = response.data["name"].toString();
      setState(() {
      });
    }
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("$title"),
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
              List<dynamic> columnNewList = newsMap["stories"];

              return  ListView.builder(
                  itemCount:columnNewList.length,
                  itemExtent: ScreenUtil.getInstance().setHeight(370),
                  itemBuilder: (BuildContext context, int index) {
                    return         InkWell(
                      child: Card(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child:    Container(
                                //color:Colors.grey,
                                child: Text(columnNewList[index]["title"].toString(),style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(50)),),
                                padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(40)),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child:Image.network(columnNewList[index]["images"][0].toString()),
                                padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(15)),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                      onTap: (){
                        String id = columnNewList[index]["id"].toString();

                        Navigator.push(context,
                            PageRouteBuilder(
                                transitionDuration: Duration(microseconds: 100),
                                pageBuilder: (BuildContext context, Animation animation,
                                    Animation secondaryAnimation) {
                                  return new FadeTransition(
                                      opacity: animation,
                                      child: NewsDetailPage(id:id)
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