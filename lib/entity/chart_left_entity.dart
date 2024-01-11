import 'package:json_annotation/json_annotation.dart';

part 'chart_left_entity.g.dart';

@JsonSerializable(createToJson: true)
class ChartSubItem {
  final String? path;
  final String? title;
  final String? key;
  final List<ChartSubItem>? subs;

  const ChartSubItem({this.path, this.title, this.key,
    this.subs
  });

  factory ChartSubItem.fromJson(Map<String, dynamic> json) =>
      _$ChartSubItemFromJson(json);

  Map<String, dynamic> toJson() => _$ChartSubItemToJson(this);
}
