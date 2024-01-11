import 'dart:ui';

import 'package:ank_app/entity/chart_entity.dart';
import 'package:ank_app/entity/chart_left_entity.dart';
import 'package:ank_app/generated/assets.dart';
import 'package:get/get.dart';

class ChartState {
  RxList<List<ChartEntity>> dataList = RxList.empty();
  RxMap<String, List<ChartEntity>> dataMap = RxMap();
  RxBool isLoading = true.obs;
  RxList<ChartSubItem> topDataList = RxList.empty();
  List<String> icoList = [
    Assets.chartLeftIconDer,
    Assets.chartLeftIconExchange,
    Assets.chartLeftIconChartsData,
    Assets.chartLeftIconOnChainData,
  ];
  final topColorList = const [
    Color(0x1a5CC389),
    Color(0x1a4363F2),
    Color(0x1a693BED),
    Color(0x1aF6A34D),
  ];

  final recentList = RxList<ChartEntity>();
  ChartState() {
    ///Initialize variables
  }
}
