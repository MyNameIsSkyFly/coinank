import 'package:json_annotation/json_annotation.dart';

part 'contract_market_entity.g.dart';

@JsonSerializable()
class ContractMarketEntity {
  final String? baseCoin;
  final String? symbol;
  final String? exchangeName;
  final String? contractType;
  final double? lastPrice;
  final double? open24h;
  final double? high24h;
  final double? low24h;
  final double? priceChange24h;
  final double? volCcy24h;
  final double? vol24h;
  final double? turnover24h;
  final int? tradeTimes;
  final double? oiUSD;
  final double? oiCcy;
  final double? oiVol;
  final double? fundingRate;
  final double? liqLong24h;
  final double? liqShort24h;
  final double? liq24h;
  final double? oiChg24h;
  final double? buyTurnover;
  final double? sellTurnover;
  final String? lsPersonRatio;
  final int? expireAt;
  final int? ts;

  const ContractMarketEntity({
    this.baseCoin,
    this.symbol,
    this.exchangeName,
    this.contractType,
    this.lastPrice,
    this.open24h,
    this.high24h,
    this.low24h,
    this.priceChange24h,
    this.volCcy24h,
    this.vol24h,
    this.turnover24h,
    this.tradeTimes,
    this.oiUSD,
    this.oiCcy,
    this.oiVol,
    this.fundingRate,
    this.liqLong24h,
    this.liqShort24h,
    this.liq24h,
    this.oiChg24h,
    this.buyTurnover,
    this.sellTurnover,
    this.lsPersonRatio,
    this.expireAt,
    this.ts,
  });

  factory ContractMarketEntity.fromJson(Map<String, dynamic> json) =>
      _$ContractMarketEntityFromJson(json);
}
