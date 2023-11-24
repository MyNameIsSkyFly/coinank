import 'package:json_annotation/json_annotation.dart';

part 'futures_big_data_entity.g.dart';

@JsonSerializable(createToJson: true)
class MarkerTickerEntity {
  MarkerTickerEntity({
    this.baseCoin,
    this.coinImage,
    this.price,
    this.priceChangeH24,
    this.priceChangeM5,
    this.priceChangeM15,
    this.priceChangeM30,
    this.priceChangeH1,
    this.priceChangeH2,
    this.priceChangeH4,
    this.priceChangeH6,
    this.priceChangeH8,
    this.priceChangeH12,
    this.openInterest,
    this.openInterestCh1,
    this.openInterestCh4,
    this.openInterestCh24,
    this.symbol,
    this.exchangeName,
    this.follow,
  });

  final String? baseCoin;
  final String? coinImage;
  final double? price;
  final double? priceChangeH24;
  final double? priceChangeM5;
  final double? priceChangeM15;
  final double? priceChangeM30;
  final double? priceChangeH1;
  final double? priceChangeH2;
  final double? priceChangeH4;
  final double? priceChangeH6;
  final double? priceChangeH8;
  final double? priceChangeH12;
  final double? openInterest;
  final double? openInterestCh1;
  final double? openInterestCh4;
  final double? openInterestCh24;
  final String? symbol;
  final String? exchangeName;
  bool? follow;
  factory MarkerTickerEntity.fromJson(Map<String, dynamic> json) {
    return _$MarkerTickerEntityFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MarkerTickerEntityToJson(this);
}

@JsonSerializable()
class TickerPageInfoEntity {
  TickerPageInfoEntity({
    this.current,
    this.pageSize,
    this.total,
  });

  final int? current;
  final int? pageSize;
  final int? total;
  factory TickerPageInfoEntity.fromJson(Map<String, dynamic> json) {
    return _$TickerPageInfoEntityFromJson(json);
  }
}

@JsonSerializable()
class TickersDataEntity {
  TickersDataEntity({
    this.list,
    this.pagination,
  });
  final List<MarkerTickerEntity>? list;
  final TickerPageInfoEntity? pagination;
  factory TickersDataEntity.fromJson(Map<String, dynamic> json) {
    return _$TickersDataEntityFromJson(json);
  }
}
