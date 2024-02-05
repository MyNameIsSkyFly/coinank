import 'package:json_annotation/json_annotation.dart';

part 'market_cap_entity.g.dart';

@JsonSerializable()
class MarketCapEntity {
  final String? id;
  final String? symbol;
  final String? name;
  final String? image;
  final double? marketCap;
  final int? marketCapRank;
  final double? marketCapChange24h;
  final double? marketCapChangePercentage24h;
  final double? circulatingSupply;
  final double? totalSupply;
  final double? maxSupply;
  final double? ath;
  final double? athChangePercentage;
  final double? atl;
  final double? atlChangePercentage;

  const MarketCapEntity({
    this.id,
    this.symbol,
    this.name,
    this.image,
    this.marketCap,
    this.marketCapRank,
    this.marketCapChange24h,
    this.marketCapChangePercentage24h,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.ath,
    this.athChangePercentage,
    this.atl,
    this.atlChangePercentage,
  });

  factory MarketCapEntity.fromJson(Map<String, dynamic> json) =>
      _$MarketCapEntityFromJson(json);
}
