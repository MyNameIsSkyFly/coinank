import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/urls.dart';
import 'liq_map_logic.dart';

class LiqMapPage extends StatelessWidget {
  const LiqMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(LiqMapLogic());
    final state = Get.find<LiqMapLogic>().state;
    return Obx(() {
      return Stack(
        children: [
          Column(
            children: [
              if (!state.isLoading.value)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return InkWell(
                          onTap: () => logic.chooseSymbol(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
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
                              Text(
                                state.symbol.value.split('/').first,
                                style: Styles.tsSub_12(context),
                              ),
                            ],
                          ),
                        );
                      }),
                      const Spacer(),
                      InkWell(
                        onTap: () => logic.chooseTime(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 30,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Obx(() {
                                return Text(
                                  state.interval.value,
                                  style: Styles.tsSub_14m(context),
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
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.refresh_rounded,
                            color: Theme.of(context).iconTheme.color,
                            size: 20,
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
                  url: Urls.chartUrl,
                  isFile: true,
                  onWebViewCreated: (controller) {
                    state.webCtrl = controller;
                  },
                ),
              ),
            ],
          ),
          if (state.isLoading.value) const LottieIndicator(),
        ],
      );
    });
  }
}
