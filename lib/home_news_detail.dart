import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zhihu_daily/Common/config.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:flutter_zhihu_daily/widgets/my_behavior.dart';

import 'Common/colors.dart';


class NewsDetailPage extends StatefulWidget{

  NewsDetailPage({Key key,this.id}) : super(key: key);

  final String id;

  @override
  _NewsDetailPageState createState()=>_NewsDetailPageState();

}

class _NewsDetailPageState extends State<NewsDetailPage>
{
  ///网络请求
  Response response;
  Dio dio = new Dio();

  Future getNewsDetailFuture;

  String title = "";
  @override
  void initState() {
    super.initState();
    getNewsDetailFuture = getDetailNews();
  }

  Future<Map<String,dynamic>> getDetailNews() async{
    response = await dio.get(Config.NEWS_DETAIL + widget.id,options: Options(responseType: ResponseType.json));
    if(response.data != null && response.data["name"] != null){
      title = response.data["name"].toString();
      setState(() {
      });
    }

    print("消息详情:" + response.data.toString());
    return response.data;
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: FutureBuilder<Map<String,dynamic>>(
        future: getNewsDetailFuture,
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
             // List<dynamic> columnNewList = newsMap["stories"];

             return NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      automaticallyImplyLeading: true,

                  /*    leading: Container(
                          alignment: Alignment.centerLeft,
                          child: new IconButton(icon: Icon(
                            Icons.arrow_back, color: Colors.black,
                          ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }
                          )
                      ),
*/
                      centerTitle: false,
                      elevation: 0,
                      forceElevated: false,
                    //  backgroundColor: Colors.white,
                      brightness: Brightness.dark,
                      textTheme: TextTheme(),
                      primary: true,
                      titleSpacing: 0.0,
                      expandedHeight: ScreenUtil.getInstance().setHeight(550),
                      floating: false,
                      pinned: true,
                      snap: false,
                      flexibleSpace:
                      new FlexibleSpaceBar(
                        background: Container(
                          child:Image.network(newsMap["image"].toString(),fit: BoxFit.fitWidth,),
                        ),
                        title:Text(
                          newsMap["title"].toString(),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil.getInstance().setSp(50)
                          ),
                        ),
                        centerTitle: true,
                        titlePadding: EdgeInsets.only(left: 80,right: 100,bottom: 18),
                        collapseMode: CollapseMode.parallax,
                      ),

                    ),


                  ];
                },
                body:
                ScrollConfiguration(
                  behavior: MyBehavior(),
                  child:   SingleChildScrollView(
                    child:  new HtmlView(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      data: newsMap["body"],
                      onLaunchFail: (url) { // optional, type Function
                        print("launch $url failed");
                      },
                      scrollable: false, //false to use MarksownBody and true to use Marksown
                    ),


                  ),
                ),



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