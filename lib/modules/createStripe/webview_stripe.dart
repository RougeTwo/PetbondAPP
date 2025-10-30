import 'dart:async';
import 'package:flutter/material.dart';
import 'package:petbond_uk/services/connect_account/connect_services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  ConnectServices connectServices = ConnectServices();
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _body(context: context)));
  }

  Widget _body({required BuildContext context}) {
    return Column(
      children: [
        Expanded(
            child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          initialUrl: widget.url,
          onPageFinished: (String url) {
            if (url
                .contains("https://staging.petbond.co.uk/onboarding-process")) {
              Navigator.pop(context);
              Future.delayed(Duration(seconds: 1), () {
                connectServices.checkOnBoard(context: context);
              });
            }
          },
        ))
      ],
    );
  }
}
