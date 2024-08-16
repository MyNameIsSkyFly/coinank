part of 'alert_configs_view.dart';

class _LiquidationView extends StatefulWidget {
  const _LiquidationView(this.logic);

  final AlertManageLogic logic;

  @override
  State<_LiquidationView> createState() => _LiquidationViewState();
}

class _LiquidationViewState extends State<_LiquidationView> {
  final liqOn = false.obs;
  final liqStaOn = false.obs;

  @override
  void initState() {
    final list = widget.logic.userAlerts
        .where((p0) => p0.type == NoticeRecordType.liquidation)
        .map((e) => e.baseCoin)
        .toList();
    liqOn.value = list.contains('liquidation');
    liqStaOn.value = list.contains('liqSta');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(S.of(context).largeLiquidation,
                    style: Styles.tsBody_14m(context)),
              ),
              Obx(() {
                return Switch(
                  value: liqOn.value,
                  onChanged: (value) {
                    liqOn.value = value;
                    onChanged('liquidation', value);
                  },
                );
              }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(S.of(context).liqStat,
                    style: Styles.tsBody_14m(context)),
              ),
              Obx(() {
                return Switch(
                  value: liqStaOn.value,
                  onChanged: (value) {
                    liqStaOn.value = value;
                    onChanged('ETH', value);
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  void onChanged(String baseCoin, bool value) {
    if (value == false) {
      final item = widget.logic.userAlerts.firstWhereOrNull((p0) =>
          p0.baseCoin == baseCoin && p0.type == NoticeRecordType.liquidation);
      if (item == null) return;

      Apis().deleteUserAlertConfigs(id: item.id).then((value) {
        AppConst.eventBus.fire(EventAlertAdded());
      });
    } else {
      Apis()
          .saveOrUpdateUserAlertConfigs(
        type: NoticeRecordType.liquidation,
        baseCoin: baseCoin,
        subType: '',
        noticeValue: 2000000,
      )
          .then((value) {
        AppConst.eventBus.fire(EventAlertAdded());
      });
    }
  }
}
