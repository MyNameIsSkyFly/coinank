import 'package:json_annotation/json_annotation.dart';

part 'order_flow_symbol.g.dart';

@JsonSerializable(createToJson: true)
class OrderFlowSymbolEntity {
  final String? symbol;
  final String? baseCoin;
  final String? exchangeName;
  final String? productType;
  final String? symbolType;
  final String? pricePrecision;
  final String? deliveryType;
  final int? expireAt;
  final int? updateAt;
  final bool? hot;
  final bool? follow;
  final int? followIndex;
  final double? price;
  final double? priceChangeH24;

  const OrderFlowSymbolEntity({
    this.symbol,
    this.baseCoin,
    this.exchangeName,
    this.productType,
    this.symbolType,
    this.pricePrecision,
    this.deliveryType,
    this.expireAt,
    this.updateAt,
    this.hot,
    this.follow,
    this.followIndex,
    this.price,
    this.priceChangeH24,
  });

  factory OrderFlowSymbolEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderFlowSymbolEntityFromJson(json);

  Map<String, dynamic> toJson() => _$OrderFlowSymbolEntityToJson(this);
}
