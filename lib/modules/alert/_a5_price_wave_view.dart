part of 'alert_configs_view.dart';

class _PriceWaveView extends StatefulWidget {
  const _PriceWaveView(this.logic);

  final AlertManageLogic logic;

  @override
  State<_PriceWaveView> createState() => _PriceWaveViewState();
}

class _PriceWaveViewState extends State<_PriceWaveView> {
  final selectedBtcWave = 0.0.obs;
  final selectedEthWave = 0.0.obs;
  final thresholdOn = false.obs;

  @override
  void initState() {
    final list = widget.logic.userAlerts
        .where((p0) => p0.type == NoticeRecordType.priceWave)
        .toList();
    selectedBtcWave.value = list
            .firstWhereOrNull((element) => element.baseCoin == 'BTC')
            ?.noticeValue ??
        0.0;
    selectedEthWave.value = list
            .firstWhereOrNull((element) => element.baseCoin == 'ETH')
            ?.noticeValue ??
        0.0;
    thresholdOn.value = list.firstWhereOrNull(
            (element) => element.subType == 'price_threshold') !=
        null;
    super.initState();
  }

  void _saveWave(String baseCoin, double value) {
    final item = widget.logic.userAlerts.firstWhereOrNull((p0) =>
        p0.baseCoin == baseCoin && p0.type == NoticeRecordType.priceWave);

    Apis()
        .saveOrUpdateUserAlertConfigs(
      id: item?.id,
      type: NoticeRecordType.priceWave,
      noticeType: '2',
      baseCoin: baseCoin,
      noticeValue: value,
      subType: 'priceWave',
    )
        .then((value) {
      AppConst.eventBus.fire(EventAlertAdded());
    });
  }

  void _deleteAlert(String baseCoin) {
    final item = widget.logic.userAlerts.firstWhereOrNull((p0) =>
        p0.baseCoin == baseCoin && p0.type == NoticeRecordType.priceWave);
    if (item == null) return;
    Apis().deleteUserAlertConfigs(id: item.id).then((value) {
      AppConst.eventBus.fire(EventAlertAdded());
    });
  }

  void _saveThreshold() {
    Apis()
        .saveOrUpdateUserAlertConfigs(
      type: NoticeRecordType.priceWave,
      noticeType: '2',
      baseCoin: 'BTC',
      noticeValue: 10,
      subType: 'price_threshold',
    )
        .then((value) {
      AppConst.eventBus.fire(EventAlertAdded());
    });
  }

  void _deleteThreshold() {
    final item = widget.logic.userAlerts.firstWhereOrNull((p0) =>
        p0.subType == 'price_threshold' &&
        p0.type == NoticeRecordType.priceWave);
    if (item == null) return;
    Apis().deleteUserAlertConfigs(id: item.id).then((value) {
      AppConst.eventBus.fire(EventAlertAdded());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).priceWave5minX('BTC'),
              style: Styles.tsBody_14m(context)),
          const Gap(10),
          Obx(() {
            return Row(
              children: [
                for (int i = 1; i <= 5; i++)
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        selectedBtcWave.value = i / 100;
                        _saveWave('BTC', i / 100);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: i / 100 == selectedBtcWave.value
                                    ? Styles.cMain
                                    : Styles.cLine(context))),
                        child: Text('$i%',
                            style: Styles.tsBody_12m(context).copyWith(
                                color: i / 100 == selectedBtcWave.value
                                    ? Styles.cMain
                                    : null)),
                      ),
                    ),
                  ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      selectedBtcWave.value = 0;
                      _deleteAlert('BTC');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: 0 == selectedBtcWave.value
                                  ? Styles.cMain
                                  : Styles.cLine(context))),
                      child: Text(S.of(context).off,
                          style: Styles.tsBody_12m(context).copyWith(
                              color: 0 == selectedBtcWave.value
                                  ? Styles.cMain
                                  : null)),
                    ),
                  ),
                )
              ],
            );
          }),
          const Gap(15),
          Text(S.of(context).priceWave5minX('ETH'),
              style: Styles.tsBody_14m(context)),
          const Gap(10),
          Obx(() {
            return Row(
              children: [
                for (int i = 1; i <= 5; i++)
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        selectedEthWave.value = i / 100;
                        _saveWave('ETH', i / 100);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: i / 100 == selectedEthWave.value
                                    ? Styles.cMain
                                    : Styles.cLine(context))),
                        child: Text('$i%',
                            style: Styles.tsBody_12m(context).copyWith(
                                color: i / 100 == selectedEthWave.value
                                    ? Styles.cMain
                                    : null)),
                      ),
                    ),
                  ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      selectedEthWave.value = 0;
                      _deleteAlert('ETH');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: 0 == selectedEthWave.value
                                  ? Styles.cMain
                                  : Styles.cLine(context))),
                      child: Text(S.of(context).off,
                          style: Styles.tsBody_12m(context).copyWith(
                              color: 0 == selectedEthWave.value
                                  ? Styles.cMain
                                  : null)),
                    ),
                  ),
                )
              ],
            );
          }),
          const Gap(15),
          Row(
            children: [
              Text('价格关口', style: Styles.tsBody_14m(context)),
              Switch(
                  value: thresholdOn.value,
                  onChanged: (value) {
                    thresholdOn.value = value;
                    if (value) {
                      _saveThreshold();
                    } else {
                      _deleteThreshold();
                    }
                  })
            ],
          ),
        ],
      ),
    );
  }
}
