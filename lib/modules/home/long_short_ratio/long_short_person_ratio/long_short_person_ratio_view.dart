import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/app_refresh.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/urls.dart';
import 'long_short_person_ratio_logic.dart';

class LongShortPersonRatioPage extends StatefulWidget {
  const LongShortPersonRatioPage({super.key});

  static const String routeName = '/long_short_person_ratio';

  @override
  State<LongShortPersonRatioPage> createState() =>
      _LongShortPersonRatioPageState();
}

class _LongShortPersonRatioPageState extends State<LongShortPersonRatioPage> {
  final logic = Get.put(LongShortPersonRatioLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitleBar(
        title: S.of(context).s_longshort_person,
        actionWidget: IconButton(
            onPressed: () => AppUtil.shareImage(),
            icon: const ImageIcon(AssetImage(Assets.commonIcShare))),
      ),
      body: Obx(() {
        if (logic.loading.value) {
          return const LottieIndicator();
        } else {
          return AppRefresh(
            onRefresh: () async => logic.onRefresh(),
            child: ListView(
              children: [
                Obx(() {
                  return _PickerBar(
                    title: 'Binance BTC ${S.of(context).s_longshort_person}',
                    onTap: () async {
                      final result =
                          await logic.openSelector(logic.interval1.value);
                      if (result == null) return;
                      logic.interval1.value = result;
                      logic.loadChartData01();
                    },
                    logic: logic,
                    interval: logic.interval1.value,
                  );
                }),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  height: 280,
                  child: CommonWebView(
                    url: Urls.chartUrl,
                    onWebViewCreated: (controller) {
                      logic.webCtrl1 = controller;
                    },
                    onLoadStop: (controller) =>
                        logic.updateReadyStatus1(webReady: true),
                  ),
                ),
                Obx(() {
                  return _PickerBar(
                    title: 'Binance BTC ${S.of(context).s_longshort_person}',
                    onTap: () async {
                      final result =
                          await logic.openSelector(logic.interval2.value);
                      if (result == null) return;
                      logic.interval2.value = result;
                      logic.loadChartData02();
                    },
                    logic: logic,
                    interval: logic.interval2.value,
                  );
                }),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  height: 280,
                  child: CommonWebView(
                    url: Urls.chartUrl,
                    onWebViewCreated: (controller) {
                      logic.webCtrl2 = controller;
                    },
                    onLoadStop: (controller) =>
                        logic.updateReadyStatus2(webReady: true),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}

class _PickerBar extends StatelessWidget {
  const _PickerBar({
    required this.title,
    required this.onTap,
    required this.logic,
    required this.interval,
  });

  final String title;
  final String interval;
  final VoidCallback onTap;
  final LongShortPersonRatioLogic logic;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Gap(15),
        Expanded(
            child: Text(
          title,
          style: Styles.tsBody_14m(context),
        )),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 30,
            decoration: BoxDecoration(
              color: Styles.cMain.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Text(
                  interval,
                  style: Styles.tsSub_14m(context),
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
        ),
        const Gap(15),
      ],
    );
  }
}
