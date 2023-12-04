// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'marker_funding_rate_entity.g.dart';

@JsonSerializable()
class MarkerFundingRateEntity {
  final String? symbol;
  final Map<String, Exchange>? cmap;
  final Map<String, Exchange>? umap;
  final bool? follow;

  const MarkerFundingRateEntity({
    this.symbol,
    this.cmap,
    this.umap,
    this.follow,
  });

  factory MarkerFundingRateEntity.fromJson(Map<String, dynamic> json) =>
      _$MarkerFundingRateEntityFromJson(json);
}

@JsonSerializable()
class Cmap {
  final Exchange? Binance;
  final Exchange? Bitget;
  final Exchange? Bitmex;
  final Exchange? Bybit;
  final Exchange? Deribit;
  final Exchange? Gate;
  final Exchange? Huobi;
  final Exchange? Okex;

  const Cmap({
    this.Binance,
    this.Bitget,
    this.Bitmex,
    this.Bybit,
    this.Deribit,
    this.Gate,
    this.Huobi,
    this.Okex,
  });

  factory Cmap.fromJson(Map<String, dynamic> json) => _$CmapFromJson(json);
}

@JsonSerializable()
class Exchange {
  final String? baseCoin;
  final String? exchangeName;
  final String? exchangeType;
  final String? symbol;
  final double? fundingRate;
  final double? estimatedRate;
  final int? fundingTime;
  final int? nextFundingTime;
  final int? ts;
  final double? fundingRateCap;
  final double? fundingRateFloor;
  final double? frCap;
  final double? frFloor;
  final int? interval;

  const Exchange({
    this.baseCoin,
    this.exchangeName,
    this.exchangeType,
    this.symbol,
    this.fundingRate,
    this.estimatedRate,
    this.fundingTime,
    this.nextFundingTime,
    this.ts,
    this.fundingRateCap,
    this.fundingRateFloor,
    this.frCap,
    this.frFloor,
    this.interval,
  });

  factory Exchange.fromJson(Map<String, dynamic> json) =>
      _$ExchangeFromJson(json);
}

@JsonSerializable()
class Umap {
  final Exchange? Binance;
  final Exchange? Bitget;
  final Exchange? Bybit;
  final Exchange? Gate;
  final Exchange? Huobi;
  final Exchange? Okex;
  final Exchange? dYdX;

  const Umap({
    this.Binance,
    this.Bitget,
    this.Bybit,
    this.Gate,
    this.Huobi,
    this.Okex,
    this.dYdX,
  });

  factory Umap.fromJson(Map<String, dynamic> json) => _$UmapFromJson(json);
}
