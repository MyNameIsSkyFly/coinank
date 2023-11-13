import 'package:json_annotation/json_annotation.dart';

part 'test_entity.g.dart';

@JsonSerializable(createToJson: true)
class TestEntity {
  final String? test;

  const TestEntity({
    this.test,
  });

  factory TestEntity.fromJson(Map<String, dynamic> json) =>
      _$TestEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TestEntityToJson(this);
}
