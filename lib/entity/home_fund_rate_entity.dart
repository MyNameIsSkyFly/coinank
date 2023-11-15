import 'package:json_annotation/json_annotation.dart';

part 'home_fund_rate_entity.g.dart';

@JsonSerializable()
class HomeFundRateEntity {
  HomeFundRateEntity({
    this.baseCoin,
    this.exchangeName,
    this.symbol,
    this.fundingRate,
  });

  final String? baseCoin;
  final String? exchangeName;
  final String? symbol;
  final double? fundingRate;

  factory HomeFundRateEntity.fromJson(Map<String, dynamic> json) {
    return _$HomeFundRateEntityFromJson(json);
  }
}
