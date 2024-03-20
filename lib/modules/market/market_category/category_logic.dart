part of 'category_view.dart';

mixin ContractCategoryLogic {
  late final gridSource = _DataGridSource();
  final columns = RxList<GridColumn>();
  StreamSubscription? _themeSubscription;
  bool isSpot = false;

  void onInit() {
    //todo 轮询
    gridSource.isSpot = isSpot;
    getColumn();
    initData();
    listenTheme();
  }

  void listenTheme() {
    _themeSubscription =
        AppConst.eventBus.on<ThemeChangeEvent>().listen((event) {
      getColumn();
      gridSource.refresh();
    });
  }

  Future<void> initData() async {
    final data = await Apis().getContractCategories(
      productType: isSpot ? 'SPOT' : 'SWAP',
    );
    MarketMaps.allCategories.assignAll(await Apis().getAllCategories() ?? []);
    gridSource.list.assignAll(data ?? []);
    gridSource.refresh();
    getColumn();
  }

  void getColumn() {
    Widget text(String text) => Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              text,
              style: Styles.tsSub_12m(context),
            ),
          );
        });
    columns.assignAll([
      GridColumn(
        maximumWidth: 133,
        allowSorting: false,
        columnName: S.current.category,
        label: Container(
            alignment: Alignment.centerLeft, child: text(S.current.category)),
      ),
      GridColumn(
        columnName: '${S.current.s_24h_turnover}(\$)',
        label: text('${S.current.s_24h_turnover}(\$)'),
      ),
      GridColumn(
        columnName: '${S.current.s_24h_turnover}(%)',
        label: text('${S.current.s_24h_turnover}(%)'),
      ),
      if (!isSpot) ...[
        GridColumn(
          columnName: '${S.current.s_oi}(\$)',
          label: text('${S.current.s_oi}(\$)'),
        ),
        GridColumn(
          columnName: '${S.current.s_oi}(1H%)',
          label: text('${S.current.s_oi}(1H%)'),
        ),
        GridColumn(
          columnName: '${S.current.s_oi}(24H%)',
          label: text('${S.current.s_oi}(24H%)'),
        )
      ],
      GridColumn(
        columnName: '${S.current.marketCap}(\$)',
        label: text('${S.current.marketCap}(\$)'),
      ),
      GridColumn(
        columnName: S.current.topMarketCoin,
        label: text(S.current.topMarketCoin),
      ),
      GridColumn(
        columnName: S.current.topGainerCoin,
        label: text(S.current.topGainerCoin),
      ),
    ]);
  }

  void onClose() {
    _themeSubscription?.cancel();
  }

  final categoryTags = [
    'layer-1',
    'ethereum-ecosystem',
    'solana-ecosystem',
    'defi',
    'smart-contracts',
    'binance-smart-chain',
    'memes',
    'polygon-ecosystem',
    'avalanche-ecosystem',
    'arbitrum-ecosytem',
    'ai-big-data',
    'optimism-ecosystem',
    'metaverse',
    'layer-2',
    'gaming',
    'polkadot-ecosystem',
    'brc-20',
    'storage',
    'launchpool',
    'fans token'
  ];
}
