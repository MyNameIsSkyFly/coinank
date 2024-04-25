import 'package:json_annotation/json_annotation.dart';

part 'kline_entity.g.dart';

@JsonSerializable()
class KlineEntity {
  final bool? success;
  final String? code;
  final dynamic msg;
  final List<List<double?>>? data;
  final dynamic ext;

  const KlineEntity({
    this.success,
    this.code,
    this.msg,
    this.data,
    this.ext,
  });

  factory KlineEntity.fromJson(Map<String, dynamic> json) =>
      _$KlineEntityFromJson(json);
}
