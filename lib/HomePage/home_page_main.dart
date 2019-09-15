import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_zhihu_daily/Common/colors.dart';
import 'package:flutter_zhihu_daily/Common/config.dart';
import 'package:flutter_zhihu_daily/DataBean/home_news_bean.dart';
import 'package:flutter_zhihu_daily/HomePage/test_refresh.dart';
import 'package:flutter_zhihu_daily/utils/date_util.dart';
import 'package:flutter_zhihu_daily/widgets/my_space_bar.dart';

import '../home_news_detail.dart';
class HomePageMain extends StatefulWidget{

  @override
  _HomePageMainState createState()=>_HomePageMainState();
}

class _HomePageMainState extends State<HomePageMain>
{

  ///网络请求
  Response response;
  Dio dio = new Dio();

  Future futureGetLastTopNews ;
  Future futureGetItemNews ;
  List<HomeNewsBean> itemList = new List();
  ScrollController _scrollController = ScrollController();

  //是否显示加载更多控件
  bool isShowProgress = false;

  String currentDate = "";
  @override
  void initState() {
    super.initState();

    futureGetItemNews = getItemNews();
    futureGetLastTopNews = getTopNews();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
          print("get more");
         _getMore(currentDate);
      }
    });

  }

  ///获取顶部 Banner 消息
  Future<   Map<String, dynamic>> getTopNews() async{
    Map<String, dynamic> lastNewsBeanMap ;
    response = await dio.get(Config.LAST_NEWS,options: Options(responseType: ResponseType.json));
    lastNewsBeanMap = response.data;
    return lastNewsBeanMap;
  }

  ///获取最新消息
  Future< List<HomeNewsBean>> getItemNews() async{
    print("开始获取最新消息.");
    itemList.clear();
    Map<String, dynamic> lastNewsBeanMap ;
    response = await dio.get(Config.LAST_NEWS,options: Options(responseType: ResponseType.json));
    lastNewsBeanMap = response.data;
    if(lastNewsBeanMap != null && lastNewsBeanMap.length > 0){
      List<dynamic> stories = lastNewsBeanMap["stories"];
      if(stories != null && stories.length > 0){
        ///标题
        currentDate = lastNewsBeanMap["date"].toString();
        HomeNewsBean titleBean = new HomeNewsBean( DateUtil.formatDateWithWeek(DateTime.parse(currentDate)), 0, "", "", "");
        itemList.add(titleBean);
        stories.forEach((item){
          HomeNewsBean bean = new HomeNewsBean("", 1, item["title"].toString(), item["id"].toString(), item["images"][0].toString());
          itemList.add(bean);
        });
      }
    }

    if(itemList.length < 5){
      _getMore(currentDate);
    }

    return itemList;
  }

  _getMore(String date) async{

    if(date == "")
      return;

    setState(() {
      isShowProgress = true;
    });

    Map<String, dynamic> historyMap ;
    response = await dio.get(Config.HISTORY_NEWS + date,options: Options(responseType: ResponseType.json));
    historyMap = response.data;
    if(historyMap != null && historyMap.length > 0){
      List<dynamic> stories = historyMap["stories"];
      if(stories != null && stories.length > 0){
        ///标题
        currentDate = historyMap["date"].toString();

        HomeNewsBean titleBean = new HomeNewsBean( DateUtil.formatDateWithWeek(DateTime.parse(currentDate)), 0, "", "", "");

        itemList.add(titleBean);
        stories.forEach((item){
          HomeNewsBean bean = new HomeNewsBean("", 1, item["title"].toString(), item["id"].toString(), item["images"][0].toString());
          itemList.add(bean);
        });
      }
    }
    setState(() {
      isShowProgress = false;
    });

  }

  Widget getBlankItem(){
    return new SliverFixedExtentList(
      itemExtent:0,
      delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return Container(
            );
          },
          childCount: 1
      ),
    );
  }

  Widget getViewItem( List<HomeNewsBean> newsList){
    return new SliverFixedExtentList(
      itemExtent: ScreenUtil.getInstance().setHeight(50) + ScreenUtil.getInstance().setHeight(250) * newsList.length -1,
      delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                  ],
                );
          },
          childCount: 1
      ),
    );
  }


  Widget _buildItem(HomeNewsBean bean){
    return     bean.type == 0 ? Container(
      child: Container(
        child: Text(bean.date.toString()),
        padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(25),top: ScreenUtil.getInstance().setWidth(25)),
        height: ScreenUtil.getInstance().setHeight(100),
      )
    ):
    InkWell(
      child:Container(
        child:  Card(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text(bean.title.toString(),style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(47)),),
                  padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(25)),
                ),
                flex: 2,
              ),

              Expanded(
                child: Container(
                  child:Image.network(bean.image.toString(),),
                  padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(15)),
                ),
                flex: 1,
              ),

            ],
          ),
        ),
        height: ScreenUtil.getInstance().setHeight(250),
      ),
      onTap: (){

        Navigator.push(context,
            PageRouteBuilder(
                transitionDuration: Duration(microseconds: 100),
                pageBuilder: (BuildContext context, Animation animation,
                    Animation secondaryAnimation) {
                  return new FadeTransition(
                      opacity: animation,
                      child: NewsDetailPage(id:bean.id.toString())
                  );
                })
        );


      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: MyColors.gray_ef,
      body:   RefreshIndicator(
       onRefresh: getItemNews,
        child:  new CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                new SliverAppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  elevation: 2,
                  forceElevated: false,
                  // backgroundColor: Colors.white,
                  brightness: Brightness.dark,
                  textTheme: TextTheme(),
                  primary: true,
                  titleSpacing: 0,
                  expandedHeight: ScreenUtil.getInstance().setHeight(600),
                  floating: true,
                  pinned: true,
                  snap: true,
                  flexibleSpace:
                  new MyFlexibleSpaceBar(
                    background: Container(
                      color: Colors.black,
                      child:         ///异步网络请求布局
                      FutureBuilder<Map<String,dynamic>>(
                        future: futureGetLastTopNews,
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
                              List<dynamic> stories = newsMap["top_stories"];
                              return Swiper(
                                itemBuilder: (c, i) {
                                  return InkWell(
                                    child:
                                    Stack(
                                      children: <Widget>[

                                    Opacity(
                                      opacity: 0.8,
                                      child:   Container(
                                        decoration: new BoxDecoration(
                                          image: DecorationImage(image:NetworkImage(stories[i]["image"].toString()),fit: BoxFit.fill),
                                        ),
                                      ),
                                    ),


                                        Positioned(
                                          child: Container(
                                                height: ScreenUtil.getInstance().setHeight(250),
                                                width: ScreenUtil.getInstance().setWidth(1080),
                                               // color:Colors.white,
                                                padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(50)),
                                                child:  Text(stories[i]["title"].toString(),
                                                  softWrap: true,
                                                  style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(65),
                                                      color: Colors.white,
                                                      //fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),


                                         // left: ScreenUtil.getInstance().setWidth(50),
                                          bottom: ScreenUtil.getInstance().setHeight(20),
                                        ),


                                      ],
                                    ),



                                    onTap: (){
                                      String id = stories[i]["id"].toString();


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
                                },
                                autoplay: true,
                                duration: 500,
                                itemCount:  stories.length,
                                pagination: new SwiperPagination(
                                    alignment: Alignment.bottomCenter,
                                    margin: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(100),bottom: ScreenUtil.getInstance().setWidth(40)),
                                    builder: DotSwiperPaginationBuilder(
                                      size: 7,
                                      activeSize: 7,
                                      color:MyColors.gray_ef,
                                      activeColor: MyColors.gray_cc,
                                    )),
                              );

                            }else{
                              return Container();
                            }
                          }
                          return Container();
                        },
                      ),
                    ),

                    title: Text("知乎日报",),
                    titlePadding: EdgeInsets.only(left: 20,bottom: 20),

                  ),
                ),

                FutureBuilder<List<HomeNewsBean>>(
                  future: futureGetItemNews,
                  builder: (context,AsyncSnapshot<List<HomeNewsBean>> async){
                    ///正在请求时的视图
                    if (async.connectionState == ConnectionState.active || async.connectionState == ConnectionState.waiting) {
                      return getBlankItem();
                    }
                    ///发生错误时的视图
                    if (async.connectionState == ConnectionState.done) {
                      if (async.hasError) {
                        return getBlankItem();
                      } else if (async.hasData && async.data != null && async.data.length > 0) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {

                                  if(index < async.data.length){
                                    return _buildItem(async.data[index]);
                                  }else{
                                    return Center(
                                      child: isShowProgress? CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                      ):Container(),
                                    );
                                  }

                            },
                            childCount: async.data.length + 1,
                          ),

                        );

                      }else{
                        return getBlankItem();
                      }
                    }
                    return getBlankItem();
                  },
                ),

              ]),

      ),




    );
  }


  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

}