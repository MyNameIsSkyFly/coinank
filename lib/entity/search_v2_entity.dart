// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_v2_entity.g.dart';

@JsonSerializable()
class SearchV2Entity {
  final List<SearchV2ItemEntity>? erc20;
  final List<SearchV2ItemEntity>? asc20;
  final List<SearchV2ItemEntity>? brc20;
  final List<SearchV2ItemEntity>? arc20;
  final List<SearchV2ItemEntity>? baseCoin;

  const SearchV2Entity({
    this.erc20,
    this.asc20,
    this.brc20,
    this.arc20,
    this.baseCoin,
  });

  factory SearchV2Entity.fromJson(Map<String, dynamic> json) =>
      _$SearchV2EntityFromJson(json);
}

@JsonSerializable(createToJson: true)
class SearchV2ItemEntity extends Equatable {
  final String? baseCoin;
  @JsonKey(includeToJson: false)
  final double? oi;
  @JsonKey(includeToJson: false)
  final double? oiChg;
  @JsonKey(includeToJson: false)
  final double? price;
  @JsonKey(includeToJson: false)
  final double? priceChg;
  final SearchEntityType? tag;

  const SearchV2ItemEntity({
    this.baseCoin,
    this.oi,
    this.oiChg,
    this.price,
    this.priceChg,
    this.tag,
  });

  factory SearchV2ItemEntity.fromJson(Map<String, dynamic> json) =>
      _$SearchV2ItemEntityFromJson(json);

  Map<String, dynamic> toJson() => _$SearchV2ItemEntityToJson(this);

  @override
  List<Object?> get props => [baseCoin, tag];
}

enum SearchEntityType {
  ERC20,
  ASC20,
  BRC20,
  ARC20,
  BASECOIN,
}
