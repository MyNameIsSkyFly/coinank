import 'package:json_annotation/json_annotation.dart';

part 'hold_address_entity.g.dart';

@JsonSerializable(createToJson: true)
class HoldAddressEntity {
  HoldAddressEntity({
    this.flowAddressList,
    this.holdingAddressCharts,
    this.topAddressList,
  });

  final List<HoldAddressItemEntity>? flowAddressList;
  final dynamic holdingAddressCharts;
  final List<HoldAddressItemEntity>? topAddressList;

  factory HoldAddressEntity.fromJson(Map<String, dynamic> json) {
    return _$HoldAddressEntityFromJson(json);
  }

  Map<String, dynamic> toJson() => _$HoldAddressEntityToJson(this);
}

@JsonSerializable(createToJson: true)
class HoldAddressItemEntity {
  final int? id;
  final String? address;
  final String? quantity;
  final String? percentage;
  final String? platform;
  final String? platformName;
  final String? logo;
  final String? changePercent;
  final String? blockUrl;
  final String? changeAbs;
  final String? updateTime;
  final String? hidden;
  final String? destroy;
  final String? isContract;
  final String? addressFlag;
  final String? type;
  final String? symbol;
  final String? baseCoin;
  final int? sort;

  const HoldAddressItemEntity({
    this.id,
    this.address,
    this.quantity,
    this.percentage,
    this.platform,
    this.platformName,
    this.logo,
    this.changePercent,
    this.blockUrl,
    this.changeAbs,
    this.updateTime,
    this.hidden,
    this.destroy,
    this.isContract,
    this.addressFlag,
    this.type,
    this.symbol,
    this.baseCoin,
    this.sort,
  });

  factory HoldAddressItemEntity.fromJson(Map<String, dynamic> json) =>
      _$HoldAddressItemEntityFromJson(json);

  Map<String, dynamic> toJson() => _$HoldAddressItemEntityToJson(this);
}
