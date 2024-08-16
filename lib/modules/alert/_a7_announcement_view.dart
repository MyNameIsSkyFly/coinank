part of 'alert_configs_view.dart';

class _AnnouncementView extends StatefulWidget {
  const _AnnouncementView(this.logic);

  final AlertManageLogic logic;

  @override
  State<_AnnouncementView> createState() => _AnnouncementViewState();
}

class _AnnouncementViewState extends State<_AnnouncementView> {
  final binanceOn = false.obs;
  final okxOn = false.obs;
  final huobiOn = false.obs;
  final upbitOn = false.obs;

  @override
  void initState() {
    final list = widget.logic.userAlerts
        .where((p0) => p0.type == NoticeRecordType.announcement)
        .map((e) => e.baseCoin)
        .toList();
    binanceOn.value = list.contains('Binance');
    okxOn.value = list.contains('Okex');
    huobiOn.value = list.contains('Huobi');
    upbitOn.value = list.contains('Upbit');
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
              ImageUtil.exchangeImage('Binance', size: 24),
              const Gap(10),
              Expanded(
                child: Text('Binance ${S.of(context).announcement}',
                    style: Styles.tsBody_18m(context)),
              ),
              Obx(() {
                return Switch(
                  value: binanceOn.value,
                  onChanged: (value) {
                    binanceOn.value = value;
                    onChanged('Binance', value);
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
              ImageUtil.exchangeImage('Okex', size: 24),
              const Gap(10),
              Expanded(
                child: Text('Okx ${S.of(context).announcement}',
                    style: Styles.tsBody_18m(context)),
              ),
              Obx(() {
                return Switch(
                  value: okxOn.value,
                  onChanged: (value) {
                    okxOn.value = value;
                    onChanged('Okex', value);
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
              ImageUtil.exchangeImage('Huobi', size: 24),
              const Gap(10),
              Expanded(
                child: Text('Huobi ${S.of(context).announcement}',
                    style: Styles.tsBody_18m(context)),
              ),
              Obx(() {
                return Switch(
                  value: huobiOn.value,
                  onChanged: (value) {
                    huobiOn.value = value;
                    onChanged('Huobi', value);
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
              ImageUtil.exchangeImage('Upbit', size: 24),
              const Gap(10),
              Expanded(
                child: Text('Upbit ${S.of(context).announcement}',
                    style: Styles.tsBody_18m(context)),
              ),
              Obx(() {
                return Switch(
                  value: upbitOn.value,
                  onChanged: (value) {
                    upbitOn.value = value;
                    onChanged('Upbit', value);
                  },
                );
              }),
            ],
          ),
        )
      ],
    );
  }

  void onChanged(String baseCoin, bool value) {
    if (value == false) {
      final item = widget.logic.userAlerts.firstWhereOrNull((p0) =>
          p0.baseCoin == baseCoin && p0.type == NoticeRecordType.announcement);
      if (item == null) return;

      Apis().deleteUserAlertConfigs(id: item.id).then((value) {
        AppConst.eventBus.fire(EventAlertAdded());
      });
    } else {
      Apis()
          .saveOrUpdateUserAlertConfigs(
        type: NoticeRecordType.announcement,
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
