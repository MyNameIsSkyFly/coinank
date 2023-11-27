import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'exchange_oi_logic.dart';

class ExchangeOiPage extends StatefulWidget {
  const ExchangeOiPage({super.key});

  static const String routeName = '/exchange_oi';

  @override
  State<ExchangeOiPage> createState() => _ExchangeOiPageState();
}

class _ExchangeOiPageState extends State<ExchangeOiPage> {
  final logic = Get.put(ExchangeOiLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitleBar(
        title: S.of(context).s_open_interest,
      ),
      body: CommonWebView(
        url: 'assets/files/t18.html',
        isFile: true,
        onWebViewCreated: (controller) {
          logic.webCtrl = controller;
        },
      ),
    );
  }
}
