part of 'order_flow_view.dart';

class _CoinDialogWithInterceptor extends StatefulWidget {
  const _CoinDialogWithInterceptor();

  @override
  State<_CoinDialogWithInterceptor> createState() =>
      _CoinDialogWithInterceptorState();
}

class _CoinDialogWithInterceptorState extends State<_CoinDialogWithInterceptor>
    with TickerProviderStateMixin {
  // late TabController tabCtrl1;
  late TabController tabCtrl2;
  final originalList = <OrderFlowSymbolEntity>[];
  final list = RxList<OrderFlowSymbolEntity>();
  final exchanges = RxSet<String>({S.current.s_all});
  final priceAsc = RxnBool();
  final priceChgAsc = RxnBool();

  @override
  void initState() {
    super.initState();
    tabCtrl2 = TabController(length: 5, vsync: this, initialIndex: 1);
    getDataFromLastFetch();

    getData();
  }

  final currentExchange = RxnString();
  String? currentProductType;
  String? currentKeyword;

  final productTypes = const ['SWAP', 'FUTURES', 'SPOT'];
  var isFavorite = false;

  Iterable<OrderFlowSymbolEntity> get filteredList {
    List<OrderFlowSymbolEntity> tmpList = originalList.toList();
    if (priceChgAsc.value != null) {
      tmpList.sort((a, b) =>
          (priceChgAsc.value == true
              ? a.priceChangeH24?.compareTo(b.priceChangeH24 ?? 0)
              : b.priceChangeH24?.compareTo(a.priceChangeH24 ?? 0)) ??
          0);
    }
    if (priceAsc.value != null) {
      tmpList.sort((a, b) =>
          (priceAsc.value == true
              ? a.price?.compareTo(b.price ?? 0)
              : b.price?.compareTo(a.price ?? 0)) ??
          0);
    }
    if (isFavorite) {
      return tmpList.where((element) => element.follow == true);
    }
    return tmpList.where((element) =>
        (currentProductType == null ||
            element.productType == currentProductType) &&
        (currentExchange.value == null ||
            element.exchangeName == currentExchange.value) &&
        (currentKeyword == null ||
            element.symbol?.contains(currentKeyword!) == true));
  }

  void getDataFromLastFetch() {
    originalList.assignAll(StoreLogic.to.orderFlowSymbolsJson);
    list.assignAll(StoreLogic.to.orderFlowSymbolsJson);
    for (var o in originalList) {
      o.exchangeName?.let((it) => exchanges.add(it));
    }
  }

  Future<void> getData() async {
    final result = await Future.wait([
      Apis().getOrderFlowSymbols(),
      Apis().getOrderFlowSymbols(productType: 'SPOT'),
    ]).then((value) => [
          ...value[0] ?? <OrderFlowSymbolEntity>[],
          ...value[1] ?? <OrderFlowSymbolEntity>[]
        ]);
    var tmp =
        result.where((e) => productTypes.any((e2) => e.productType == e2));
    for (var o in tmp) {
      o.exchangeName?.let((it) => exchanges.add(it));
    }
    originalList.assignAll(tmp);
    list.assignAll(tmp);
    StoreLogic.to.saveOrderFlowSymbolsJson(tmp.toList());
  }

  @override
  void dispose() {
    super.dispose();
    tabCtrl2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (Platform.isIOS)
          Container(
            constraints: BoxConstraints(
                minHeight: AppConst.height, maxHeight: AppConst.height),
            child: PointerInterceptor(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Get.back(),
                child: Container(),
              ),
            ),
          ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).viewPadding.top -
                  30,
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Obx(() {
                return Column(
                  children: [
                    const Gap(15),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextField(
                            style: Styles.tsBody_14(context),
                            onTapOutside: (event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            onChanged: (value) {
                              currentKeyword = value;
                              list.assignAll(filteredList);
                            },
                            inputFormatters: [UpperCaseTextFormatter()],
                            decoration: InputDecoration(
                                filled: true,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 1),
                                hintText: S.of(context).s_search,
                                hintStyle: Styles.tsSub_14(context),
                                prefixIconColor: Styles.cSub(context),
                                prefixIconConstraints:
                                    const BoxConstraints.tightFor(
                                        width: 38, height: 40),
                                prefixIcon: const Icon(CupertinoIcons.search,
                                    size: 20)),
                          ),
                        )),
                        const Gap(10),
                        CloseButton(
                            color: Styles.cSub(context),
                            style: const ButtonStyle(
                                visualDensity: VisualDensity.compact)),
                      ],
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(10),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                              color: Theme.of(context).dividerTheme.color ??
                                  Colors.transparent,
                            )),
                          ),
                          child: Row(
                            children: [
                              _productTypesView(context),
                              const Gap(10),
                              _exchangeSelectorView(context),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(48, 15, 15, 5),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(S.of(context).symbol,
                                      style: Styles.tsSub_12(context))),
                              Obx(() {
                                return TripleStateSortButton(
                                  isAsc: priceAsc.value,
                                  title: S.of(context).s_price,
                                  onChanged: (isAsc) {
                                    priceAsc.value = isAsc;
                                    priceChgAsc.value = null;
                                    list.assignAll(filteredList);
                                  },
                                );
                              }),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: Text(
                                  '/',
                                  style: Styles.tsSub_12(context),
                                ),
                              ),
                              Obx(() {
                                return TripleStateSortButton(
                                  isAsc: priceChgAsc.value,
                                  title: S.of(context).priceChange24h,
                                  onChanged: (isAsc) {
                                    priceChgAsc.value = isAsc;
                                    priceAsc.value = null;
                                    list.assignAll(filteredList);
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Obx(() {
                            return ListView.builder(
                              itemCount: list.length,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              itemBuilder: (context, index) {
                                final item = list[index];

                                return _Item(
                                  item: item,
                                  onTapMark: () => list.refresh(),
                                );
                              },
                            );
                          }),
                        )
                      ],
                    ))
                  ],
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Expanded _productTypesView(BuildContext context) {
    return Expanded(
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        controller: tabCtrl2,
        onTap: (value) {
          if (value == 0) {
            currentProductType = null;
            isFavorite = true;
          } else if (value == 1) {
            currentProductType = null;
            isFavorite = false;
          } else {
            currentProductType = productTypes[value - 2];
            isFavorite = false;
          }
          list.assignAll(filteredList);
        },
        labelStyle: Styles.tsBody_14m(context),
        unselectedLabelStyle: Styles.tsSub_14m(context),
        labelPadding: const EdgeInsets.only(right: 20),
        indicator: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Styles.cMain, width: 2))),
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        tabs: [
          S.of(context).s_favorite,
          S.of(context).s_all,
          S.of(context).s_swap,
          S.of(context).derivatives,
          S.of(context).spot
        ].map((e) => Tab(text: e)).toList(),
      ),
    );
  }

  MenuAnchor _exchangeSelectorView(BuildContext context) {
    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return ObxValue((isOpen) {
          return GestureDetector(
            onTap: () {
              if (controller.isOpen) {
                controller.close();
                isOpen.value = false;
              } else {
                controller.open();
                isOpen.value = true;
              }
            },
            child: Row(
              children: [
                Text(currentExchange.value ?? S.of(context).s_all),
                Icon(
                    isOpen.value
                        ? CupertinoIcons.chevron_up
                        : CupertinoIcons.chevron_down,
                    size: 15),
              ],
            ),
          );
        }, RxBool(false));
      },
      // clipBehavior: Clip.none,
      style: MenuStyle(
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          elevation: const MaterialStatePropertyAll(10),
          padding: const MaterialStatePropertyAll(EdgeInsets.zero),
          shadowColor:
              MaterialStatePropertyAll(Styles.cBody(context).withOpacity(0.1))),
      menuChildren: List.generate(
        exchanges.length,
        (int index) => SizedBox(
          height: 40,
          child: MenuItemButton(
            trailingIcon: exchanges.toList()[index] == currentExchange.value
                ? const Icon(CupertinoIcons.checkmark_alt,
                    color: Styles.cMain, size: 15)
                : null,
            style: MenuItemButton.styleFrom(
              minimumSize: const Size(130, 40),
              // padding: const EdgeInsets.symmetric(
              //     horizontal: 25),
              backgroundColor:
                  exchanges.toList()[index] == currentExchange.value
                      ? Theme.of(context).cardColor
                      : Theme.of(context).scaffoldBackgroundColor,
            ),
            onPressed: () {
              if (index == 0) {
                currentExchange.value = null;
                list.assignAll(filteredList);
                return;
              }
              currentExchange.value = exchanges.toList()[index];
              list.assignAll(filteredList);
            },
            child: Text(exchanges.toList()[index]),
          ),
        ),
      ),
    );
  }
}

