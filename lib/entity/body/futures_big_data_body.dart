import 'package:json_annotation/json_annotation.dart';

part 'futures_big_data_body.g.dart';

@JsonSerializable(createToJson: true)
class FuturesBigDataBody {
  final String? price;
  final String? priceChangeH24;
  final String? openInterest;
  final String? openInterestCh24;
  final String? turnover24h;
  final String? fundingRate;
  final String? priceChangeH1;
  final String? priceChangeH4;
  final String? priceChangeH6;
  final String? priceChangeH12;
  final String? openInterestChM5;
  final String? openInterestChM15;
  final String? openInterestChM30;
  final String? openInterestCh1;
  final String? openInterestCh4;
  final String? openInterestCh2D;
  final String? openInterestCh3D;
  final String? openInterestCh7D;
  final String? liquidationH1;
  final String? liquidationH4;
  final String? liquidationH12;
  final String? liquidationH24;
  final String? longShortRatio;
  final String? longShortPerson;
  final String? lsPersonChg5m;
  final String? lsPersonChg15m;
  final String? lsPersonChg30m;
  final String? lsPersonChg1h;
  final String? lsPersonChg4h;
  final String? longShortPosition;
  final String? longShortAccount;
  final String? marketCap;
  final String? marketCapChange24H;
  final String? circulatingSupply;
  final String? totalSupply;
  final String? maxSupply;
  final String? turnoverChg24h;
  final String? priceChangeM5;
  final String? priceChangeM15;
  final String? priceChangeM30;
  final String? priceChangeH8;

  const FuturesBigDataBody({
    this.price,
    this.priceChangeH24,
    this.openInterest,
    this.openInterestCh24,
    this.turnover24h,
    this.fundingRate,
    this.priceChangeH1,
    this.priceChangeH4,
    this.priceChangeH6,
    this.priceChangeH12,
    this.openInterestChM5,
    this.openInterestChM15,
    this.openInterestChM30,
    this.openInterestCh1,
    this.openInterestCh4,
    this.openInterestCh2D,
    this.openInterestCh3D,
    this.openInterestCh7D,
    this.liquidationH1,
    this.liquidationH4,
    this.liquidationH12,
    this.liquidationH24,
    this.longShortRatio,
    this.longShortPerson,
    this.lsPersonChg5m,
    this.lsPersonChg15m,
    this.lsPersonChg30m,
    this.lsPersonChg1h,
    this.lsPersonChg4h,
    this.longShortPosition,
    this.longShortAccount,
    this.marketCap,
    this.marketCapChange24H,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.turnoverChg24h,
    this.priceChangeM5,
    this.priceChangeM15,
    this.priceChangeM30,
    this.priceChangeH8,
  });

  factory FuturesBigDataBody.fromJson(Map<String, dynamic> json) =>
      _$FuturesBigDataBodyFromJson(json);

  Map<String, dynamic> toJson() => _$FuturesBigDataBodyToJson(this);
}
