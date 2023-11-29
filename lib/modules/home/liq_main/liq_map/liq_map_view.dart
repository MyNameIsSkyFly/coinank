import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'liq_map_logic.dart';

class LiqMapPage extends StatelessWidget {
  LiqMapPage({super.key});

  final logic = Get.put(LiqMapLogic());
  final state = Get.find<LiqMapLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => logic.chooseSymbol(),
                      child: Row(
                        children: [
                          Text(
                            state.symbol.value.split('/').last,
                            style: Styles.tsBody_14m(context),
                          ),
                          const Gap(10),
                          Image.asset(
                            Assets.commonIconArrowDown,
                            width: 10,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      state.symbol.value.split('/').first,
                      style: Styles.tsSub_12(context),
                    ),
                  ],
                );
              }),
              const Spacer(),
              InkWell(
                onTap: () => logic.chooseTime(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  height: 24,
                  decoration: BoxDecoration(
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Obx(() {
                        return Text(
                          state.interval.value,
                          style: Styles.tsSub_12m(context),
                        );
                      }),
                      const Gap(10),
                      Image.asset(
                        Assets.commonIconArrowDown,
                        width: 10,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(20),
              InkWell(
                onTap: () => logic.onRefresh(),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.refresh_sharp,
                    color: Theme.of(context).iconTheme.color,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 500,
          width: double.infinity,
          margin: const EdgeInsets.all(15),
          child: CommonWebView(
            url: 'assets/files/t18.html',
            isFile: true,
            onWebViewCreated: (controller) {
              state.webCtrl = controller;
            },
          ),
        ),
      ],
    );
  }
}
