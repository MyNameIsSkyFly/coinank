import 'package:json_annotation/json_annotation.dart';

part 'activity_entity.g.dart';

@JsonSerializable()
class ActivityEntity {
  final String? title;
  final String? content;
  final bool? isShow;
  final String? url;
  final String? openType;

  const ActivityEntity({
    this.title,
    this.content,
    this.isShow,
    this.url,
    this.openType,
  });

  factory ActivityEntity.fromJson(Map<String, dynamic> json) =>
      _$ActivityEntityFromJson(json);
}
