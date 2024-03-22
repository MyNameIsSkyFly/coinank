import 'package:ank_app/entity/futures_big_data_entity.dart';

import 'spot_coin_datagrid_source.dart';

abstract class SpotCoinBaseLogic {
  late GridDataSource dataSource;

  bool get pageVisible;

  Future<void> tapCollect(String? baseCoin);

  void tapItem(MarkerTickerEntity item);

  Future<void> onRefresh({bool showLoading = false});
}
