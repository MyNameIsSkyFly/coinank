import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'protfolio_logic.dart';

class ProtfolioPage extends StatelessWidget {
  ProtfolioPage({Key? key}) : super(key: key);

  final logic = Get.put(ProtfolioLogic());
  final state = Get.find<ProtfolioLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
