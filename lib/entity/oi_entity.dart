import 'package:json_annotation/json_annotation.dart';

part 'oi_entity.g.dart';

@JsonSerializable()
class OIEntity {
  OIEntity();

  num? coinCount;
  num? coinValue;
  String? baseCoin;
  String? exchangeName;
  num? rate;
  num? change1H;
  num? change4H;
  num? change24H;

  factory OIEntity.fromJson(Map<String, dynamic> json) {
    return _$OIEntityFromJson(json);
  }
}
