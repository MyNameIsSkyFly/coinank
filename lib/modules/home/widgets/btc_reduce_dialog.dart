import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home_logic.dart';

class BtcReduceDialog extends StatelessWidget {
  const BtcReduceDialog({super.key, required this.logic});

  final HomeLogic logic;

  Widget _box(BuildContext context,
      {required String text, required String unit}) {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(minWidth: 45),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).cardColor),
          margin: const EdgeInsets.only(left: 8, right: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text(
            text,
            style: Styles.tsBody_28(context).medium,
          ),
        ),
        const Gap(8),
        Text(
          unit,
          style: Styles.tsBody_12m(context),
        ),
      ],
    );
  }

  Widget _row(BuildContext context,
      {required String title,
      required String value,
      bool bottomPadding = true}) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding ? 8 : 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Styles.tsSub_12(context).medium,
            ),
          ),
          Text(
            value,
            style: Styles.tsBody_12m(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45),
        child: Material(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Obx(() {
              final time = DateTime.fromMillisecondsSinceEpoch(
                  logic.btcReduceData.value?.halvingTime ?? 0);
              final duration = time.difference(DateTime.now());
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context).btcReduceCountDown,
                      style: Styles.tsBody_18m(context),
                    ),
                    const Gap(20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _box(
                          context,
                          text: '${duration.inDays}',
                          unit: S.of(context).days,
                        ),
                        _box(
                          context,
                          text: '${duration.inHours % 24}',
                          unit: S.of(context).hours,
                        ),
                        _box(
                          context,
                          text: '${duration.inMinutes % 60}',
                          unit: S.of(context).minutes,
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          _row(context,
                              title: '当前区块高度',
                              value: '${logic.btcReduceData.value?.height}'),
                          _row(context,
                              title: '剩余区块',
                              value:
                                  '${logic.btcReduceData.value?.reduceHeight}'),
                          _row(context,
                              title: '减半区块',
                              value:
                                  '${logic.btcReduceData.value?.halvingBlockHeight}'),
                          _row(context,
                              title: '减半预估时间',
                              value:
                                  '${logic.btcReduceData.value?.halvingTime}',
                              bottomPadding: false),
                        ],
                      ),
                    ),
                    const Gap(20),
                    FilledButton(
                        onPressed: () => Get.back(),
                        child: Text(S.of(context).s_ok))
                  ],
                ),
              );
            })),
      ),
    );
  }
}
