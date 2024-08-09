import 'package:ank_app/entity/order_flow_symbol.dart';
import 'package:ank_app/generated/l10n.dart';
import 'package:ank_app/http/apis.dart';
import 'package:get/get.dart';

import '../../entity/push_record_entity.dart';

class AlertManageLogic extends GetxController {
  final alertConfigs = RxList<AlertTypeEntity>();
  final userAlerts = RxList<AlertUserNoticeEntity>();
  final userSignalAlerts = RxList<UserAlertSignalConfigEntity>();
  final symbols = RxList<OrderFlowSymbolEntity>();

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void getData() {
    Apis().getAlertConfig().then((value) => alertConfigs.assignAll((value ?? [])
      ..insert(0, const AlertTypeEntity(type: NoticeRecordType.signal))));
    Apis()
        .getUserAlertConfigs()
        .then((value) => userAlerts.assignAll(value ?? []));
    Apis()
        .getAlertUserSignalList()
        .then((value) => userSignalAlerts.assignAll(value ?? []));
  }

  Future<void> getSymbol() async {
    if (symbols.isNotEmpty) return;
    await Apis()
        .getOrderFlowSymbols()
        .then((value) => symbols.assignAll(value ?? []));
  }

  String getTitle(NoticeRecordType type) {
    final s = S.current;
    return switch (type) {
      NoticeRecordType.signal => s.signal,
      NoticeRecordType.price => s.price,
      NoticeRecordType.oiAlert => s.oiAlert,
      NoticeRecordType.fundingRate => s.s_funding_rate,
      NoticeRecordType.liquidation => s.largeLiquidation,
      NoticeRecordType.priceWave => s.priceWave,
      NoticeRecordType.transaction => s.largeTransaction,
      NoticeRecordType.announcement => s.announcement,
      NoticeRecordType.hugeWaves => s.hugeWave,
      NoticeRecordType.frAlert => s.fundingRateAlert,
      NoticeRecordType.lsAlert => s.longShortAlert,
      NoticeRecordType.advanced => s.advanced,
      NoticeRecordType.unknown => 'unknown',
    };
  }
}
