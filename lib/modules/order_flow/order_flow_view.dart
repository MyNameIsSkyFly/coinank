import 'package:ank_app/res/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'order_flow_logic.dart';

class OrderFlowPage extends StatefulWidget {
  const OrderFlowPage({super.key});

  @override
  State<OrderFlowPage> createState() => _OrderFlowPageState();
}

class _OrderFlowPageState extends State<OrderFlowPage> {
  final logic = Get.put(OrderFlowLogic());
  InAppWebViewController? webCtrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(Urls.urlProChart)),
          initialSettings: InAppWebViewSettings(
              userAgent: 'CoinsohoWeb-flutter',
              javaScriptEnabled: true,
              javaScriptCanOpenWindowsAutomatically: true),
          onWebViewCreated: (controller) {
            webCtrl = controller
              ..addJavaScriptHandler(
                handlerName: 'handlerName',
                callback: (arguments) {},
              );
          },
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage.toString());
          },
        ),
      ),
    );
  }
}
