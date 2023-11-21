import 'package:json_annotation/json_annotation.dart';

part 'chart_left_entity.g.dart';

@JsonSerializable()
class ChartLeftEntity {
  final String? path;
  final String? title;
  final String? key;
  final List<Subs>? subs;

  const ChartLeftEntity({
    this.path,
    this.title,
    this.key,
    this.subs,
  });

  factory ChartLeftEntity.fromJson(Map<String, dynamic> json) =>
      _$ChartLeftEntityFromJson(json);
}

@JsonSerializable()
class Subs {
  final String? path;
  final String? title;
  final String? key;
  final List<Subs>? subs;

  const Subs({
    this.path,
    this.title,
    this.key,
    this.subs
  });

  factory Subs.fromJson(Map<String, dynamic> json) =>
      _$SubsFromJson(json);
}
