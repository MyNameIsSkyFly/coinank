import 'package:ank_app/entity/body/futures_big_data_body.dart';
import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/entity/head_statistics_entity.dart';
import 'package:ank_app/entity/home_fund_rate_entity.dart';
import 'package:ank_app/http/apis.dart';
import 'package:get/get.dart';

class HomeLogic extends GetxController {
  final priceChangeData = Rxn<TickersDataEntity>();
  final oiChangeData = Rxn<TickersDataEntity>();
  final homeInfoData = Rxn<HomeInfoEntity>();
  final fundRateList = RxList<HomeFundRateEntity>();

  List<MarkerTickerEntity>? get priceList => priceChangeData.value?.list;

  List<MarkerTickerEntity>? get oiList => oiChangeData.value?.list;

  String get buySellLongShortRatio =>
      ((double.tryParse(homeInfoData.value?.longRatio ?? '') ?? 0) /
              (double.tryParse(homeInfoData.value?.shortRatio ?? '1') ?? 1))
          .toStringAsFixed(2);

  @override
  void onReady() {
    onRefresh();
  }

  Future<void> onRefresh() async {
    await Future.wait([
      loadPriceChgData(),
      loadOIChgData(),
      loadHomeData(),
      loadFundRateData()
    ]);
  }

  Future<void> loadPriceChgData() async {
    final data = await Apis().postFuturesBigData(
      const FuturesBigDataBody(openInterest: '5000000~'),
      page: 1,
      size: 3,
      sortBy: 'priceChangeH24',
      sortType: 'descend',
    );
    priceChangeData.value = data;
  }

  Future<void> loadOIChgData() async {
    final data = await Apis()
        .getFuturesBigData(page: 1, size: 3, sortBy: '', sortType: '');
    oiChangeData.value = data;
  }

  Future<void> loadHomeData() async {
    final data = await Apis().getHeadStatistics();
    homeInfoData.value = data;
  }

  Future<void> loadFundRateData() async {
    final data = await Apis().getHomeFundRateData();
    fundRateList.assignAll(data ?? []);
  }
}
