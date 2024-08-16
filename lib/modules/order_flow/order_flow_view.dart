import 'dart:io';

import 'package:ank_app/entity/event/event_fullscreen.dart';
import 'package:ank_app/entity/order_flow_symbol.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/app_refresh.dart';
import 'package:ank_app/widget/rate_with_sign.dart';
import 'package:ank_app/widget/triple_state_sort_button.dart';
import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

// Obx(() {
//             return Switch(
//               value: mainLogic.fullscreen.value,
//               onChanged: (value) {
//                 AppConst.eventBus.fire(EventFullscreen(value));
//               },
//             );
//           }),
//           FilledButton(
//               onPressed: () => Get.to(() => Scaffold()),
//               child: Text('new page')),
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CommonWebView(
        showLoading: true,
        url: Urls.urlProChart,
        urlGetter: () => Urls.urlProChart,
        onWebViewCreated: (controller) {
          mainLogic.webViewController = controller;
          controller
            ..addJavaScriptHandler(
              handlerName: 'openSymbolDialog',
              callback: (arguments) {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return const _CoinDialogWithInterceptor();
                  },
                );
              },
            )
            //enableFullscreen(bool enable)
            ..addJavaScriptHandler(
              handlerName: 'enableFullscreen',
              callback: (arguments) {
                late bool enable;
                try {
                  enable = arguments.firstOrNull ?? true;
                } catch (e) {
                  enable = true;
                }
                AppConst.eventBus.fire(EventFullscreen(enable));
              },
            );
        },
      ),
    );
  }
}
