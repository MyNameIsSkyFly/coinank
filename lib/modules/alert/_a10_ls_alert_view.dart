part of 'alert_configs_view.dart';

class _LsAlertView extends StatelessWidget {
  const _LsAlertView(this.logic);

  final AlertManageLogic logic;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = logic.userAlerts
          .where((p0) => p0.type == NoticeRecordType.lsAlert)
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${item.baseCoin} ${S.of(context).price}',
                              style: Styles.tsBody_12m(context)),
                          const Gap(5),
                          Text(
                            '${item.subType == 'down' ? S.of(context).fallingBelow : S.of(context).breakthrough}'
                            ': ${item.noticeValue} ${getTypeString(item.noticeType)}',
                            style: Styles.tsSub_12m(context),
                          ),
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

class _LsAlertSettingView extends StatefulWidget {
  const _LsAlertSettingView(this.logic);

  final AlertManageLogic logic;

  @override
  State<_LsAlertSettingView> createState() => _LsAlertSettingViewState();
}

class _LsAlertSettingViewState extends State<_LsAlertSettingView> {
  AlertManageLogic get logic => widget.logic;

  final _symbol = Rxn<OrderFlowSymbolEntity>();

  //accumulate,add,waves
  final _isUp = RxBool(true);
  final _alertValueCtrl = TextEditingController();
  final _type = 0.obs;

  @override
  void dispose() {
    _alertValueCtrl.dispose();
    super.dispose();
  }

  void _save() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_symbol.value == null) {
      AppUtil.showToast('请选择交易对');
      return;
    }

    if (_alertValueCtrl.text.isEmpty) {
      AppUtil.showToast('请输入提醒值');
      return;
    }

    final alertValue = double.parse(_alertValueCtrl.text);

    if (alertValue < 0 || alertValue > 20) {
      AppUtil.showToast('提醒值需在0 ~ 20之间');
      return;
    }
    Apis()
        .saveOrUpdateUserAlertConfigs(
      type: NoticeRecordType.lsAlert,
      subType: _isUp.value ? 'up' : 'down',
      noticeValue: alertValue,
      noticeType: _type.value.toString(),
      baseCoin: _symbol.value?.symbol,
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
          //todo intl
          title: Text('添加信号提醒'),
        ),
        body: ListView(padding: const EdgeInsets.all(15), children: [
          Text(S.of(context).tradingPair),
          const Gap(10),
          Obx(() {
            return _dropDownButton(
              context,
              Text(
                _symbol.value == null
                    ? S.of(context).chooseTradingPair
                    : '${_symbol.value?.symbol}',
                style: Styles.tsSub_14(context),
              ),
              onTap: () async {
                final result = await showCupertinoModalPopup(
                  context: context,
                  builder: (context) => const _LsAlertSymbolSelector(),
                );
                if (result == null) return;
                _symbol.value = result;
              },
            );
          }),
          const Gap(20),
          Text(S.of(context).warningType),
          const Gap(10),
          _dropDownButton(
            context,
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Obx(
                () => Text(
                    _isUp.value
                        ? S.of(context).breakthrough
                        : S.of(context).fallingBelow,
                    style: Styles.tsSub_14(context)),
              ),
            ),
            onTap: () async {
              final result = await showAppPicker<bool>(context,
                  data: [
                    AppPickerNode(S.of(context).breakthrough, customData: true),
                    AppPickerNode(S.of(context).fallingBelow, customData: false)
                  ],
                  title: S.of(context).chooseType);
              if (result == null) return;
              _isUp.value = result;
            },
          ),
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
            ],
          ),
          Obx(() {
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

class _LsAlertSymbolSelector extends StatefulWidget {
  const _LsAlertSymbolSelector();

  @override
  State<_LsAlertSymbolSelector> createState() => _LsAlertSymbolSelectorState();
}

class _LsAlertSymbolSelectorState extends State<_LsAlertSymbolSelector> {
  final tCtrl = TextEditingController();
  final _list = <OrderFlowSymbolEntity>[];
  var loading = true;

  @override
  void initState() {
    Apis()
        .getOrderFlowSymbols(exchangeName: 'Binance')
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
                            Expanded(flex: 4, child: Text(item.symbol ?? '')),
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
