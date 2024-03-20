import 'package:ank_app/res/export.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_info_item_entity.g.dart';

@JsonSerializable()
class CategoryInfoItemEntity {
  final String? id;
  final String? type;
  final String? typeNameZh;
  final String? typeNameZhTw;
  final String? typeNameEn;

  const CategoryInfoItemEntity({
    this.id,
    this.type,
    this.typeNameZh,
    this.typeNameZhTw,
    this.typeNameEn,
  });

  String? get showName => switch (AppUtil.shortLanguageName) {
        'zh' => typeNameZh,
        'zh-tw' => typeNameZhTw,
        _ => typeNameEn,
      };

  factory CategoryInfoItemEntity.fromJson(Map<String, dynamic> json) =>
      _$CategoryInfoItemEntityFromJson(json);
}
