part of 'alert_configs_view.dart';

class _SignalView extends StatelessWidget {
  const _SignalView(this.logic);

  final AlertManageLogic logic;

  void onDelete(int index) {
    logic.userSignalAlerts.removeAt(index);
  }

  String _getTypeText(String type) {
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
  Widget build(BuildContext context) {
    return SlidableAutoCloseBehavior(
      child: ListView.builder(
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
                  onPressed: (context) {},
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
                  Expanded(
                    flex: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.symbol ?? '',
                            style: Styles.tsBody_12m(context)),
                        const Gap(5),
                        Text(item.exChangeName ?? '',
                            style: Styles.tsSub_12(context)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_getTypeText(item.type ?? ''),
                            style: Styles.tsBody_12(context)),
                        const Gap(5),
                        Text(getWarningTypeText(item.warningType ?? ''),
                            style: Styles.tsBody_12(context)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(item.interval ?? '',
                            style: Styles.tsBody_12(context)),
                        const Gap(5),
                        Text(item.warningParam ?? '',
                            style: Styles.tsBody_12(context)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
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

  @override
  void initState() {
    Apis().getAlertUserSignalConfig().then((value) {
      _list.assignAll(value ?? []);
      selectedSignalConfig.value = _list.first.type;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //todo intl
        title: Text('添加信号提醒'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Text(S.of(context).tradingPair),
          const Gap(10),
          Row(
            children: [
              Expanded(child: Obx(() {
                return _dropDownButton(
                  context,
                  Text(
                      symbol.value == null
                          ? '选择交易对'
                          : symbol.value!.symbol ?? '',
                      style: Styles.tsSub_14(context)),
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
              })),
              const Gap(10),
              _dropDownButton(
                context,
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Obx(() =>
                      Text(interval.value, style: Styles.tsSub_14(context))),
                ),
                onTap: () async {
                  final result = await showCupertinoModalPopup(
                      context: context,
                      builder: (context) => _IntervalDialog(interval.value));
                  interval.value = result;
                },
              ),
            ],
          ),
          GridView(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 40),
            children: _list.map(
              (element) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: selectedSignalConfig.value == element.type
                            ? Styles.cMain
                            : Styles.cLine(context)),
                  ),
                  child: Text(element.type?.toUpperCase() ?? ''),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _dropDownButton(BuildContext context, Widget text,
      {VoidCallback? onTap}) {
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
          children: [text, Icon(Icons.keyboard_arrow_down, size: 20)],
        ),
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
    return Column(
      children: [
        Gap(MediaQuery.of(context).viewPadding.top + kToolbarHeight),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Styles.cScaffoldBackground(context),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
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
                          )),
                    ],
                  ),
                ),
                Expanded(child: Builder(builder: (context) {
                  final list = _textCtrl.text.isEmpty
                      ? widget.symbols
                      : widget.symbols
                          .where((element) =>
                              element.symbol
                                  ?.toLowerCase()
                                  .contains(_textCtrl.text.toLowerCase()) ??
                              false)
                          .toList();
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return ListTile(
                        leading:
                            ImageUtil.coinImage(item.baseCoin ?? '', size: 24),
                        title: Row(
                          children: [
                            Text(
                              item.symbol ?? '',
                              style: Styles.tsBody_14m(context),
                            ),
                            const Gap(5),
                            Text(
                              item.exchangeName ?? '',
                              style: Styles.tsSub_14(context),
                            ),
                          ],
                        ),
                        onTap: () => Navigator.pop(context, item),
                      );
                    },
                  );
                })),
              ],
            ),
          ),
        ),
      ],
    );
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
    return Column(
      children: [
        Gap(MediaQuery.of(context).viewPadding.top + kToolbarHeight),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Styles.cScaffoldBackground(context),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10))),
            child: Column(
              children: [
                Expanded(child: Builder(builder: (context) {
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
                })),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
