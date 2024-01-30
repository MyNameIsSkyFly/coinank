import 'package:json_annotation/json_annotation.dart';

part 'btc_reduce_entity.g.dart';

@JsonSerializable()
class BtcReduceEntity {
  BtcReduceEntity(
      {this.halvingBlockHeight,
      this.halvingTime,
      this.height,
      this.reduceHeight});

  final int? halvingBlockHeight;
  final int? halvingTime;
  final int? height;
  final int? reduceHeight;

  factory BtcReduceEntity.fromJson(Map<String, dynamic> json) {
    return _$BtcReduceEntityFromJson(json);
  }
}
