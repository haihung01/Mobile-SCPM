import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:marquee/marquee.dart';

class ChatWebViewScreen extends StatefulWidget {
  final String url;

  ChatWebViewScreen(this.url);

  @override
  State<ChatWebViewScreen> createState() => _ChatWebViewScreenState();
}

class _ChatWebViewScreenState extends State<ChatWebViewScreen> {
  double _progress = 0;
  late InAppWebViewController inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var canGoBack = await inAppWebViewController.canGoBack();
        if (canGoBack) {
          inAppWebViewController.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Liên hệ hỗ trợ",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                    onWebViewCreated: (InAppWebViewController controller) {
                      inAppWebViewController = controller;
                    },
                    onProgressChanged: (controller, progress) {
                      setState(() {
                        _progress = progress / 100;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    height: 20,
                    child: Marquee(
                      text: 'Vui lòng ấn vào biểu tượng trên để được hỗ trợ!',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: 60.0,
                      velocity: 40.0,
                      startPadding: 10.0,
                      accelerationDuration: Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    ),
                  ),
                ),
              ],
            ),
            _progress < 1
                ? LinearProgressIndicator(value: _progress)
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
