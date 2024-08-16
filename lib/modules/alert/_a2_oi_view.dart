part of 'alert_configs_view.dart';

class _OiView extends StatelessWidget {
  const _OiView(this.logic);

  final AlertManageLogic logic;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = logic.userAlerts
          .where((p0) => p0.type == NoticeRecordType.oiAlert)
          .toList();
      return SlidableAutoCloseBehavior(
        child: ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.symmetric(vertical: 15),
          itemBuilder: (context, index) {
            final item = list[index];
            return Slidable(
              key: ValueKey(item.id),
              endActionPane: ActionPane(
                extentRatio: 0.2,
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      Apis().deleteUserAlertConfigs(id: item.id).then((value) {
                        logic.userAlerts
                            .removeWhere((element) => element.id == item.id);
                      });
                    },
                    backgroundColor: const Color(0xFFD8494A),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    label: S.of(context).delete,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    ImageUtil.coinImage(item.baseCoin ?? '', size: 24),
                    const Gap(10),
                    Expanded(
                      flex: 15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${item.baseCoin}',
                              style: Styles.tsBody_12m(context)),
                          const Gap(5),
                          Text('${item.interval}',
                              style: Styles.tsSub_12(context))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              switch (item.subType) {
                                'waves' => '${S.of(context).oiWaves}(%)',
                                'add' => '${S.of(context).oiChanges}(\$)',
                                'accumulate' =>
                                  '${S.of(context).accumulatedOiChange}(\$)',
                                _ => 'unknown'
                              },
                              style: Styles.tsBody_12m(context)),
                          const Gap(5),
                          Text(
                              '${switch (item.subType) {
                                'waves' => '${item.noticeValue}%',
                                'add' ||
                                'accumulate' =>
                                  '\$${AppUtil.getLargeFormatString(item.noticeValue)}',
                                _ => 'unknown'
                              }} ${switch (item.noticeType) {
                                '0' => S.of(context).alertOnce,
                                '1' => S.of(context).alertOnceEveryday,
                                '2' => S.of(context).circularAlert,
                                _ => '',
                              }}',
                              style: Styles.tsSub_12(context))
                        ],
                      ),
                    ),
                    StatefulBuilder(builder: (context, setState) {
                      return Switch(
                        value: item.on == true,
                        onChanged: (value) {
                          item.on = value;
                          setState(() {});
                          Apis()
                              .saveOrUpdateUserAlertConfigs(
                            id: item.id,
                            baseCoin: item.baseCoin,
                            symbol: item.symbol,
                            userId: item.userId,
                            type: item.type,
                            subType: item.subType,
                            noticeValue: item.noticeValue,
                            noticeType: item.noticeType,
                            noticeTime: item.noticeTime,
                            ts: item.ts,
                            interval: item.interval,
                            exchange: item.exchange,
                            on: value,
                          )
                              .catchError(
                            (_) {
                              item.on = !value;
                              setState(() {});
                            },
                          );
                        },
                      );
                    })
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  String getTypeString(String? type) => switch (type) {
        '0' => S.current.alertOnce,
        '1' => S.current.alertOnceEveryday,
        '2' => S.current.circularAlert,
        _ => '',
      };
}

class _OiSettingView extends StatefulWidget {
  const _OiSettingView(this.logic);

  final AlertManageLogic logic;

  @override
  State<_OiSettingView> createState() => _OiSettingViewState();
}

class _OiSettingViewState extends State<_OiSettingView> {
  AlertManageLogic get logic => widget.logic;

  final _coin = Rxn<MarkerTickerEntity>();
  final _interval = RxString('15m');

  //accumulate,add,waves
  final _subType = RxString('waves');
  final _alertValueCtrl = TextEditingController();
  final _type = 0.obs;
  final _marketEntity = Rxn<ContractMarketEntity>();

  @override
  void dispose() {
    _alertValueCtrl.dispose();
    super.dispose();
  }

