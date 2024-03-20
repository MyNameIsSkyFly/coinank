import 'package:ank_app/entity/category_info_item_entity.dart';
import 'package:ank_app/generated/l10n.dart';
import 'package:get/get.dart';

abstract class MarketMaps {
  static String contractTextMap(String key) => switch (key) {
        'price' => S.current.s_price,
        'fundingRate' => S.current.s_funding_rate,
        'turnover24h' => S.current.s_24h_turnover,
        'openInterest' => S.current.s_oi,
        'priceChangeH1' => '${S.current.s_price}(1H%)',
        'priceChangeH4' => '${S.current.s_price}(4H%)',
        'priceChangeH6' => '${S.current.s_price}(6H%)',
        'priceChangeH12' => '${S.current.s_price}(12H%)',
        'priceChangeH24' => '${S.current.s_price}(24H%)',
        'openInterestChM5' => '${S.current.s_oi}(5m%)',
        'openInterestChM15' => '${S.current.s_oi}(15m%)',
        'openInterestChM30' => '${S.current.s_oi}(30m%)',
        'openInterestCh1' => '${S.current.s_oi}(1H%)',
        'openInterestCh4' => '${S.current.s_oi}(4H%)',
        'openInterestCh24' => '${S.current.s_oi}(24H%)',
        'openInterestCh2D' => '${S.current.s_oi}(2D%)',
        'openInterestCh3D' => '${S.current.s_oi}(3D%)',
        'openInterestCh7D' => '${S.current.s_oi}(7D%)',
        'liquidationH1' => '1H ${S.current.liq_abbr}(\$)',
        'liquidationH4' => '4H ${S.current.liq_abbr}(\$)',
        'liquidationH12' => '12H ${S.current.liq_abbr}(\$)',
        'liquidationH24' => '24H ${S.current.liq_abbr}(\$)',
        'longShortRatio' => '${S.current.s_buysel_longshort_ratio}(\$)',
        'longShortPerson' => '${S.current.s_longshort_person}(\$)',
        'lsPersonChg5m' => '${S.current.lsRatioOfAccountX('5m')}(%)',
        'lsPersonChg15m' => '${S.current.lsRatioOfAccountX('15m')}(%)',
        'lsPersonChg30m' => '${S.current.lsRatioOfAccountX('30m')}(%)',
        'lsPersonChg1h' => '${S.current.lsRatioOfAccountX('1H')}(%)',
        'lsPersonChg4h' => '${S.current.lsRatioOfAccountX('4H')}(%)',
        'longShortPosition' => '${S.current.s_top_trader_position_ratio}(\$)',
        'longShortAccount' => '${S.current.s_top_trader_accounts_ratio}(\$)',
        'marketCap' => S.current.marketCap,
        'marketCapChange24H' => S.current.marketCapChange,
        'circulatingSupply' => S.current.circulatingSupply,
        'totalSupply' => S.current.totalSupply,
        'maxSupply' => S.current.maxSupply,
        _ => '',
      };

  static String spotTextMap(String key) => switch (key) {
        'price' => S.current.s_price,
        'turnover24h' => '${S.current.s_24h_turnover}(\$)',
        'turnoverChg24h' => '${S.current.s_24h_turnover}(%)',
        'priceChangeM5' => '${S.current.s_price}(5m%)',
        'priceChangeM15' => '${S.current.s_price}(15m%)',
        'priceChangeM30' => '${S.current.s_price}(30m%)',
        'priceChangeH1' => '${S.current.s_price}(1H%)',
        'priceChangeH4' => '${S.current.s_price}(4H%)',
        'priceChangeH8' => '${S.current.s_price}(8H%)',
        'priceChangeH12' => '${S.current.s_price}(12H%)',
        'priceChangeH24' => '${S.current.s_price}(24H%)',
        'marketCap' => S.current.marketCap,
        'marketCapChange24H' => S.current.marketCapChange,
        'circulatingSupply' => S.current.circulatingSupply,
        'totalSupply' => S.current.totalSupply,
        'maxSupply' => S.current.maxSupply,
        _ => '',
      };

  static final allCategories = <CategoryInfoItemEntity>[];

  static String categoryTextMap(String? tag) =>
      allCategories
          .firstWhereOrNull((element) => element.type == tag)
          ?.showName ??
      '';
}
