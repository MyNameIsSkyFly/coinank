import 'package:ank_app/entity/order_flow_symbol.dart';
import 'package:ank_app/entity/push_record_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/empty_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'alert_manage_logic.dart';

part '_signal_config_view.dart';

class AlertConfigsView extends StatefulWidget {
  const AlertConfigsView({super.key, required this.type});

  final NoticeRecordType type;

  @override
  State<AlertConfigsView> createState() => _AlertConfigsViewState();
}

class _AlertConfigsViewState extends State<AlertConfigsView> {
  final logic = Get.find<AlertManageLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(logic.getTitle(widget.type)),
        actions: [
          if (!isListEmpty)
            IconButton(
                onPressed: () {
                  Get.to(() {
                    return switch (widget.type) {
                      NoticeRecordType.signal => _SignalSettingView(logic),
                      NoticeRecordType.price => SizedBox(),
                      NoticeRecordType.oiAlert => SizedBox(),
                      NoticeRecordType.fundingRate => SizedBox(),
                      NoticeRecordType.liquidation => SizedBox(),
                      NoticeRecordType.priceWave => SizedBox(),
                      NoticeRecordType.transaction => SizedBox(),
                      NoticeRecordType.announcement => SizedBox(),
                      NoticeRecordType.hugeWaves => SizedBox(),
                      NoticeRecordType.frAlert => SizedBox(),
                      NoticeRecordType.lsAlert => SizedBox(),
                      NoticeRecordType.advanced => SizedBox(),
                      NoticeRecordType.unknown => SizedBox(),
                    };
                  }, curve: Easing.linear);
                },
                icon: const Icon(Icons.add))
        ],
      ),
      body: getBody,
    );
  }

  bool get isListEmpty {
    if (widget.type == NoticeRecordType.signal) {
      return logic.userSignalAlerts.isEmpty;
    }
    return logic.userAlerts.where((p0) => p0.type == widget.type).isEmpty;
  }

  Widget get getBody {
    if (isListEmpty) {
      return Center(
        child: Column(
          children: [
            const Gap(100),
            const EmptyView(),
            const Gap(50),
            SizedBox(
              width: 144,
              child: FilledButton(
                  onPressed: () {}, child: Text(S.of(context).add)),
            )
          ],
        ),
      );
    }
    return switch (widget.type) {
      NoticeRecordType.signal => _SignalView(logic),
      NoticeRecordType.price => const SizedBox(),
      NoticeRecordType.oiAlert => const SizedBox(),
      NoticeRecordType.fundingRate => const SizedBox(),
      NoticeRecordType.liquidation => const SizedBox(),
      NoticeRecordType.priceWave => const SizedBox(),
      NoticeRecordType.transaction => const SizedBox(),
      NoticeRecordType.announcement => const SizedBox(),
      NoticeRecordType.hugeWaves => const SizedBox(),
      NoticeRecordType.frAlert => const SizedBox(),
      NoticeRecordType.lsAlert => const SizedBox(),
      NoticeRecordType.advanced => const SizedBox(),
      NoticeRecordType.unknown => const SizedBox(),
    };
  }
}