  void _save() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_coin.value == null) {
      AppUtil.showToast(S.of(context).plsSelectCoin);
      return;
    }

    if (_alertValueCtrl.text.isEmpty) {
      AppUtil.showToast(S.of(context).plsInputAlertValue);
      return;
    }

    if (_subType.value.isEmpty) {
      AppUtil.showToast(S.of(context).plsSelectWarningType);
      return;
    }

    final alertValue = double.parse(_alertValueCtrl.text);
    final minValue = switch (_subType.value) {
      'add' => 1000000,
      'accumulate' => 1000000,
      'waves' => 1,
      _ => null
    };

    if (minValue != null && alertValue < minValue) {
      AppUtil.showToast(S.of(context).alertCantLowerThanX(minValue));
      return;
    }
    Apis()
        .saveOrUpdateUserAlertConfigs(
      type: NoticeRecordType.oiAlert,
      subType: _subType.value,
      noticeValue: alertValue,
      noticeType: _type.value.toString(),
      baseCoin: _coin.value?.baseCoin,
      interval: _interval.value,
      symbol: _marketEntity.value?.symbol,
    )
        .then((value) {
      AppConst.eventBus.fire(EventAlertAdded());
      Get.back();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).addXAlert(S.of(context).s_oi)),
        ),
        body: ListView(padding: const EdgeInsets.all(15), children: [
          Text(S.of(context).symbol),
          const Gap(10),
          Row(children: [
            Expanded(
              child: Obx(() {
                return _dropDownButton(
                  context,
                  Text(
                    _coin.value == null
                        ? S.of(context).selectCoin
                        : '${_coin.value?.baseCoin}${AppUtil.getLargeFormatString(_coin.value?.openInterest, precision: 4)}',
                    style: Styles.tsSub_14(context),
                  ),
                  onTap: () async {
                    final result = await showCupertinoModalPopup(
                      context: context,
                      builder: (context) => const _OiBaseCoinSelector(),
                    );
                    if (result == null) return;
                    _coin.value = result;
                    _marketEntity.value = null;
                  },
                );
              }),
            ),
            Obx(() {
              if (_subType.value == 'accumulate') {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(left: 10),
                child: _dropDownButton(
                  context,
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Obx(
                      () => Text(_interval.value,
                          style: Styles.tsSub_14(context)),
                    ),
                  ),
                  onTap: () async {
                    final result = await showAppStringPicker(context,
                        data: ['15m', '30m', '1h', '4h', '24h'],
                        title: S.of(context).s_choose_time);
                    if (result == null) return;
                    _interval.value = result;
                  },
                ),
              );
            }),
          ]),
          const Gap(20),
          Text(S.of(context).warningType),
          const Gap(10),
          _dropDownButton(
            context,
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Obx(
                () => Text(
                    switch (_subType.value) {
                      'waves' => '${S.of(context).oiWaves}(%)',
                      'add' => '${S.of(context).oiChanges}(\$)',
                      'accumulate' =>
                        '${S.of(context).accumulatedOiChange}(\$)',
                      _ => 'unknown'
                    },
                    style: Styles.tsSub_14(context)),
              ),
            ),
            onTap: () async {
              final result = await showAppPicker<String>(context,
                  data: [
                    AppPickerNode('${S.of(context).oiWaves}(%)',
                        customData: 'waves'),
                    AppPickerNode('${S.of(context).oiChanges}(\$)',
                        customData: 'add'),
                    AppPickerNode('${S.of(context).accumulatedOiChange}(\$)',
                        customData: 'accumulate')
                  ],
                  title: S.of(context).s_choose_time);
              if (result == null) return;
              _subType.value = result;
            },
          ),
          Obx(() {
            if (_subType.value != 'accumulate') return const SizedBox();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(20),
                Text('${S.of(context).tradingPair}(${S.of(context).optional})'),
                const Gap(10),
                _dropDownButton(
                  context,
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _marketEntity.value == null
                                ? ''
                                : '${_marketEntity.value?.exchangeName}   ${_marketEntity.value?.symbol} \$${AppUtil.getLargeFormatString(_marketEntity.value?.oiUSD, precision: 4)}',
                            style: Styles.tsSub_14(context),
                          ),
                        ),
                        if (_marketEntity.value != null)
                          InkWell(
                              onTap: () => _marketEntity.value = null,
                              child: const Icon(CupertinoIcons.xmark_circle,
                                  size: 20)),
                        const Gap(15),
                      ],
                    ),
                  ),
                  onTap: () async {
                    if (_coin.value == null) {
                      AppUtil.showToast(S.of(context).plsSelectCoin);
                      return;
                    }
                    final result = await showCupertinoModalPopup(
                      context: context,
                      builder: (context) => _OiSymbolSelector(
                          baseCoin: _coin.value?.baseCoin ?? ''),
                    );
                    if (result == null) return;
                    _marketEntity.value = result;
                  },
                ),
              ],
            );
          }),
          const Gap(20),
          Text(S.of(context).alertValue),
          const Gap(10),
          Row(
            children: [
              SizedBox(
                width: 108,
                child: TextField(
                  controller: _alertValueCtrl,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*'))
                  ],
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    isCollapsed: true,
                    isDense: true,
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Styles.cTextFieldFill(context),
                  ),
                ),
              ),
              Obx(() {
                return Text(' >= ${switch (_subType.value) {
                  'waves' => '1',
                  'add' => '1000000',
                  'accumulate' => '1000000',
                  _ => 'unknown'
                }}');
              })
            ],
          ),
          Obx(() {
            if (_subType.value == 'accumulate') {
              return const SizedBox();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(20),
                Text(S.of(context).alertCount),
                const Gap(10),
                Row(children: [
                  _typeButton(0, S.of(context).alertOnce),
                  const Gap(10),
                  _typeButton(1, S.of(context).alertOnceEveryday),
                  const Gap(10),
                  _typeButton(2, S.of(context).circularAlert),
                ]),
              ],
            );
          })
          // F
          ,
          const Gap(30),
          FilledButton(onPressed: _save, child: Text(S.of(context).save))
          // illedButton(onPressed: _save, child: Text(S.of(context).save))
        ]),
      ),
    );
  }

  Widget _typeButton(int typeIndex, String title) {
    return Expanded(
      child: InkWell(
        onTap: () => _type.value = typeIndex,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: _type.value == typeIndex
                      ? Styles.cMain
                      : Styles.cLine(context))),
          child: Text(title),
        ),
      ),
    );
  }

  Widget _dropDownButton(
    BuildContext context,
    Widget text, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Styles.cTextFieldFill(context),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [text, const Icon(Icons.keyboard_arrow_down, size: 20)]),
      ),
    );
  }
}

