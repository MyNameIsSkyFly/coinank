import 'package:json_annotation/json_annotation.dart';

part 'short_rate_entity.g.dart';

@JsonSerializable(createToJson: true)
class ShortRateEntity {
  final String? baseCoin;
  String? exchangeName;
  final String? interval;
  final double? sellTradeTurnover;
  final double? buyTradeTurnover;
  final double? longRatio;
  final double? shortRatio;
  final List<double>? longRatios;
  final List<double>? shortRatios;
  final List<double>? tss;

  ShortRateEntity(
    this.longRatios,
    this.shortRatios,
    this.tss, {
    this.baseCoin,
    this.exchangeName,
    this.interval,
    this.sellTradeTurnover,
    this.buyTradeTurnover,
    this.longRatio,
    this.shortRatio,
  });

  factory ShortRateEntity.fromJson(Map<String, dynamic> json) =>
      _$ShortRateEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ShortRateEntityToJson(this);
}
