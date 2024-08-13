part of 'alert_configs_view.dart';

class _SignalView extends StatelessWidget {
  const _SignalView(this.logic);

  final AlertManageLogic logic;

  void onDelete(int index) {
    logic.userSignalAlerts.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return SlidableAutoCloseBehavior(
      child: Obx(() {
        return ListView.builder(
          itemCount: logic.userSignalAlerts.length,
          itemBuilder: (context, index) {
            final item = logic.userSignalAlerts[index];
            return Slidable(
              key: ValueKey(item.id),
              endActionPane: ActionPane(
                extentRatio: 0.2,
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      Apis().deleteUserSignalConfig(id: item.id).then(
                            (value) => logic.userSignalAlerts.removeWhere(
                              (element) => element.id == item.id,
                            ),
                          );
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
                child: Row(children: [
                  Expanded(
                    flex: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.symbol ?? '',
                          style: Styles.tsBody_12m(context),
                        ),
                        const Gap(5),
                        Text(
                          item.exChangeName ?? '',
                          style: Styles.tsSub_12(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          logic.getTypeText(item.type ?? ''),
                          style: Styles.tsBody_12(context),
                        ),
                        const Gap(5),
                        Text(
                          logic.getWarningTypeText(item.warningType ?? ''),
                          style: Styles.tsBody_12(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item.interval ?? '',
                          style: Styles.tsBody_12(context),
                        ),
                        const Gap(5),
                        Text(
                          item.warningParam ?? '',
                          style: Styles.tsBody_12(context),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            );
          },
        );
      }),
    );
  }
}

class _SignalSettingView extends StatefulWidget {
  const _SignalSettingView(this.logic);

  final AlertManageLogic logic;

  @override
  State<_SignalSettingView> createState() => _SignalSettingViewState();
}

class _SignalSettingViewState extends State<_SignalSettingView> {
  AlertManageLogic get logic => widget.logic;

  final symbol = Rxn<OrderFlowSymbolEntity>();
  final interval = RxString('15m');
  final _list = RxList<WarningTypesEntity>();
  final selectedSignalConfig = RxnString();
  final selectedWaringType = RxnString();
  final defaultParams = RxList<String>();

  final tCtrl1 = TextEditingController();
  final tCtrl2 = TextEditingController();
  final tCtrl3 = TextEditingController();
  final tCtrl4 = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Loading.wrap(
        () => Apis().getAlertUserSignalConfig().then((value) {
          _list.assignAll(value ?? []);
          selectedSignalConfig.value = _list.first.type;
          final warningTypeEntity = _list.first.warningTypes?.firstOrNull;
          selectedWaringType.value = warningTypeEntity?.warnType;
          defaultParams.assignAll(
              warningTypeEntity?.defaultParam?.split(',').toList() ?? []);

          _setTextControllers();
        }),
      );
    });
  }

  void _setTextControllers() {
    if (defaultParams.isNotEmpty) tCtrl1.text = defaultParams[0] ?? '';
    if (defaultParams.length > 1) tCtrl2.text = defaultParams[1] ?? '';
    if (defaultParams.length > 2) tCtrl3.text = defaultParams[2] ?? '';
    if (defaultParams.length > 3) tCtrl4.text = defaultParams[3] ?? '';
  }

  @override
  void dispose() {
    tCtrl1.dispose();
    tCtrl2.dispose();
    tCtrl3.dispose();
    tCtrl4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          //todo intl
          title: Text('添加信号提醒'),
        ),
        body: ListView(padding: const EdgeInsets.all(15), children: [
          Text(S.of(context).tradingPair),
          const Gap(10),
          Row(children: [
            Expanded(
              child: Obx(() {
                return _dropDownButton(
                  context,
                  Text(
                    symbol.value == null
                        ? S.of(context).chooseTradingPair
                        : symbol.value!.symbol ?? '',
                    style: Styles.tsSub_14(context),
                  ),
                  onTap: () async {
                    await widget.logic.getSymbol();
                    if (!context.mounted) return;
                    final result = await showCupertinoModalPopup(
                      context: context,
                      builder: (context) =>
                          _SymbolsDialog(widget.logic.symbols),
                    );
                    symbol.value = result;
                  },
                );
              }),
            ),
            const Gap(10),
            _dropDownButton(
              context,
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Obx(
                  () => Text(interval.value, style: Styles.tsSub_14(context)),
                ),
              ),
              onTap: () async {
                final result = await showCupertinoModalPopup(
                  context: context,
                  builder: (context) => _IntervalDialog(interval.value),
                );
                interval.value = result;
              },
            ),
          ]),
          const Gap(20),
          Text(S.of(context).signalType),
          const Gap(10),
          Obx(() {
            return GridView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 40,
              ),
              children: _list.map((element) {
                final selected = selectedSignalConfig.value == element.type;
                return InkWell(
                  onTap: () {
                    selectedSignalConfig.value = element.type;
                    final warningTypeEntity = _list
                        .where((e) => e.type == element.type)
                        .first
                        .warningTypes
                        ?.firstOrNull;
                    selectedWaringType.value = warningTypeEntity?.warnType;
                    defaultParams.assignAll(
                        warningTypeEntity?.defaultParam?.split(',').toList() ??
                            []);
                    _setTextControllers();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selected ? Styles.cMain : Styles.cLine(context),
                      ),
                    ),
                    child: Text(
                      logic.getTypeText(element.type ?? ''),
                      style: Styles.tsBody_14(
                        context,
                      ).copyWith(color: selected ? Styles.cMain : null),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
          Obx(() {
            if (selectedSignalConfig.value == null) {
              return const SizedBox();
            } else {
              final item = _list.firstWhere(
                (element) => element.type == selectedSignalConfig.value,
              );
              final warningTypes = item.warningTypes ?? [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).warningType),
                  const Gap(10),
                  Obx(() {
                    return Wrap(
                      children: warningTypes.map((e) {
                        final selected = selectedWaringType.value == e.warnType;
                        return InkWell(
                          onTap: () {
                            selectedWaringType.value = e.warnType;
                            defaultParams.assignAll(
                              e.defaultParam?.split(',').toList() ?? [],
                            );
                            _setTextControllers();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: selected
                                    ? Styles.cMain
                                    : Styles.cLine(context),
                              ),
                            ),
                            child: Text(
                              logic.getWarningTypeText(e.warnType ?? ''),
                              style: Styles.tsBody_14(context).copyWith(
                                color: selected ? Styles.cMain : null,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              );
            }
          }),
          const Gap(20),
          Obx(() {
            const inputDecoration = InputDecoration(
                filled: true, contentPadding: EdgeInsets.all(10));
            return Column(
              children: [
                Row(
                  children: [
                    if (defaultParams.isNotEmpty)
                      Expanded(child: Text(getParamsTitle(index: 0))),
                    const Gap(10),
                    if (defaultParams.length > 1)
                      Expanded(child: Text(getParamsTitle(index: 1))),
                    const Gap(10),
                    if (defaultParams.length > 2)
                      Expanded(child: Text(getParamsTitle(index: 2))),
                    const Gap(10),
                    if (defaultParams.length > 3)
                      Expanded(child: Text(getParamsTitle(index: 3))),
                  ],
                ),
                const Gap(10),
                Row(
                  children: [
                    if (defaultParams.isNotEmpty)
                      Expanded(
                          child: TextField(
                        controller: tCtrl1,
                        decoration: inputDecoration,
                      )),
                    const Gap(10),
                    if (defaultParams.length > 1)
                      Expanded(
                          child: TextField(
                        controller: tCtrl2,
                        decoration: inputDecoration,
                      )),
                    const Gap(10),
                    if (defaultParams.length > 2)
                      Expanded(
                          child: TextField(
                        controller: tCtrl3,
                        decoration: inputDecoration,
                      )),
                    const Gap(10),
                    if (defaultParams.length > 3)
                      Expanded(
                          child: TextField(
                        controller: tCtrl4,
                        decoration: inputDecoration,
                      )),
                  ],
                ),
              ],
            );
          }),
          const Gap(20),
          FilledButton(onPressed: _save, child: Text(S.of(context).save))
        ]),
      ),
    );
  }

  void _save() {
    if (symbol.value == null) {
      AppUtil.showToast('请选择交易对');
      return;
    }
    if (_list.isEmpty) {
      AppUtil.showToast('Error');
      return;
    }
    final params = <String>[];
    if (defaultParams.isNotEmpty) params.add(tCtrl1.text);
    if (defaultParams.length > 1) params.add(tCtrl2.text);
    if (defaultParams.length > 2) params.add(tCtrl3.text);
    if (defaultParams.length > 3) params.add(tCtrl4.text);
    Loading.wrap(() => Apis().saveOrUpdateUserSignalConfig(
          exName: symbol.value!.exchangeName,
          interval: interval.value,
          symbol: symbol.value!.symbol,
          type: selectedSignalConfig.value,
          warningType: selectedWaringType.value,
          warningParam: params.join(','),
        )).then((value) {
      Get.back();
      Apis()
          .getAlertUserSignalList()
          .then((value) => logic.userSignalAlerts.assignAll(value ?? []));
    });
  }

  String getParamsTitle({required int index}) {
    final warnType = selectedWaringType.value ?? '';
    return switch (warnType.toLowerCase()) {
      'macdcross' ||
      'kdjcross' ||
      'rsicross' ||
      'emacross' ||
      'bbicross' ||
      'tdcross' =>
        '${selectedWaringType.value} $index',
      'bollcross' =>
        index == 0 ? S.of(context).period : S.of(context).bandWidth,
      'buy_sell_point' =>
        index == 0 ? S.of(context).period : S.of(context).bandWidthFactor,
      'unbalance' => switch (index) {
          0 => S.of(context).imbalanceMulti,
          1 => S.of(context).stackedCount,
          2 => S.of(context).tickCount,
          _ => '',
        },
      _ => ''
    };
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
        //todo intl
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [text, Icon(Icons.keyboard_arrow_down, size: 20)]),
      ),
    );
  }
}

class _SymbolsDialog extends StatefulWidget {
  const _SymbolsDialog(this.symbols);

  final List<OrderFlowSymbolEntity> symbols;

  @override
  State<_SymbolsDialog> createState() => _SymbolsDialogState();
}

class _SymbolsDialogState extends State<_SymbolsDialog> {
  final _textCtrl = TextEditingController();

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Gap(MediaQuery.of(context).viewPadding.top + kToolbarHeight),
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Styles.cScaffoldBackground(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _textCtrl,
                    onChanged: (value) => setState(() {}),
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      filled: true,
                      hintText: S.of(context).s_search,
                      prefixIcon: const Align(
                        widthFactor: 1,
                        child: ImageIcon(
                          AssetImage(Assets.commonIconSearch),
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: Get.back,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      S.of(context).s_cancel,
                      style: Styles.tsSub_16(context).medium,
                    ),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: Builder(builder: (context) {
                final list = _textCtrl.text.isEmpty
                    ? widget.symbols
                    : widget.symbols
                        .where(
                          (element) =>
                              element.symbol?.toLowerCase().contains(
                                    _textCtrl.text.toLowerCase(),
                                  ) ??
                              false,
                        )
                        .toList();
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return ListTile(
                      leading: ImageUtil.coinImage(
                        item.baseCoin ?? '',
                        size: 24,
                      ),
                      title: Row(children: [
                        Text(
                          item.symbol ?? '',
                          style: Styles.tsBody_14m(context),
                        ),
                        const Gap(5),
                        Text(
                          item.exchangeName ?? '',
                          style: Styles.tsSub_14(context),
                        ),
                      ]),
                      onTap: () => Navigator.pop(context, item),
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

class _IntervalDialog extends StatelessWidget {
  _IntervalDialog(this.initialValue);

  final String initialValue;
  final _list = [
    '3m', '5m', '15m', '30m', '1h', '2h', //1
    '4h', '6h', '12h', '1d', '1W', '1M', //2
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Gap(MediaQuery.of(context).viewPadding.top + kToolbarHeight),
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Styles.cScaffoldBackground(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Column(children: [
            Expanded(
              child: Builder(builder: (context) {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _list.length,
                  itemBuilder: (context, index) {
                    final item = _list[index];
                    return ListTile(
                      title: Text(item),
                      trailing: initialValue == item
                          ? const Icon(Icons.check, color: Styles.cMain)
                          : null,
                      onTap: () => Navigator.pop(context, item),
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
