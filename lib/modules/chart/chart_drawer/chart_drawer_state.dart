import 'package:ank_app/entity/chart_left_entity.dart';
import 'package:ank_app/generated/assets.dart';
import 'package:get/get.dart';

class ChartDrawerState {
  RxList<ChartLeftEntity> dataList = RxList.empty();
  List<String> icoList = [
    Assets.chartLeftIconDer,
    Assets.chartLeftIconExchange,
    Assets.chartLeftIconChartsData,
    Assets.chartLeftIconOnChainData,
  ];

  ChartDrawerState();
}
