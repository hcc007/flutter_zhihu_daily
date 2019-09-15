
class LastNewsBean{
  /**
   * {
      "date": "20190829",
      "stories": [
      {
      "images": [
      "https://pic2.zhimg.com/v2-51c411eea0e47051a9c857d24149ea95.jpg"
      ],
      "type": 0,
      "id": 9714734,
      "ga_prefix": "082909",
      "title": "人类疾病抗争史：手术两百年"
      },
      {
      "images": [
      "https://pic4.zhimg.com/v2-175b8d682f96a8cb9e55828c50954553.jpg"
      ],
      "type": 0,
      "id": 9714724,
      "ga_prefix": "082907",
      "title": "手机渐变色工艺的设计和制作难度大吗？"
      },
      {
      "images": [
      "https://pic3.zhimg.com/v2-bc94023cbbf6352d370696fcfaf0973a.jpg"
      ],
      "type": 0,
      "id": 9714615,
      "ga_prefix": "082906",
      "title": "瞎扯 · 如何正确地吐槽"
      }
      ],
      "top_stories": [
      {
      "image": "https://pic4.zhimg.com/v2-9326d71b99346b8d1936b7b0e2923e63.jpg",
      "type": 0,
      "id": 9714689,
      "ga_prefix": "082620",
      "title": "如何用一天，看尽新中国的 70 年？"
      },
      {
      "image": "https://pic3.zhimg.com/v2-2898291c30691b4cfcd124cb1c89e652.jpg",
      "type": 0,
      "id": 9714532,
      "ga_prefix": "082207",
      "title": "A battle of Title: 「称呼」是一种「信仰」"
      },
      {
      "image": "https://pic3.zhimg.com/v2-524f820a813aa01296f448da039523ce.jpg",
      "type": 0,
      "id": 9714537,
      "ga_prefix": "082422",
      "title": "小事 · 一通操作猛如虎"
      },
      {
      "image": "https://pic4.zhimg.com/v2-addc8595bf741cf5d6b338daf37fddbf.jpg",
      "type": 0,
      "id": 9714217,
      "ga_prefix": "080907",
      "title": "是什么，让人们开始质疑登月的真实性？"
      },
      {
      "image": "https://pic4.zhimg.com/v2-5dcae1b99de59420bce76f543dc7977b.jpg",
      "type": 0,
      "id": 9714198,
      "ga_prefix": "080916",
      "title": "氧气到底是生命的救济，还是慢性的毒药？"
      }
      ]
      }
   *
   */



  final int type;
  final String date;
  final List<dynamic> stories;
  final List<dynamic> top_stories;

  LastNewsBean(this.type,this.date, this.stories, this.top_stories);



}