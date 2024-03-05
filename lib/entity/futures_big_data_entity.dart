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
    this.openInterestChM5,
    this.openInterestChM15,
    this.openInterestChM30,
    this.openInterestCh1,
    this.openInterestCh4,
    this.openInterestCh24,
    this.openInterestCh2D,
    this.openInterestCh3D,
    this.openInterestCh7D,
    this.liquidationH1,
    this.liquidationH1Long,
    this.liquidationH1Short,
    this.liquidationH4,
    this.liquidationH4Long,
    this.liquidationH4Short,
    this.liquidationH12,
    this.liquidationH12Long,
    this.liquidationH12Short,
    this.liquidationH24,
    this.liquidationH24Long,
    this.liquidationH24Short,
    this.longRatio,
    this.shortRatio,
    this.lsRatioCh24,
    this.longShortRatio,
    this.buyTradeTurnover,
    this.sellTradeTurnover,
    this.buy24h,
    this.sell24h,
    this.buy12h,
    this.sell12h,
    this.buy8h,
    this.sell8h,
    this.buy6h,
    this.sell6h,
    this.buy4h,
    this.sell4h,
    this.buy2h,
    this.sell2h,
    this.buy1h,
    this.sell1h,
    this.buy30m,
    this.sell30m,
    this.buy15m,
    this.sell15m,
    this.buy5m,
    this.sell5m,
    this.fundingRate,
    this.longShortPerson,
    this.lsPersonChg5m,
    this.lsPersonChg15m,
    this.lsPersonChg30m,
    this.lsPersonChg1h,
    this.lsPersonChg4h,
    this.longShortPosition,
    this.longShortAccount,
    this.turnover24h,
    this.turnoverChg24h,
    this.marketCap,
    this.marketCapChange24H,
    this.marketCapChangeValue24H,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.symbol,
    this.exchangeName,
    this.supportSpot,
    this.supportContract,
    this.show,
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
  final double? openInterestChM5;
  final double? openInterestChM15;
  final double? openInterestChM30;
  final double? openInterestCh1;
  final double? openInterestCh4;
  final double? openInterestCh24;
  final double? openInterestCh2D;
  final double? openInterestCh3D;
  final double? openInterestCh7D;
  final double? liquidationH1;
  final double? liquidationH1Long;
  final double? liquidationH1Short;
  final double? liquidationH4;
  final double? liquidationH4Long;
  final double? liquidationH4Short;
  final double? liquidationH12;
  final double? liquidationH12Long;
  final double? liquidationH12Short;
  final double? liquidationH24;
  final double? liquidationH24Long;
  final double? liquidationH24Short;
  final double? longRatio;
  final double? shortRatio;
  final double? lsRatioCh24;
  final double? longShortRatio;
  final double? buyTradeTurnover;
  final double? sellTradeTurnover;
  final double? buy24h;
  final double? sell24h;
  final double? buy12h;
  final double? sell12h;
  final double? buy8h;
  final double? sell8h;
  final double? buy6h;
  final double? sell6h;
  final double? buy4h;
  final double? sell4h;
  final double? buy2h;
  final double? sell2h;
  final double? buy1h;
  final double? sell1h;
  final double? buy30m;
  final double? sell30m;
  final double? buy15m;
  final double? sell15m;
  final double? buy5m;
  final double? sell5m;
  final double? fundingRate;
  final double? longShortPerson;
  final double? lsPersonChg5m;
  final double? lsPersonChg15m;
  final double? lsPersonChg30m;
  final double? lsPersonChg1h;
  final double? lsPersonChg4h;
  final double? longShortPosition;
  final double? longShortAccount;
  final double? turnover24h;
  final double? turnoverChg24h;
  final double? marketCap;
  final double? marketCapChange24H;
  final double? marketCapChangeValue24H;
  final double? circulatingSupply;
  final double? totalSupply;
  final double? maxSupply;
  final String? symbol;
  final String? exchangeName;
  final bool? supportSpot;
  final bool? supportContract;
  final bool? show;
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
