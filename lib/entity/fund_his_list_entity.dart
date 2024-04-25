import 'package:json_annotation/json_annotation.dart';

part 'fund_his_list_entity.g.dart';

@JsonSerializable()
class FundHisListEntity {
  final String? baseCoin;
  final String? symbol;
  final String? exchangeName;
  final String? type;
  final double? m5net;
  final double? m15net;
  final double? m30net;
  final double? h1net;
  final double? h2net;
  final double? h4net;
  final double? h6net;
  final double? h8net;
  final double? h12net;
  final double? d1net;
  final double? d3net;
  final double? d7net;
  final double? d15net;
  final double? d30net;
  final int? ts;
  final String? interval;

  const FundHisListEntity({
    this.baseCoin,
    this.symbol,
    this.exchangeName,
    this.type,
    this.m5net,
    this.m15net,
    this.m30net,
    this.h1net,
    this.h2net,
    this.h4net,
    this.h6net,
    this.h8net,
    this.h12net,
    this.d1net,
    this.d3net,
    this.d7net,
    this.d15net,
    this.d30net,
    this.ts,
    this.interval,
  });

  factory FundHisListEntity.fromJson(Map<String, dynamic> json) =>
      _$FundHisListEntityFromJson(json);
}
