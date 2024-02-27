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
  final isSpot = true.obs;

  @override
  void onInit() {
    coin = Get.arguments['coin'];
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
    final result = await Apis().getCoinInfo24h(coin.baseCoin ?? '').then(
      (value) {
        isSpot.value = false;
        return value;
      },
    ).catchError((e) async {
      isSpot.value = true;
      return await Apis()
          .getCoinInfo24h(coin.baseCoin ?? '', productType: 'SPOT');
    });
    coin24hInfo.value = result;
  }

  @override
  void onClose() {
    timer?.cancel();
  }
}
