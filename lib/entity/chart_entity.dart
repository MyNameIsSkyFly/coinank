import 'package:json_annotation/json_annotation.dart';

part 'chart_entity.g.dart';

@JsonSerializable()
class ChartEntity {
  final String? path;
  final String? title;
  final String? key;
  final String? color;
  final String? groupName;

  const ChartEntity({
    this.path,
    this.title,
    this.key,
    this.color,
    this.groupName,
  });

  factory ChartEntity.fromJson(Map<String, dynamic> json) =>
      _$ChartEntityFromJson(json);
}