final _productTypeMap = {
  'SWAP': S.current.s_swap,
  'FUTURES': S.current.s_futures,
  'SPOT': S.current.spot,
};

class _Item extends StatelessWidget {
  const _Item({
    required this.item,
    required this.onTapMark,
  });

  final OrderFlowSymbolEntity item;
  final VoidCallback onTapMark;

  @override
  Widget build(BuildContext context) {
    final productTypeColorMap = {
      'SWAP': Styles.cMain,
      'FUTURES': Styles.cSub(context),
      'SPOT': Styles.cYellow,
    };
    return InkWell(
      onTap: () => AppUtil.toKLine(item.exchangeName ?? '', item.symbol ?? '',
          item.baseCoin ?? '', item.productType),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            InkWell(
                onTap: () async {
                  if (!StoreLogic.isLogin) {
                    AppNav.toLogin();
                    return;
                  }
                  if (item.follow == true) {
                    await Apis().postDelFollow(
                        baseCoin:
                            '${item.exchangeName}@${item.baseCoin}@${item.symbol}@${item.productType}',
                        type: 3);
                    item.follow = false;
                    final tmp = StoreLogic.to.orderFlowSymbolsJson;
                    tmp
                        .where((element) => element.symbol == item.symbol)
                        .firstOrNull
                        ?.follow = false;
                    StoreLogic.to.saveOrderFlowSymbolsJson(tmp);
                  } else {
                    //Bitget@BTC@BTCUSDT_UMCBL@SWAP
                    await Apis().postAddFollow(
                        baseCoin:
                            '${item.exchangeName}@${item.baseCoin}@${item.symbol}@${item.productType}',
                        type: 3);
                    item.follow = true;
                    final tmp = StoreLogic.to.orderFlowSymbolsJson;
                    tmp
                        .where((element) => element.symbol == item.symbol)
                        .firstOrNull
                        ?.follow = true;
                    StoreLogic.to.saveOrderFlowSymbolsJson(tmp);
                  }
                  onTapMark();
                },
                child: Image.asset(
                    item.follow == true
                        ? Assets.commonIconStarFill
                        : Assets.commonIconStar,
                    height: 18,
                    width: 18)),
            const Gap(14),
            ImageUtil.coinImage(item.baseCoin ?? '', size: 24),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                          child: Text(item.symbol ?? '',
                              style: Styles.tsBody_14m(context))),
                      const Gap(5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 1),
                        decoration: BoxDecoration(
                            color: productTypeColorMap[item.productType]
                                ?.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(2)),
                        child: Text(_productTypeMap[item.productType] ?? '',
                            style: TextStyle(
                                color: productTypeColorMap[item.productType],
                                fontSize: 10)),
                      ),
                      if (item.hot == true) ...[
                        const Gap(10),
                        Image.asset(Assets.orderflowIcHot,
                            width: 16, height: 16)
                      ]
                    ],
                  ),
                  const Gap(4),
                  Text(item.exchangeName ?? '',
                      style: Styles.tsSub_12(context)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${item.price ?? 0}', style: Styles.tsBody_16m(context)),
                RateWithSign(rate: item.priceChangeH24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
