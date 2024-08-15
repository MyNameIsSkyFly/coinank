part of 'alert_configs_view.dart';

class _FundingRateView extends StatefulWidget {
  const _FundingRateView(this.logic);

  final AlertManageLogic logic;

  @override
  State<_FundingRateView> createState() => _FundingRateViewState();
}

class _FundingRateViewState extends State<_FundingRateView> {
  final btcOn = false.obs;
  final ethOn = false.obs;
  final topOn = false.obs;

  @override
  void initState() {
    final list = widget.logic.userAlerts
        .where((p0) => p0.type == NoticeRecordType.fundingRate)
        .map((e) => e.baseCoin)
        .toList();
    btcOn.value = list.contains('BTC');
    ethOn.value = list.contains('ETH');
    topOn.value = list.contains('TOP 3 & LAST 3');
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BTC ${S.of(context).s_funding_rate}',
                        style: Styles.tsBody_12m(context)),
                    const Gap(5),
                    Text('大于0.03% 或小于-0.03%',
                        // switch (item.baseCoin) {
                        //   'BTC' => '',
                        //   'ETH' => '大于0.03% 或小于-0.03%',
                        //   _ => '资金费率前三和后三',
                        // },
                        style: Styles.tsSub_12(context))
                  ],
                ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ETH ${S.of(context).s_funding_rate}',
                        style: Styles.tsBody_12m(context)),
                    const Gap(5),
                    Text('大于0.03% 或小于-0.03%',
                        // switch (item.baseCoin) {
                        //   'BTC' => '',
                        //   'ETH' => '大于0.03% 或小于-0.03%',
                        //   _ => '资金费率前三和后三',
                        // },
                        style: Styles.tsSub_12(context))
                  ],
                ),
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
              Image.asset(Assets.commonIcTop3, width: 24, height: 24),
              const Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TOP 3 & LAST 3', style: Styles.tsBody_12m(context)),
                    const Gap(5),
                    Text('资金费率前三和后三', style: Styles.tsSub_12(context))
                  ],
                ),
              ),
              Obx(() {
                return Switch(
                  value: topOn.value,
                  onChanged: (value) {
                    topOn.value = value;
                    onChanged('TOP 3 & LAST 3', value);
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
          p0.baseCoin == baseCoin && p0.type == NoticeRecordType.fundingRate);
      if (item == null) return;

      Apis().deleteUserAlertConfigs(id: item.id).then((value) {
        AppConst.eventBus.fire(EventAlertAdded());
      });
    } else {
      Apis()
          .saveOrUpdateUserAlertConfigs(
        type: NoticeRecordType.fundingRate,
        noticeType: '2',
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
