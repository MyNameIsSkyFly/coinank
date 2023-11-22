import 'package:ank_app/entity/chart_entity.dart';
import 'package:get/get.dart';

class ChartState {
  RxList<List<ChartEntity>> dataList = RxList.empty();
  RxMap<String, List<ChartEntity>> dataMap = RxMap();

  ChartState() {
    ///Initialize variables
  }
}
