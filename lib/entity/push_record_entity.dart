import 'package:json_annotation/json_annotation.dart';

part 'push_record_entity.g.dart';

@JsonSerializable()
class PushRecordEntity {
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

  PushRecordEntity({
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

  factory PushRecordEntity.fromJson(Map<String, dynamic> json) =>
      _$PushRecordEntityFromJson(json);
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
  unknown,
}

@JsonSerializable()
class WarningTypesEntity {
  final String? type;
  final List<WarningTypeEntity>? warningTypes;

  const WarningTypesEntity({
    this.type,
    this.warningTypes,
  });

  factory WarningTypesEntity.fromJson(Map<String, dynamic> json) =>
      _$WarningTypesEntityFromJson(json);
}

@JsonSerializable()
class WarningTypeEntity {
  final String? warnType;
  final String? defaultParam;

  const WarningTypeEntity({
    this.warnType,
    this.defaultParam,
  });

  factory WarningTypeEntity.fromJson(Map<String, dynamic> json) =>
      _$WarningTypeEntityFromJson(json);
}

@JsonSerializable()
class UserAlertSignalConfigEntity {
  final String? id;
  final String? userId;
  final String? type;
  final String? warningType;
  final String? warningParam;
  final String? exChangeName;
  final String? symbol;
  final String? interval;
  final int? createTime;
  final int? updateTime;

  const UserAlertSignalConfigEntity({
    this.id,
    this.userId,
    this.type,
    this.warningType,
    this.warningParam,
    this.exChangeName,
    this.symbol,
    this.interval,
    this.createTime,
    this.updateTime,
  });

  factory UserAlertSignalConfigEntity.fromJson(Map<String, dynamic> json) =>
      _$UserAlertSignalConfigEntityFromJson(json);
}

@JsonSerializable()
class AlertTypeEntity {
  @JsonKey(unknownEnumValue: NoticeRecordType.unknown)
  final NoticeRecordType type;
  final String? typeName;
  final int? sort;
  final List<double>? waveValues;
  final List<String>? supportSymbol;
  final List<String>? supportExchange;
  final bool? on;

  const AlertTypeEntity({
    required this.type,
    this.typeName,
    this.sort,
    this.waveValues,
    this.supportSymbol,
    this.supportExchange,
    this.on,
  });

  factory AlertTypeEntity.fromJson(Map<String, dynamic> json) =>
      _$AlertTypeEntityFromJson(json);
}

@JsonSerializable()
class AlertUserNoticeEntity {
  final String? id;
  final String? baseCoin;
  final String? symbol;
  final String? userId;
  @JsonKey(unknownEnumValue: NoticeRecordType.unknown)
  final NoticeRecordType type;
  final String? subType;
  final double? noticeValue;
  final String? noticeType;
  final List<String>? noticeTypes;
  final int? noticeTime;
  final int? ts;
  final String? interval;
  final String? exchange;
  final List<double>? noticeValues;
  final dynamic pushType;
  final bool? on;

  AlertUserNoticeEntity({
    this.id,
    this.baseCoin,
    this.symbol,
    this.userId,
    required this.type,
    this.subType,
    this.noticeValue,
    this.noticeType,
    this.noticeTypes,
    this.noticeTime,
    this.ts,
    this.interval,
    this.exchange,
    this.noticeValues,
    this.pushType,
    this.on,
  });

  factory AlertUserNoticeEntity.fromJson(Map<String, dynamic> json) {
    return _$AlertUserNoticeEntityFromJson(json);
  }
}
