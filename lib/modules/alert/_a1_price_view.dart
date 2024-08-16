part of 'alert_configs_view.dart';

class _PriceView extends StatelessWidget {
  const _PriceView(this.logic);

  final AlertManageLogic logic;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = logic.userAlerts
          .where((p0) => p0.type == NoticeRecordType.price)
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${item.baseCoin} ${S.of(context).price}',
                              style: Styles.tsBody_12m(context)),
                          const Gap(5),
                          Text(
                            '${item.subType == 'down' ? S.of(context).lowerThan : S.of(context).higherThan}'
                            ': \$${item.noticeValue} ${getTypeString(item.noticeType)}',
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

class _PriceSettingView extends StatefulWidget {
  const _PriceSettingView(this.logic);

  final AlertManageLogic logic;

  @override
  State<_PriceSettingView> createState() => _PriceSettingViewState();
}

class _PriceSettingViewState extends State<_PriceSettingView> {
  final _list = RxList<MarkerTickerEntity>();
  final tCtrl = TextEditingController();
  var _loading = true;

  @override
  void initState() {
    Apis().getFuturesBigData(page: 1, size: 200).then((value) {
      _list.assignAll(value?.list ?? []);
      setState(() => _loading = false);
    });
    super.initState();
  }

  void search() {
    Apis()
        .getFuturesBigData(
          page: 1,
          size: 200,
          baseCoin: tCtrl.text,
          like: true,
        )
        .then((value) => _list.assignAll(value?.list ?? []));
  }

  @override
  void dispose() {
    tCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).addXAlert(S.of(context).price)),
        ),
        body: _loading
            ? const LottieIndicator()
            : Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: TextField(
                      controller: tCtrl,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^-?\d*\.?\d*'))
                      ],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                          prefixIcon: const Icon(CupertinoIcons.search),
                          hintText: S.of(context).s_search,
                          contentPadding: EdgeInsets.zero,
                          suffixIcon: tCtrl.text.isEmpty
                              ? null
                              : GestureDetector(
                                  onTap: () {
                                    tCtrl.clear();
                                    search();
                                    setState(() {});
                                  },
                                  child: const Icon(
                                      CupertinoIcons.xmark_circle_fill))),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        search();
                        setState(() {});
                      },
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      return ListView.builder(
                        itemCount: _list.length,
                        itemBuilder: (context, index) {
                          final item = _list[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 13),
                            child: Row(
                              children: [
                                ImageUtil.coinImage(item.baseCoin ?? '',
                                    size: 24),
                                const Gap(10),
                                Expanded(
                                    flex: 3,
                                    child: Text(item.baseCoin ?? '',
                                        style: Styles.tsBody_12m(context))),
                                Expanded(
                                    flex: 3,
                                    child: Text('${item.price}',
                                        style: Styles.tsBody_12m(context))),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                        '${item.priceChangeH24?.toStringAsFixed(2)}%',
                                        style: Styles.tsBody_12m(context)
                                            .copyWith(
                                                color: (item.priceChangeH24 ??
                                                            0) >=
                                                        0
                                                    ? Styles.cUp(context)
                                                    : Styles.cDown(context)))),
                                Expanded(
                                    child: SizedBox.square(
                                  dimension: 24,
                                  child: IconButton(
                                    style: IconButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                      shape: const CircleBorder(),
                                      side: BorderSide(
                                        color: Styles.cLine(context),
                                      ),
                                    ),
                                    onPressed: () {
                                      showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) =>
                                            _PriceAlertDialog(item: item),
                                      );
                                    },
                                    icon: const Icon(CupertinoIcons.gear,
                                        size: 16),
                                  ),
                                )),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}

class _PriceAlertDialog extends StatefulWidget {
  const _PriceAlertDialog({super.key, required this.item});

  final MarkerTickerEntity item;

  @override
  State<_PriceAlertDialog> createState() => _PriceAlertDialogState();
}

class _PriceAlertDialogState extends State<_PriceAlertDialog> {
  final tCtrl = TextEditingController();
  final type = RxInt(0);

  @override
  void dispose() {
    tCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          15,
          20,
          15,
          max(MediaQuery.viewPaddingOf(context).bottom,
                  MediaQuery.viewInsetsOf(context).bottom) +
              20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Styles.cScaffoldBackground(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(S.of(context).setAlertPrice,
                      style: Styles.tsBody_16(context))),
              GestureDetector(
                  child: Text(
                S.of(context).s_cancel,
                style: Styles.tsSub_16(context),
              ))
            ],
          ),
          const Gap(30),
          Text(
              '${widget.item.baseCoin} ${S.of(context).price}: \$${widget.item.price}'),
          const Gap(20),
          Text(S.of(context).alertPrice),
          const Gap(10),
          TextField(
            controller: tCtrl,
            decoration: InputDecoration(
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              hintText: S.of(context).inputAlertPrice,
            ),
          ),
          const Gap(20),
          Text(S.of(context).alertCount),
          const Gap(10),
          Obx(() {
            return Row(
              children: [
                _typeButton(0, S.of(context).alertOnce),
                const Gap(10),
                _typeButton(1, S.of(context).alertOnceEveryday),
                const Gap(10),
                _typeButton(2, S.of(context).circularAlert),
              ],
            );
          }),
          const Gap(30),
          FilledButton(onPressed: _save, child: Text(S.of(context).save))
        ],
      ),
    );
  }

  Widget _typeButton(int typeIndex, String title) {
    return Expanded(
      child: InkWell(
        onTap: () => type.value = typeIndex,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: type.value == typeIndex
                      ? Styles.cMain
                      : Styles.cLine(context))),
          child: Text(title),
        ),
      ),
    );
  }

  void _save() {
    final price = double.tryParse(tCtrl.text);
    if (price == null) {
      AppUtil.showToast('Wrong Price');
      return;
    }
    final isUp = price > (widget.item.price ?? 0);
    Apis()
        .saveOrUpdateUserAlertConfigs(
      type: NoticeRecordType.price,
      subType: isUp ? 'up' : 'down',
      noticeValue: price,
      noticeType: '${type.value}',
      baseCoin: widget.item.baseCoin,
    )
        .then(
      (value) {
        AppConst.eventBus.fire(EventAlertAdded());
        Get
          ..back()
          ..back();
      },
    );
  }
}
