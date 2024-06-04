import 'package:json_annotation/json_annotation.dart';

part 'news_entity.g.dart';

@JsonSerializable()
class NewsEntity {
  final String? id;
  final dynamic type;
  final String? sourceId;
  final String? sourceWeb;
  final String? sourceWebPic;
  final String? title;
  final String? content;
  final String? articlePic;
  final String? link;
  final String? lang;
  final int? readNum;
  final int? ts;
  final bool? recommend;
  final bool? hot;
  final bool? top;

  const NewsEntity({
    this.id,
    this.type,
    this.sourceId,
    this.sourceWeb,
    this.sourceWebPic,
    this.title,
    this.content,
    this.articlePic,
    this.link,
    this.lang,
    this.readNum,
    this.ts,
    this.recommend,
    this.hot,
    this.top,
  });

  factory NewsEntity.fromJson(Map<String, dynamic> json) =>
      _$NewsEntityFromJson(json);
}

enum NewsType { recommend, fast, normal }
