import 'package:json_annotation/json_annotation.dart';

part 'coin_detail_contract_info_entity.g.dart';

@JsonSerializable()
class CoinDetailContractInfoEntity {
  final double? liq24h;
  final double? longLiq24h;
  final double? shortLiq24h;
  final double? longRatio4h;
  final double? shortRatio4h;
  final double? longShortRatio4h;
  final double? longRatio24h;
  final double? shortRatio24h;
  final double? longShortRatio24h;
  final double? swapTurnover24h;
  final double? swapOiUSD24h;
  final int? swapTradeTimes24h;
  final double? futureTurnover24h;
  final double? futureOiUSD24h;
  final int? futureTradeTimes24h;
  final double? turnover24h;
  final double? oiUSD;
  final String? binanceUSDTAccountLS;
  final String? binanceUSDTPersonLS;
  final String? okexAccountLS;
  final String? okexPersonLS;

  const CoinDetailContractInfoEntity({
    this.liq24h,
    this.longLiq24h,
    this.shortLiq24h,
    this.longRatio4h,
    this.shortRatio4h,
    this.longShortRatio4h,
    this.longRatio24h,
    this.shortRatio24h,
    this.longShortRatio24h,
    this.swapTurnover24h,
    this.swapOiUSD24h,
    this.swapTradeTimes24h,
    this.futureTurnover24h,
    this.futureOiUSD24h,
    this.futureTradeTimes24h,
    this.turnover24h,
    this.oiUSD,
    this.binanceUSDTAccountLS,
    this.binanceUSDTPersonLS,
    this.okexAccountLS,
    this.okexPersonLS,
  });

  factory CoinDetailContractInfoEntity.fromJson(Map<String, dynamic> json) =>
      _$CoinDetailContractInfoEntityFromJson(json);
}
