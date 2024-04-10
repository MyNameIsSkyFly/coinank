import 'dart:io';

import 'package:ank_app/entity/order_flow_symbol.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/app_refresh.dart';
import 'package:ank_app/widget/rate_with_sign.dart';
import 'package:ank_app/widget/triple_state_sort_button.dart';
import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../constants/urls.dart';
import '../../widget/common_webview.dart';
import '../main/main_logic.dart';

part '_coin_dialog.dart';

class OrderFlowPage extends StatefulWidget {
  const OrderFlowPage({super.key});

  @override
  State<OrderFlowPage> createState() => _OrderFlowPageState();
}

class _OrderFlowPageState extends State<OrderFlowPage> {
  final mainLogic = Get.find<MainLogic>();

  // var cookieSet = false;

  @override
  void initState() {
    // CommonWebView.setCookieValue().then((value) {
    //   setState(() => cookieSet = true);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonWebView(
      showLoading: true,
      safeArea: true,
      url: Urls.urlProChart,
      urlGetter: () => Urls.urlProChart,
      onWebViewCreated: (controller) {
        mainLogic.state.webViewController = controller;
        controller.addJavaScriptHandler(
          handlerName: 'openSymbolDialog',
          callback: (arguments) {
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return const _CoinDialogWithInterceptor();
              },
            );
          },
        );
      },
    );
  }
}
