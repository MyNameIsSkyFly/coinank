import 'package:json_annotation/json_annotation.dart';

part 'oi_chart_menu_param_entity.g.dart';

@JsonSerializable()
class OIChartMenuParamEntity {
  OIChartMenuParamEntity({
    this.exchange,
    this.exchange2,
    this.type,
    this.interval,
    this.baseCoin,
    this.interval2,
  });

  String? exchange;
  String? exchange2;
  String? type;
  String? interval;
  String? baseCoin;
  String? interval2;

  factory OIChartMenuParamEntity.fromJson(Map<String, dynamic> json) {
    return _$OIChartMenuParamEntityFromJson(json);
  }
}
