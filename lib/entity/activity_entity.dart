import 'package:json_annotation/json_annotation.dart';

part 'activity_entity.g.dart';

@JsonSerializable()
class ActivityEntity {
  final String? title;
  final String? content;
  final bool? isShow;

  const ActivityEntity({
    this.title,
    this.content,
    this.isShow,
  });

  factory ActivityEntity.fromJson(Map<String, dynamic> json) =>
      _$ActivityEntityFromJson(json);
}
