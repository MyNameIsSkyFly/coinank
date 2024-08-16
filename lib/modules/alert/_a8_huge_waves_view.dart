part of 'alert_configs_view.dart';

class _HugeWavesView extends StatefulWidget {
  const _HugeWavesView(this.logic);

  final AlertManageLogic logic;

  @override
  State<_HugeWavesView> createState() => _HugeWavesViewState();
}

class _HugeWavesViewState extends State<_HugeWavesView> {
  final signalOn = false.obs;
  final openSignalOn = false.obs;

  @override
  void initState() {
    final list = widget.logic.userAlerts
        .where((p0) => p0.type == NoticeRecordType.hugeWaves)
        .map((e) => e.baseCoin)
        .toList();
    signalOn.value = list.contains('signal');
    openSignalOn.value = list.contains('openSignal');
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
                child: Text(S.of(context).marketHugeWaves,
                    style: Styles.tsBody_18m(context)),
              ),
              Obx(() {
                return Switch(
                  value: signalOn.value,
                  onChanged: (value) {
                    signalOn.value = value;
                    onChanged('signal', value);
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
                child: Text(S.of(context).oiHugeWaves,
                    style: Styles.tsBody_18m(context)),
              ),
              Obx(() {
                return Switch(
                  value: openSignalOn.value,
                  onChanged: (value) {
                    openSignalOn.value = value;
                    onChanged('openSignal', value);
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
          p0.baseCoin == baseCoin && p0.type == NoticeRecordType.hugeWaves);
      if (item == null) return;

      Apis().deleteUserAlertConfigs(id: item.id).then((value) {
        AppConst.eventBus.fire(EventAlertAdded());
      });
    } else {
      Apis()
          .saveOrUpdateUserAlertConfigs(
        type: NoticeRecordType.hugeWaves,
        noticeType: '',
        baseCoin: baseCoin,
        subType: '',
        noticeValue: 0,
      )
          .then((value) {
        AppConst.eventBus.fire(EventAlertAdded());
      });
    }
  }
}
