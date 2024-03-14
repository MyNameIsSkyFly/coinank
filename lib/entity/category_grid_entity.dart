import 'package:json_annotation/json_annotation.dart';

part 'category_grid_entity.g.dart';

@JsonSerializable()
class CategoryGridEntity {
  final String? tag;
  final String? productType;
  final double? marketCap;
  final double? turnover;
  final double? turnoverChg;
  final double? openInterest;
  final double? openInterestCh1;
  final double? openInterestCh24;
  final String? bestCoin;
  final double? bestChg;
  final double? topMarket;
  final String? topMarketCoin;
  final String? exchangeName;
  final String? symbol;
  final int? ts;

  const CategoryGridEntity({
    this.tag,
    this.productType,
    this.marketCap,
    this.turnover,
    this.turnoverChg,
    this.openInterest,
    this.openInterestCh1,
    this.openInterestCh24,
    this.bestCoin,
    this.bestChg,
    this.topMarket,
    this.topMarketCoin,
    this.exchangeName,
    this.symbol,
    this.ts,
  });

  factory CategoryGridEntity.fromJson(Map<String, dynamic> json) =>
      _$CategoryGridEntityFromJson(json);
}
