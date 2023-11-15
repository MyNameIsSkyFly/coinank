import 'package:json_annotation/json_annotation.dart';

part 'head_statistics_entity.g.dart';

@JsonSerializable()
class HomeInfoEntity {
  HomeInfoEntity({
    this.liquidationShort,
    this.liquidationLong,
    this.liquidation,
    this.ticker,
    this.marketCpaValue,
    this.openInterest,
    this.okexPersonChange,
    this.liquidationChange,
    this.longRatio,
    this.cnnValue,
    this.binancePersonValue,
    this.cnnChange,
    this.oiChange,
    this.binancePersonChange,
    this.shortRatio,
    this.tickerChange,
    this.okexPersonValue,
    this.marketCpaChange,
    this.btcProfit,
  });

  final String? liquidationShort;
  final String? liquidationLong;
  final String? liquidation;
  final String? ticker;
  final String? marketCpaValue;
  final String? openInterest;
  final String? okexPersonChange;
  final String? liquidationChange;
  final String? longRatio;
  final String? cnnValue;
  final String? binancePersonValue;
  final String? cnnChange;
  @JsonKey(name: 'OIChange')
  final String? oiChange;
  final String? binancePersonChange;
  final String? shortRatio;
  final String? tickerChange;
  final String? okexPersonValue;
  final String? marketCpaChange;
  final String? btcProfit;
  factory HomeInfoEntity.fromJson(Map<String, dynamic> json) {
    return _$HomeInfoEntityFromJson(json);
  }
}
