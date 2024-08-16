part of 'alert_configs_view.dart';

class _TransactionView extends StatefulWidget {
  const _TransactionView(this.logic);

  final AlertManageLogic logic;

  @override
  State<_TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<_TransactionView> {
  final btcOn = false.obs;
  final ethOn = false.obs;
  final usdtOn = false.obs;

  @override
  void initState() {
    final list = widget.logic.userAlerts
        .where((p0) => p0.type == NoticeRecordType.transaction)
        .map((e) => e.baseCoin)
        .toList();
    btcOn.value = list.contains('BTC');
    ethOn.value = list.contains('ETH');
    usdtOn.value = list.contains('USDT');
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
              ImageUtil.coinImage('BTC', size: 24),
              const Gap(10),
              Expanded(
                child: Text('BTC ${S.of(context).largeTransaction}',
                    style: Styles.tsBody_18m(context)),
              ),
              Obx(() {
                return Switch(
                  value: btcOn.value,
                  onChanged: (value) {
                    btcOn.value = value;
                    onChanged('BTC', value);
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
              ImageUtil.coinImage('ETH', size: 24),
              const Gap(10),
              Expanded(
                child: Text('ETH ${S.of(context).largeTransaction}',
                    style: Styles.tsBody_18m(context)),
              ),
              Obx(() {
                return Switch(
                  value: ethOn.value,
                  onChanged: (value) {
                    ethOn.value = value;
                    onChanged('ETH', value);
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
              ImageUtil.coinImage('USDT', size: 24),
              const Gap(10),
              Expanded(
                child: Text('USDT ${S.of(context).largeTransaction}',
                    style: Styles.tsBody_18m(context)),
              ),
              Obx(() {
                return Switch(
                  value: usdtOn.value,
                  onChanged: (value) {
                    usdtOn.value = value;
                    onChanged('USDT', value);
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
          p0.baseCoin == baseCoin && p0.type == NoticeRecordType.transaction);
      if (item == null) return;

      Apis().deleteUserAlertConfigs(id: item.id).then((value) {
        AppConst.eventBus.fire(EventAlertAdded());
      });
    } else {
      Apis()
          .saveOrUpdateUserAlertConfigs(
        type: NoticeRecordType.transaction,
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
