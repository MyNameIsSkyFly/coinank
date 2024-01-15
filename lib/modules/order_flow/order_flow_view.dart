import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/urls.dart';
import '../../widget/common_webview.dart';
import '../main/main_logic.dart';

class OrderFlowPage extends StatefulWidget {
  const OrderFlowPage({super.key});

  @override
  State<OrderFlowPage> createState() => _OrderFlowPageState();
}

class _OrderFlowPageState extends State<OrderFlowPage> {
  final mainLogic = Get.find<MainLogic>();
  var cookieSet = false;

  @override
  void initState() {
    CommonWebView.setCookieValue().then((value) {
      setState(() => cookieSet = true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return cookieSet == false
        ? const SizedBox()
        : CommonWebView(
            showLoading: true,
            safeArea: true,
            url: Urls.urlProChart,
            urlGetter: () => Urls.urlProChart,
            onWebViewCreated: (controller) {
              mainLogic.state.webViewController = controller;
            });
  }
}
