import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPage extends StatefulWidget {

  WebViewPage({Key key,this.WebURL}) : super(key: key);

  final String WebURL;

  @override
  State<StatefulWidget> createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
/*
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        brightness: Brightness.light,

        title: Text("网络加载", style: new TextStyle(color: MyColors.gray_33, ),),

        leading: Container(
            alignment: Alignment.centerLeft,
            child: new IconButton(icon: Icon(
              Icons.arrow_back_ios, color: MyColors.gray_33,
           ),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            )
        ),


        centerTitle: true,
      ),
*/
      url: widget.WebURL,
      withJavascript: true,
      withZoom: false,
    );
  }
}
