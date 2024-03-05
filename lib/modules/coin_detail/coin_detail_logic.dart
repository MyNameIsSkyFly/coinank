import 'dart:async';

import 'package:ank_app/entity/contract_market_entity.dart';
import 'package:ank_app/http/apis.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../entity/futures_big_data_entity.dart';

class CoinDetailLogic extends GetxController {
  late MarkerTickerEntity coin;
  final coin24hInfo = Rxn<ContractMarketEntity>();
  late TabController tabController;
  Timer? timer;
  bool supportContract = false;
  bool supportSpot = false;

  @override
  void onInit() {
    coin = Get.arguments['coin'];
    supportSpot = coin.supportSpot ?? false;
    supportContract = coin.supportContract ?? false;
    super.onInit();
  }

  @override
  void onReady() {
    getCoinInfo24h();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getCoinInfo24h();
    });
  }

  Future<void> getCoinInfo24h() async {
    final result = await Apis().getCoinInfo24h(coin.baseCoin ?? '');
    coin24hInfo.value = result;
  }

  @override
  void onClose() {
    timer?.cancel();
  }
}
