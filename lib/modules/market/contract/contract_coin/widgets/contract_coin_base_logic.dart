import 'package:ank_app/entity/futures_big_data_entity.dart';

import 'contract_coin_datagrid_source.dart';

abstract class ContractCoinBaseLogic {
  late ContractCoinGridSource dataSource;

  bool get pageVisible;

  Future<void> tapCollect(String? baseCoin);

  void tapItem(MarkerTickerEntity item);

  Future<void> onRefresh({bool showLoading = false});
}
