import 'package:json_annotation/json_annotation.dart';

part 'oi_entity.g.dart';

@JsonSerializable()
class OIEntity {
  OIEntity();

  String? coinCount;
  String? coinValue;
  String? baseCoin;
  String? exchangeName;
  String? rate;
  String? change1H;
  String? change4H;
  String? change24H;

  factory OIEntity.fromJson(Map<String, dynamic> json) {
    return _$OIEntityFromJson(json);
  }
}
