import 'dart:math';

import 'package:ank_app/entity/contract_market_entity.dart';
import 'package:ank_app/entity/event/event_alert_added.dart';
import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/entity/order_flow_symbol.dart';
import 'package:ank_app/entity/push_record_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/util/app_picker.dart';
import 'package:ank_app/widget/empty_view.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'alert_manage_logic.dart';

part '_a0_signal_view.dart';
part '_a10_ls_alert_view.dart';
part '_a1_price_view.dart';
part '_a2_oi_view.dart';
part '_a3_funding_rate_view.dart';
part '_a4_liquidation_view.dart';
part '_a5_price_wave_view.dart';
part '_a6_transaction_view.dart';
part '_a7_announcement_view.dart';
part '_a8_huge_waves_view.dart';
part '_a9_fr_alert_view.dart';

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
          if (!isListEmpty && showAddBtn)
            IconButton(onPressed: _toAddAlert, icon: const Icon(Icons.add))
        ],
      ),
      body: Obx(() => getBody),
    );
  }

  void _toAddAlert() {
    Get.to(() {
      return switch (widget.type) {
        NoticeRecordType.signal => _SignalSettingView(logic),
        NoticeRecordType.price => _PriceSettingView(logic),
        NoticeRecordType.oiAlert => _OiSettingView(logic),
        NoticeRecordType.fundingRate => const SizedBox(),
        NoticeRecordType.liquidation => const SizedBox(),
        NoticeRecordType.priceWave => const SizedBox(),
        NoticeRecordType.transaction => const SizedBox(),
        NoticeRecordType.announcement => const SizedBox(),
        NoticeRecordType.hugeWaves => const SizedBox(),
        NoticeRecordType.frAlert => _FrAlertSettingView(logic),
        NoticeRecordType.lsAlert => _LsAlertSettingView(logic),
        NoticeRecordType.advanced => const SizedBox(),
        NoticeRecordType.unknown => const SizedBox(),
      };
    }, curve: Easing.linear);
  }

  bool get isListEmpty {
    if (widget.type == NoticeRecordType.signal) {
      return logic.userSignalAlerts.isEmpty;
    }
    return logic.userAlerts.where((p0) => p0.type == widget.type).isEmpty;
  }

  bool get showAddBtn =>
      widget.type != NoticeRecordType.fundingRate &&
      widget.type != NoticeRecordType.liquidation &&
      widget.type != NoticeRecordType.priceWave &&
      widget.type != NoticeRecordType.transaction &&
      widget.type != NoticeRecordType.announcement &&
      widget.type != NoticeRecordType.hugeWaves;

  Widget get getBody {
    if (isListEmpty && showAddBtn) {
      return Center(
        child: Column(
          children: [
            const Gap(100),
            const EmptyView(),
            const Gap(50),
            SizedBox(
              width: 144,
              child: FilledButton(
                  onPressed: _toAddAlert, child: Text(S.of(context).add)),
            )
          ],
        ),
      );
    }
    return switch (widget.type) {
      NoticeRecordType.signal => _SignalView(logic),
      NoticeRecordType.price => _PriceView(logic),
      NoticeRecordType.oiAlert => _OiView(logic),
      NoticeRecordType.fundingRate => _FundingRateView(logic),
      NoticeRecordType.liquidation => _LiquidationView(logic),
      NoticeRecordType.priceWave => _PriceWaveView(logic),
      NoticeRecordType.transaction => _TransactionView(logic),
      NoticeRecordType.announcement => _AnnouncementView(logic),
      NoticeRecordType.hugeWaves => _HugeWavesView(logic),
      NoticeRecordType.frAlert => _FrAlertView(logic),
      NoticeRecordType.lsAlert => _LsAlertView(logic),
      NoticeRecordType.advanced => const SizedBox(),
      NoticeRecordType.unknown => const SizedBox(),
    };
  }
}
