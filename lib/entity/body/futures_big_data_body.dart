import 'package:json_annotation/json_annotation.dart';

part 'futures_big_data_body.g.dart';

@JsonSerializable(createToJson: true)
class FuturesBigDataBody {
  final String? openInterest;

  const FuturesBigDataBody({
    this.openInterest,
  });

  factory FuturesBigDataBody.fromJson(Map<String, dynamic> json) =>
      _$FuturesBigDataBodyFromJson(json);

  Map<String, dynamic> toJson() => _$FuturesBigDataBodyToJson(this);
}
