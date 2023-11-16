import 'package:flutter/material.dart';

class FundingRateState {
  bool isHide = true; //是否隐藏
  bool isCmap = false; //是币本位
  String timeType = 'current';
  List<String> topList = [
    'Binance',
    'Okex',
    'Bybit',
    'Bitget',
    'Gate',
    'Bitmex',
    'Huobi'
  ];
  final ScrollController titleController = ScrollController();
  final ScrollController contentController = ScrollController();

  FundingRateState() {
    ///Initialize variables
  }
}
