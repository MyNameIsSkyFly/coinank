import 'package:json_annotation/json_annotation.dart';

part 'push_record_model.g.dart';

@JsonSerializable()
class PushRecordModel {
  final String? type;
  final String? pushType;
  final int? recordType;
  String? title;
  final String? content;
  final String? baseCoin;
  final String? symbol;
  final String? exchange;
  final double? price;
  final double? value;
  final String? from;
  final String? to;
  final String? fromTag;
  final String? toTag;
  final String? url;
  final dynamic amount;
  final String? side;
  final String? interval;
  final String? pushUserId;
  final int? pushTime;
  final dynamic time;
  final dynamic language;
  final dynamic totalZh;
  final dynamic amountZh;
  final dynamic totalEn;
  final dynamic amountEn;

  PushRecordModel({
    this.type,
    this.pushType,
    this.recordType,
    this.title,
    this.content,
    this.baseCoin,
    this.symbol,
    this.exchange,
    this.price,
    this.value,
    this.from,
    this.to,
    this.fromTag,
    this.toTag,
    this.url,
    this.amount,
    this.side,
    this.interval,
    this.pushUserId,
    this.pushTime,
    this.time,
    this.language,
    this.totalZh,
    this.amountZh,
    this.totalEn,
    this.amountEn,
  });

  factory PushRecordModel.fromJson(Map<String, dynamic> json) =>
      _$PushRecordModelFromJson(json);
}

@JsonSerializable()
class PushRecordHugeWaveEntity {
  final String? symbol;
  final String? baseCoin;
  @JsonKey(name: 'exchanName')
  final String? exchangeName;
  final String? interval;
  final double? price;
  final double? value;
  final double? openInterest;
  final double? fundingRate;
  final double? longShortPerson;
  final double? volume;
  final String? type;
  final int? ts;

  const PushRecordHugeWaveEntity({
    this.symbol,
    this.baseCoin,
    this.exchangeName,
    this.interval,
    this.price,
    this.value,
    this.openInterest,
    this.fundingRate,
    this.longShortPerson,
    this.volume,
    this.type,
    this.ts,
  });

  factory PushRecordHugeWaveEntity.fromJson(Map<String, dynamic> json) =>
      _$PushRecordHugeWaveEntityFromJson(json);
}

enum NoticeRecordType {
  signal,
  price,
  oiAlert,
  fundingRate,
  liquidation,
  priceWave,
  transaction,
  announcement,
  hugeWaves,
  frAlert,
  lsAlert,
  advanced,
}
