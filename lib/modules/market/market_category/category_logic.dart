part of 'category_view.dart';

mixin ContractCategoryLogic {
  late final gridSource = _DataGridSource();
  final columns = RxList<GridColumn>();
  StreamSubscription? _themeSubscription;
  bool isSpot = false;

  void onInit() {
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
    gridSource.list.assignAll(data ?? []);
    gridSource.refresh();
    getColumn();
  }

  void getColumn() {
    columns.assignAll([
      GridColumn(
        maximumWidth: 133,
        allowSorting: false,
        columnName: S.current.category,
        label: Text(S.current.category),
      ),
      GridColumn(
        columnName: '${S.current.s_24h_turnover}(\$)',
        label: Text('${S.current.s_24h_turnover}(\$)'),
      ),
      GridColumn(
        columnName: '${S.current.s_24h_turnover}(%)',
        label: Text('${S.current.s_24h_turnover}(%)'),
      ),
      if (!isSpot) ...[
        GridColumn(
          columnName: '${S.current.s_oi}(\$)',
          label: Text('${S.current.s_oi}(\$)'),
        ),
        GridColumn(
          columnName: '${S.current.s_oi}(1H%)',
          label: Text('${S.current.s_oi}(1H%)'),
        ),
        GridColumn(
          columnName: '${S.current.s_oi}(24H%)',
          label: Text('${S.current.s_oi}(24H%)'),
        )
      ],
      GridColumn(
        columnName: '${S.current.marketCap}(\$)',
        label: Text('${S.current.marketCap}(\$)'),
      ),
      GridColumn(
        columnName: S.current.topMarketCoin,
        label: Text(S.current.topMarketCoin),
      ),
      GridColumn(
        columnName: S.current.topGainerCoin,
        label: Text(S.current.topGainerCoin),
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