class _OiBaseCoinSelector extends StatefulWidget {
  const _OiBaseCoinSelector({super.key});

  @override
  State<_OiBaseCoinSelector> createState() => _OiBaseCoinSelectorState();
}

class _OiBaseCoinSelectorState extends State<_OiBaseCoinSelector> {
  final tCtrl = TextEditingController();
  final _list = <MarkerTickerEntity>[];
  var loading = true;

  @override
  void initState() {
    Apis().getFuturesBigData(page: 1, size: 200).then((value) => setState(() {
          loading = false;
          _list.assignAll(value?.list ?? []);
        }));
    super.initState();
  }

  @override
  void dispose() {
    tCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Gap(MediaQuery.of(context).viewPadding.top + kToolbarHeight),
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Styles.cScaffoldBackground(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: tCtrl,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                        filled: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                        prefixIcon: const Icon(CupertinoIcons.search),
                        hintText: S.of(context).s_search),
                  )),
                  const Gap(10),
                  GestureDetector(
                      onTap: Get.back,
                      child: Text(S.of(context).s_cancel,
                          style: Styles.tsSub_16(context)))
                ],
              ),
            ),
            Expanded(
              child: Builder(builder: (context) {
                if (loading) return const LottieIndicator();
                if (_list.isEmpty) return const Center(child: EmptyView());
                final list = tCtrl.text.isEmpty
                    ? _list
                    : _list
                        .where((element) =>
                            element.baseCoin
                                ?.toLowerCase()
                                .contains(tCtrl.text.toLowerCase()) ??
                            false)
                        .toList();
                return ListView.builder(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewPadding.bottom),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return ListTile(
                      leading:
                          ImageUtil.coinImage(item.baseCoin ?? '', size: 24),
                      title: Text(item.baseCoin ?? ''),
                      trailing: Text(
                          '\$${AppUtil.getLargeFormatString(item.openInterest, precision: 4)}',
                          style: Styles.tsSub_12(context)),
                      onTap: () => Get.back(result: item),
                    );
                  },
                );
              }),
            ),
          ]),
        ),
      ),
    ]);
  }
}

class _OiSymbolSelector extends StatefulWidget {
  const _OiSymbolSelector({super.key, required this.baseCoin});

  final String baseCoin;

  @override
  State<_OiSymbolSelector> createState() => _OiSymbolSelectorState();
}

class _OiSymbolSelectorState extends State<_OiSymbolSelector> {
  final tCtrl = TextEditingController();
  final _list = <ContractMarketEntity>[];
  var loading = true;

  @override
  void initState() {
    Apis()
        .getContractMarketData(baseCoin: widget.baseCoin)
        .then((value) => setState(() {
              loading = false;
              _list.assignAll(value ?? []);
            }));
    super.initState();
  }

  @override
  void dispose() {
    tCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Gap(MediaQuery.of(context).viewPadding.top + kToolbarHeight),
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Styles.cScaffoldBackground(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: tCtrl,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                        filled: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                        prefixIcon: const Icon(CupertinoIcons.search),
                        hintText: S.of(context).s_search),
                  )),
                  const Gap(10),
                  GestureDetector(
                      onTap: Get.back,
                      child: Text(S.of(context).s_cancel,
                          style: Styles.tsSub_16(context)))
                ],
              ),
            ),
            Expanded(
              child: Builder(builder: (context) {
                if (loading) return const LottieIndicator();
                if (_list.isEmpty) return const Center(child: EmptyView());
                final list = tCtrl.text.isEmpty
                    ? _list
                    : _list
                        .where((element) =>
                            element.symbol
                                    ?.toLowerCase()
                                    .contains(tCtrl.text.toLowerCase()) ==
                                true ||
                            element.exchangeName
                                    ?.toLowerCase()
                                    .contains(tCtrl.text.toLowerCase()) ==
                                true)
                        .toList();
                return ListView.builder(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewPadding.bottom),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return InkWell(
                      onTap: () => Get.back(result: item),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 4, child: Text(item.exchangeName ?? '')),
                            Expanded(flex: 7, child: Text(item.symbol ?? '')),
                            Expanded(
                                flex: 8,
                                child: Text(
                                    '\$${AppUtil.getLargeFormatString(item.oiUSD, precision: 4)}',
                                    textAlign: TextAlign.end)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ]),
        ),
      ),
    ]);
  }
}
