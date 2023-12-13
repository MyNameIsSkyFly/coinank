import 'package:json_annotation/json_annotation.dart';

part 'app_setting_entity.g.dart';

@JsonSerializable()
class AppSettingEntity {
  final String? name;
  final String? url;
  final bool? isShow;
  final String? openType;

  const AppSettingEntity({
    this.name,
    this.url,
    this.isShow,
    this.openType,
  });

  factory AppSettingEntity.fromJson(Map<String, dynamic> json) =>
      _$AppSettingEntityFromJson(json);
}
