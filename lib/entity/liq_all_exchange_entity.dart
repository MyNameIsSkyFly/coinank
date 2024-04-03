import 'package:json_annotation/json_annotation.dart';

part 'liq_all_exchange_entity.g.dart';

@JsonSerializable()
class LiqAllExchangeFullEntity {
  LiqAllExchangeFullEntity();

  List<LiqAllExchangeEntity>? data;
  LiqAllExchangeExtEntity? ext;

  factory LiqAllExchangeFullEntity.fromJson(Map<String, dynamic> json) {
    return _$LiqAllExchangeFullEntityFromJson(json);
  }
}

@JsonSerializable()
class LiqAllExchangeExtEntity {
  LiqAllExchangeExtEntity();

  int? total;
  List<LiqAllExchangeTopEntity>? tops;

  factory LiqAllExchangeExtEntity.fromJson(Map<String, dynamic> json) {
    return _$LiqAllExchangeExtEntityFromJson(json);
  }
}

@JsonSerializable()
class LiqAllExchangeTopEntity {
  LiqAllExchangeTopEntity();

  String? symbol;
  String? posSide;
  String? exchangeName;
  double? tradeTurnover;
  String? baseCoin;
  int? ts;

  factory LiqAllExchangeTopEntity.fromJson(Map<String, dynamic> json) {
    return _$LiqAllExchangeTopEntityFromJson(json);
  }
}

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

@JsonSerializable()
class LiqOrderEntity {
  LiqOrderEntity();

  String? id;
  String? exchangeName;
  String? baseCoin;
  String? side;
  String? exchangeType;
  String? contractType;
  String? deliveryType;
  String? contractCode;
  String? uly;
  String? posSide;
  double? volume;
  double? amount;
  double? price;
  double? avgPrice;
  double? tradeTurnover;
  int? ts;

  factory LiqOrderEntity.fromJson(Map<String, dynamic> json) {
    return _$LiqOrderEntityFromJson(json);
  }
}
