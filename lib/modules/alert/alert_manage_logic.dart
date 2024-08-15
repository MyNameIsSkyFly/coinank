import 'dart:async';

import 'package:ank_app/entity/event/event_alert_added.dart';
import 'package:ank_app/entity/order_flow_symbol.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

import '../../entity/push_record_entity.dart';

class AlertManageLogic extends GetxController {
  final alertConfigs = RxList<AlertTypeEntity>();
  final userAlerts = RxList<AlertUserNoticeEntity>();
  final userSignalAlerts = RxList<UserAlertSignalConfigEntity>();
  final symbols = RxList<OrderFlowSymbolEntity>();
  StreamSubscription? _subscription;
  @override
  void onInit() {
    _subscription = AppConst.eventBus.on<EventAlertAdded>().listen((event) {
      _getAllAlerts();
    });
    super.onInit();
  }

  void _getAllAlerts() {
    Apis()
        .getUserAlertConfigs()
        .then((value) => userAlerts.assignAll(value ?? []));
  }

  @override
  void onReady() {
    getData();
  }

  void getData() {
    Apis().getAlertConfig().then((value) => alertConfigs.assignAll((value ?? [])
      ..insert(0, const AlertTypeEntity(type: NoticeRecordType.signal))));
    _getAllAlerts();
    Apis()
        .getAlertUserSignalList()
        .then((value) => userSignalAlerts.assignAll(value ?? []));
  }

  Future<void> getSymbol() async {
    if (symbols.isNotEmpty) return;
    await Loading.wrap(() async {
      await Apis()
          .getOrderFlowSymbols()
          .then((value) => symbols.assignAll(value ?? []));
    });
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

  String getTypeText(String type) {
    return switch (type.toLowerCase()) {
      'orderflow' => S.current.s_order_flow,
      'st' => S.current.superTrend,
      'rsi' => 'RSI',
      'macd' => 'MACD',
      'kdj' => 'KDJ',
      'td' => 'TD',
      'boll' => 'BOLL',
      'bbi' => 'BBI',
      'ma' => 'MA',
      'ema' => 'EMA',
      _ => '',
    };
  }

  String getWarningTypeText(String warningType) {
    return switch (warningType.toLowerCase()) {
      'unbalance' => S.current.unbalance,
      'buy_sell_point' => S.current.superTrend,
      'rsicross' => 'RSI ${S.current.goldDeadCross}',
      'macdcross' => 'MACD ${S.current.goldDeadCross}',
      'kdjcross' => 'KDJ ${S.current.goldDeadCross}',
      'tdsignal' => 'TD ${S.current.signal}',
      'bollcross' => switch (AppUtil.shortLanguageName) {
          'zh' => 'BOLL 中轨金叉死叉，超买超卖',
          'zh-tw' => 'BOLL 中軌金叉死叉，超買超賣',
          _ => 'BOLL Cross, Overbought and Oversold'
        },
      'bbicross' => 'BBI ${S.current.goldDeadCross}',
      'macross' => 'MA ${S.current.goldDeadCross}',
      'emacross' => 'EMA ${S.current.goldDeadCross}',
      _ => '',
    };
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
