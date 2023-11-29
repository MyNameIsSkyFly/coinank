import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'liq_hot_map_logic.dart';

class LiqHotMapPage extends StatelessWidget {
  LiqHotMapPage({Key? key}) : super(key: key);

  final logic = Get.put(LiqHotMapLogic());
  final state = Get.find<LiqHotMapLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
