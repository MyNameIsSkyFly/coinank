import 'package:json_annotation/json_annotation.dart';

part 'liq_all_exchange_entity.g.dart';

@JsonSerializable()
class LiqAllExchangeEntity {
  final String? exchangeName;
  final String? baseCoin;
  final double? totalTurnover;
  final double? longTurnover;
  final double? shortTurnover;
  final double? percentage;
  final double? longRatio;
  final double? shortRatio;
  final String? interval;

  const LiqAllExchangeEntity({
    this.exchangeName,
    this.baseCoin,
    this.totalTurnover,
    this.longTurnover,
    this.shortTurnover,
    this.percentage,
    this.longRatio,
    this.shortRatio,
    this.interval,
  });

  factory LiqAllExchangeEntity.fromJson(Map<String, dynamic> json) =>
      _$LiqAllExchangeEntityFromJson(json);
}
