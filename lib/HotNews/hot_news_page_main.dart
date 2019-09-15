import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zhihu_daily/Common/config.dart';

import '../home_news_detail.dart';
import '../webview_page.dart';
class HotNewsMain extends StatefulWidget{

  @override
  _HotNewsMainState createState()=>_HotNewsMainState();
}

class _HotNewsMainState extends State<HotNewsMain>
{

  ///网络请求
  Response response;
  Dio dio = new Dio();


  Future getHotFuture ;

  @override
  void initState() {
    super.initState();
    getHotFuture = getHotNews();

  }


  /**
   * {
      "recent": [
      {
      "news_id": 9714613,
      "url": "http://news-at.zhihu.com/api/2/news/9714613",
      "thumbnail": "https://pic2.zhimg.com/v2-1dbacbcf143a7af56387f61d649952c1.jpg",
      "title": "瞎扯 · 如何正确地吐槽"
      },
      {
      "news_id": 9714615,
      "url": "http://news-at.zhihu.com/api/2/news/9714615",
      "thumbnail": "https://pic3.zhimg.com/v2-bc94023cbbf6352d370696fcfaf0973a.jpg",
      "title": "瞎扯 · 如何正确地吐槽"
      },
      {
      "news_id": 9714698,
      "url": "http://news-at.zhihu.com/api/2/news/9714698",
      "thumbnail": "https://pic2.zhimg.com/v2-9e100685bccb7003c2bcb47e867bb701.jpg",
      "title": "如果中国人登月把美国人插的国旗拔掉了，美国会怎么做？"
      },
      {
      "news_id": 9714643,
      "url": "http://news-at.zhihu.com/api/2/news/9714643",
      "thumbnail": "https://pic2.zhimg.com/v2-b7f0ec9c089d9912f18a1d72ba2bc1c9.jpg",
      "title": "为什么很多综艺总逃不过越做越烂？"
      },
      {
      "news_id": 9714690,
      "url": "http://news-at.zhihu.com/api/2/news/9714690",
      "thumbnail": "https://pic1.zhimg.com/v2-887a11b34be417ac4367d6e57e70ec60.jpg",
      "title": "70 年来，有没有一首歌，让你听了就热泪盈眶？"
      },
      {
      "news_id": 9714675,
      "url": "http://news-at.zhihu.com/api/2/news/9714675",
      "thumbnail": "https://pic2.zhimg.com/v2-603ab71e4f2cc84d6e21493245913029.jpg",
      "title": "鱼的记忆只有 7 秒？假的"
      },
      {
      "news_id": 9714624,
      "url": "http://news-at.zhihu.com/api/2/news/9714624",
      "thumbnail": "https://pic2.zhimg.com/v2-7be6975110a9f8835fc13e5ff28a5171.jpg",
      "title": "瞎扯 · 如何正确地吐槽"
      },
      {
      "news_id": 9714693,
      "url": "http://news-at.zhihu.com/api/2/news/9714693",
      "thumbnail": "https://pic3.zhimg.com/v2-e43801aeff53dca7d6757b56eaafde32.jpg",
      "title": "只身一猫摧毁 220 个鸟巢，这就是你家楼下流浪猫的威力"
      },
      {
      "news_id": 9714660,
      "url": "http://news-at.zhihu.com/api/2/news/9714660",
      "thumbnail": "https://pic1.zhimg.com/v2-19b5ad842905954fed9abc065d095090.jpg",
      "title": "新赛季的勇士在失去杜兰特后，还能走到什么样的高度？"
      },
      {
      "news_id": 9714724,
      "url": "http://news-at.zhihu.com/api/2/news/9714724",
      "thumbnail": "https://pic4.zhimg.com/v2-175b8d682f96a8cb9e55828c50954553.jpg",
      "title": "手机渐变色工艺的设计和制作难度大吗？"
      },
      {
      "news_id": 9714734,
      "url": "http://news-at.zhihu.com/api/2/news/9714734",
      "thumbnail": "https://pic2.zhimg.com/v2-51c411eea0e47051a9c857d24149ea95.jpg",
      "title": "人类疾病抗争史：手术两百年"
      },
      {
      "news_id": 9714666,
      "url": "http://news-at.zhihu.com/api/2/news/9714666",
      "thumbnail": "https://pic2.zhimg.com/v2-7ed97149c26a1d5fa03254c29d0e4d11.jpg",
      "title": "儿童性启蒙：为人父母的一个任务"
      },
      {
      "news_id": 9714642,
      "url": "http://news-at.zhihu.com/api/2/news/9714642",
      "thumbnail": "https://pic4.zhimg.com/v2-8cf3169d6b98d7222fdd56bd46107f63.jpg",
      "title": "这迷人又该死的拖延症"
      },
      {
      "news_id": 9714755,
      "url": "http://news-at.zhihu.com/api/2/news/9714755",
      "thumbnail": "https://pic3.zhimg.com/v2-95768fa715f6380a02cbd5500d7bf222.jpg",
      "title": "70 年来，有没有一首歌，让你听了就热泪盈眶？"
      },
      {
      "news_id": 9714782,
      "url": "http://news-at.zhihu.com/api/2/news/9714782",
              http://news-at.zhihu.com/api/3/news/8339246
      "thumbnail": "https://pic4.zhimg.com/v2-e786eae24fd31b607281b05ab001808f.jpg",
      "title": "槟榔，为什么是一级致癌物？"
      }
      ]
      }
   */
  Future<Map<String,dynamic>> getHotNews() async{
    print("开始执行网络请求。。。");
    response = await dio.get(Config.HOT_NEWS,options: Options(responseType: ResponseType.json));
    print("网络请求结果: " + response.data.toString());
    return response.data;
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil()..init(context);
    return new Scaffold(
      appBar: AppBar(
        title: Text("热门"),
      ),
      body:     FutureBuilder<Map<String,dynamic>>(
        future: getHotFuture,
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
              List<dynamic> hotNewList = newsMap["recent"];

             return  ListView.builder(
                  itemCount: hotNewList.length,
                  itemExtent: ScreenUtil.getInstance().setHeight(250),
                  itemBuilder: (BuildContext context, int index) {
                    return         InkWell(
                      child: Card(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(hotNewList[index]["title"].toString(),style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(47)),),
                                padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(25)),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child:Image.network(hotNewList[index]["thumbnail"].toString(),),
                                padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(15)),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                      onTap: (){
                        String id =  hotNewList[index]["news_id"].toString();

                        print("热门 id:" + id.toString());

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