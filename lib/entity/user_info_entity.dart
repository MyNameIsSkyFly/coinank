import 'package:json_annotation/json_annotation.dart';

part 'user_info_entity.g.dart';

@JsonSerializable(createToJson: true)
class UserInfoEntity {
  UserInfoEntity();

  String? userId;
  String? userName;
  String? userType;
  String? token;
  int? memberType;
  String? memberPeriod;
  int? memberExpiredTime;
  String? status;
  int? ts;
  bool? trialed;

  factory UserInfoEntity.fromJson(Map<String, dynamic> json) {
    return _$UserInfoEntityFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserInfoEntityToJson(this);
}
