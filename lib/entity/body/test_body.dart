import 'package:json_annotation/json_annotation.dart';

part 'test_body.g.dart';

@JsonSerializable(createToJson: true)
class TestBody {
  final String? testUpload;

  const TestBody({
    this.testUpload,
  });

  factory TestBody.fromJson(Map<String, dynamic> json) =>
      _$TestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$TestBodyToJson(this);
}
