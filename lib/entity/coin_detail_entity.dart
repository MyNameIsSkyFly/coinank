import 'package:json_annotation/json_annotation.dart';

part 'coin_detail_entity.g.dart';

@JsonSerializable()
class CoinDetailEntity {
  final String? id;
  final String? symbol;
  final String? name;
  final dynamic assetPlatformId;
  final num? blockTimeInMinutes;
  final String? hashingAlgorithm;
  final List<String>? categories;
  final dynamic publicNotice;
  final List<dynamic>? additionalNotices;
  final Localization? localization;
  final Description? description;
  final Links? links;
  final Image? image;
  final String? countryOrigin;
  final String? genesisDate;
  final double? sentimentVotesUpPercentage;
  final double? sentimentVotesDownPercentage;
  final num? marketCapRank;
  final dynamic coingeckoRank;
  final double? coingeckoScore;
  final double? developerScore;
  final double? communityScore;
  final double? liquidityScore;
  final double? publicInterestScore;
  final MarketData? marketData;
  final CommunityData? communityData;
  final DeveloperData? developerData;
  final dynamic publicInterestStats;
  final dynamic statusUpdates;
  final String? lastUpdated;
  final List<Tickers>? tickers;

  const CoinDetailEntity({
    this.id,
    this.symbol,
    this.name,
    this.assetPlatformId,
    this.blockTimeInMinutes,
    this.hashingAlgorithm,
    this.categories,
    this.publicNotice,
    this.additionalNotices,
    this.localization,
    this.description,
    this.links,
    this.image,
    this.countryOrigin,
    this.genesisDate,
    this.sentimentVotesUpPercentage,
    this.sentimentVotesDownPercentage,
    this.marketCapRank,
    this.coingeckoRank,
    this.coingeckoScore,
    this.developerScore,
    this.communityScore,
    this.liquidityScore,
    this.publicInterestScore,
    this.marketData,
    this.communityData,
    this.developerData,
    this.publicInterestStats,
    this.statusUpdates,
    this.lastUpdated,
    this.tickers,
  });

  factory CoinDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$CoinDetailEntityFromJson(json);
}

@JsonSerializable()
class Localization {
  final String? en;
  final String? de;
  final String? es;
  final String? fr;
  final String? it;
  final String? pl;
  final String? ro;
  final String? hu;
  final String? nl;
  final String? pt;
  final String? sv;
  final String? vi;
  final String? tr;
  final String? ru;
  final String? ja;
  final String? zh;
  @JsonKey(name: 'zh-tw')
  final String? zhTw;
  final String? ko;
  final String? ar;
  final String? th;
  final String? id;
  final String? cs;
  final String? da;
  final String? el;
  final String? hi;
  final String? no;
  final String? sk;
  final String? uk;
  final String? he;
  final String? fi;
  final String? bg;
  final String? hr;
  final String? lt;
  final String? sl;

  const Localization({
    this.en,
    this.de,
    this.es,
    this.fr,
    this.it,
    this.pl,
    this.ro,
    this.hu,
    this.nl,
    this.pt,
    this.sv,
    this.vi,
    this.tr,
    this.ru,
    this.ja,
    this.zh,
    this.zhTw,
    this.ko,
    this.ar,
    this.th,
    this.id,
    this.cs,
    this.da,
    this.el,
    this.hi,
    this.no,
    this.sk,
    this.uk,
    this.he,
    this.fi,
    this.bg,
    this.hr,
    this.lt,
    this.sl,
  });

  factory Localization.fromJson(Map<String, dynamic> json) =>
      _$LocalizationFromJson(json);
}

@JsonSerializable(createToJson: true)
class Description {
  final String? en;
  final String? de;
  final String? es;
  final String? fr;
  final String? it;
  final String? pl;
  final String? ro;
  final String? hu;
  final String? nl;
  final String? pt;
  final String? sv;
  final String? vi;
  final String? tr;
  final String? ru;
  final String? ja;
  final String? zh;
  @JsonKey(name: 'zh-tw')
  final String? zhTw;

  final String? ko;
  final String? ar;
  final String? th;
  final String? id;
  final String? cs;
  final String? da;
  final String? el;
  final String? hi;
  final String? no;
  final String? sk;
  final String? uk;
  final String? he;
  final String? fi;
  final String? bg;
  final String? hr;
  final String? lt;
  final String? sl;

  const Description({
    this.en,
    this.de,
    this.es,
    this.fr,
    this.it,
    this.pl,
    this.ro,
    this.hu,
    this.nl,
    this.pt,
    this.sv,
    this.vi,
    this.tr,
    this.ru,
    this.ja,
    this.zh,
    this.zhTw,
    this.ko,
    this.ar,
    this.th,
    this.id,
    this.cs,
    this.da,
    this.el,
    this.hi,
    this.no,
    this.sk,
    this.uk,
    this.he,
    this.fi,
    this.bg,
    this.hr,
    this.lt,
    this.sl,
  });

  factory Description.fromJson(Map<String, dynamic> json) =>
      _$DescriptionFromJson(json);

  Map<String, dynamic> toJson() => _$DescriptionToJson(this);
}

@JsonSerializable()
class Links {
  final List<String>? homepage;
  final String? whitepaper;
  @JsonKey(name: 'blockchain_site')
  final List<String>? blockchainSite;
  @JsonKey(name: 'official_forum_url')
  final List<String>? officialForumUrl;
  @JsonKey(name: 'chat_url')
  final List<String>? chatUrl;
  @JsonKey(name: 'announcement_url')
  final List<String>? announcementUrl;
  @JsonKey(name: 'twitter_screen_name')
  final String? twitterScreenName;
  @JsonKey(name: 'facebook_username')
  final String? facebookUsername;
  @JsonKey(name: 'telegram_channel_identifier')
  final String? telegramChannelIdentifier;
  @JsonKey(name: 'subreddit_url')
  final String? subredditUrl;
  @JsonKey(name: 'repos_url')
  final ReposUrl? reposUrl;

  const Links({
    this.homepage,
    this.whitepaper,
    this.blockchainSite,
    this.officialForumUrl,
    this.chatUrl,
    this.announcementUrl,
    this.twitterScreenName,
    this.facebookUsername,
    this.telegramChannelIdentifier,
    this.subredditUrl,
    this.reposUrl,
  });

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);
}

@JsonSerializable()
class ReposUrl {
  final List<String>? github;
  final List<dynamic>? bitbucket;

  const ReposUrl({
    this.github,
    this.bitbucket,
  });

  factory ReposUrl.fromJson(Map<String, dynamic> json) =>
      _$ReposUrlFromJson(json);
}

@JsonSerializable()
class Image {
  final String? thumb;
  final String? small;
  final String? large;

  const Image({
    this.thumb,
    this.small,
    this.large,
  });

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}

@JsonSerializable()
class MarketData {
  @JsonKey(name: 'current_price')
  final DoubleCurrencies? currentPrice;
  final DoubleCurrencies? ath;
  @JsonKey(name: 'ath_change_percentage')
  final DoubleCurrencies? athChangePercentage;
  @JsonKey(name: 'ath_date')
  final StringCurrencies? athDate;
  final DoubleCurrencies? atl;
  @JsonKey(name: 'atl_change_percentage')
  final DoubleCurrencies? atlChangePercentage;
  @JsonKey(name: 'atl_date')
  final StringCurrencies? atlDate;
  @JsonKey(name: 'market_cap')
  final DoubleCurrencies? marketCap;
  @JsonKey(name: 'market_cap_rank')
  final num? marketCapRank;
  @JsonKey(name: 'fully_diluted_valuation')
  final DoubleCurrencies? fullyDilutedValuation;
  @JsonKey(name: 'market_cap_fdv_ratio')
  final double? marketCapFdvRatio;
  @JsonKey(name: 'total_volume')
  final DoubleCurrencies? totalVolume;
  @JsonKey(name: 'high_24h')
  final DoubleCurrencies? high24h;
  @JsonKey(name: 'low_24h')
  final DoubleCurrencies? low24h;
  @JsonKey(name: 'price_change_24h')
  final num? priceChange24h;
  @JsonKey(name: 'price_change_percentage_24h')
  final double? priceChangePercentage24h;
  @JsonKey(name: 'price_change_percentage_7d')
  final double? priceChangePercentage7d;
  @JsonKey(name: 'price_change_percentage_14d')
  final double? priceChangePercentage14d;
  @JsonKey(name: 'price_change_percentage_30d')
  final num? priceChangePercentage30d;
  @JsonKey(name: 'price_change_percentage_60d')
  final num? priceChangePercentage60d;
  @JsonKey(name: 'price_change_percentage_200d')
  final double? priceChangePercentage200d;
  @JsonKey(name: 'price_change_percentage_1y')
  final double? priceChangePercentage1y;
  @JsonKey(name: 'market_cap_change_24h')
  final num? marketCapChange24h;
  @JsonKey(name: 'market_cap_change_percentage_24h')
  final num? marketCapChangePercentage24h;
  @JsonKey(name: 'price_change_24h_in_currency')
  final DoubleCurrencies? priceChange24hInCurrency;
  @JsonKey(name: 'price_change_percentage_1h_in_currency')
  final DoubleCurrencies? priceChangePercentage1hInCurrency;
  @JsonKey(name: 'price_change_percentage_24h_in_currency')
  final DoubleCurrencies? priceChangePercentage24hInCurrency;
  @JsonKey(name: 'price_change_percentage_7d_in_currency')
  final DoubleCurrencies? priceChangePercentage7dInCurrency;
  @JsonKey(name: 'price_change_percentage_14d_in_currency')
  final DoubleCurrencies? priceChangePercentage14dInCurrency;
  @JsonKey(name: 'price_change_percentage_30d_in_currency')
  final DoubleCurrencies? priceChangePercentage30dInCurrency;
  @JsonKey(name: 'price_change_percentage_60d_in_currency')
  final DoubleCurrencies? priceChangePercentage60dInCurrency;
  @JsonKey(name: 'price_change_percentage_200d_in_currency')
  final DoubleCurrencies? priceChangePercentage200dInCurrency;
  @JsonKey(name: 'price_change_percentage_1y_in_currency')
  final DoubleCurrencies? priceChangePercentage1yInCurrency;
  @JsonKey(name: 'market_cap_change_24h_in_currency')
  final DoubleCurrencies? marketCapChange24hInCurrency;
  @JsonKey(name: 'market_cap_change_percentage_24h_in_currency')
  final DoubleCurrencies? marketCapChangePercentage24hInCurrency;
  @JsonKey(name: 'total_supply')
  final double? totalSupply;
  @JsonKey(name: 'max_supply')
  final double? maxSupply;
  @JsonKey(name: 'circulating_supply')
  final double? circulatingSupply;
  @JsonKey(name: 'last_updated')
  final String? lastUpdated;

  const MarketData({
    this.currentPrice,
    this.ath,
    this.athChangePercentage,
    this.athDate,
    this.atl,
    this.atlChangePercentage,
    this.atlDate,
    this.marketCap,
    this.marketCapRank,
    this.fullyDilutedValuation,
    this.marketCapFdvRatio,
    this.totalVolume,
    this.high24h,
    this.low24h,
    this.priceChange24h,
    this.priceChangePercentage24h,
    this.priceChangePercentage7d,
    this.priceChangePercentage14d,
    this.priceChangePercentage30d,
    this.priceChangePercentage60d,
    this.priceChangePercentage200d,
    this.priceChangePercentage1y,
    this.marketCapChange24h,
    this.marketCapChangePercentage24h,
    this.priceChange24hInCurrency,
    this.priceChangePercentage1hInCurrency,
    this.priceChangePercentage24hInCurrency,
    this.priceChangePercentage7dInCurrency,
    this.priceChangePercentage14dInCurrency,
    this.priceChangePercentage30dInCurrency,
    this.priceChangePercentage60dInCurrency,
    this.priceChangePercentage200dInCurrency,
    this.priceChangePercentage1yInCurrency,
    this.marketCapChange24hInCurrency,
    this.marketCapChangePercentage24hInCurrency,
    this.totalSupply,
    this.maxSupply,
    this.circulatingSupply,
    this.lastUpdated,
  });

  factory MarketData.fromJson(Map<String, dynamic> json) =>
      _$MarketDataFromJson(json);
}

@JsonSerializable()
class DoubleCurrencies {
  DoubleCurrencies();

  double? aed;
  double? ars;
  double? aud;
  double? bch;
  double? bdt;
  double? bhd;
  double? bmd;
  double? bnb;
  double? brl;
  double? btc;
  double? cad;
  double? chf;
  double? clp;
  double? cny;
  double? czk;
  double? dkk;
  double? dot;
  double? eos;
  double? eth;
  double? eur;
  double? gbp;
  double? gel;
  double? hkd;
  double? huf;
  double? idr;
  double? ils;
  double? inr;
  double? jpy;
  double? krw;
  double? kwd;
  double? lkr;
  double? ltc;
  double? mmk;
  double? mxn;
  double? myr;
  double? ngn;
  double? nok;
  double? nzd;
  double? php;
  double? pkr;
  double? pln;
  double? rub;
  double? sar;
  double? sek;
  double? sgd;
  double? thb;
  @JsonKey(name: 'try')
  double? nameTry;
  double? twd;
  double? uah;
  double? usd;
  double? vef;
  double? vnd;
  double? xag;
  double? xau;
  double? xdr;
  double? xlm;
  double? xrp;
  double? yfi;
  double? zar;
  double? bits;
  double? link;
  double? sats;

  factory DoubleCurrencies.fromJson(Map<String, dynamic> json) {
    return _$DoubleCurrenciesFromJson(json);
  }
}

@JsonSerializable()
class StringCurrencies {
  StringCurrencies();

  String? aed;
  String? ars;
  String? aud;
  String? bch;
  String? bdt;
  String? bhd;
  String? bmd;
  String? bnb;
  String? brl;
  String? btc;
  String? cad;
  String? chf;
  String? clp;
  String? cny;
  String? czk;
  String? dkk;
  String? dot;
  String? eos;
  String? eth;
  String? eur;
  String? gbp;
  String? gel;
  String? hkd;
  String? huf;
  String? idr;
  String? ils;
  String? inr;
  String? jpy;
  String? krw;
  String? kwd;
  String? lkr;
  String? ltc;
  String? mmk;
  String? mxn;
  String? myr;
  String? ngn;
  String? nok;
  String? nzd;
  String? php;
  String? pkr;
  String? pln;
  String? rub;
  String? sar;
  String? sek;
  String? sgd;
  String? thb;
  @JsonKey(name: 'try')
  String? nameTry;
  String? twd;
  String? uah;
  String? usd;
  String? vef;
  String? vnd;
  String? xag;
  String? xau;
  String? xdr;
  String? xlm;
  String? xrp;
  String? yfi;
  String? zar;
  String? bits;
  String? link;
  String? sats;

  factory StringCurrencies.fromJson(Map<String, dynamic> json) {
    return _$StringCurrenciesFromJson(json);
  }
}

@JsonSerializable()
class Low24h {
  final num? aed;
  final num? ars;
  final num? aud;
  final double? bch;
  final num? bdt;
  final double? bhd;
  final num? bmd;
  final double? bnb;
  final num? brl;
  final num? btc;
  final num? cad;
  final num? chf;
  final num? clp;
  final num? cny;
  final num? czk;
  final num? dkk;
  final num? dot;
  final num? eos;
  final double? eth;
  final num? eur;
  final num? gbp;
  final num? gel;
  final num? hkd;
  final num? huf;
  final num? idr;
  final num? ils;
  final num? inr;
  final num? jpy;
  final num? krw;
  final double? kwd;
  final num? lkr;
  final double? ltc;
  final num? mmk;
  final num? mxn;
  final num? myr;
  final num? ngn;
  final num? nok;
  final num? nzd;
  final num? php;
  final num? pkr;
  final num? pln;
  final num? rub;
  final num? sar;
  final num? sek;
  final num? sgd;
  final num? thb;
  @JsonKey(name: 'try')
  final num? nameTry;
  final num? twd;
  final num? uah;
  final num? usd;
  final double? vef;
  final num? vnd;
  final double? xag;
  final double? xau;
  final num? xdr;
  final num? xlm;
  final num? xrp;
  final double? yfi;
  final num? zar;
  final num? bits;
  final num? link;
  final num? sats;

  const Low24h({
    this.aed,
    this.ars,
    this.aud,
    this.bch,
    this.bdt,
    this.bhd,
    this.bmd,
    this.bnb,
    this.brl,
    this.btc,
    this.cad,
    this.chf,
    this.clp,
    this.cny,
    this.czk,
    this.dkk,
    this.dot,
    this.eos,
    this.eth,
    this.eur,
    this.gbp,
    this.gel,
    this.hkd,
    this.huf,
    this.idr,
    this.ils,
    this.inr,
    this.jpy,
    this.krw,
    this.kwd,
    this.lkr,
    this.ltc,
    this.mmk,
    this.mxn,
    this.myr,
    this.ngn,
    this.nok,
    this.nzd,
    this.php,
    this.pkr,
    this.pln,
    this.rub,
    this.sar,
    this.sek,
    this.sgd,
    this.thb,
    this.nameTry,
    this.twd,
    this.uah,
    this.usd,
    this.vef,
    this.vnd,
    this.xag,
    this.xau,
    this.xdr,
    this.xlm,
    this.xrp,
    this.yfi,
    this.zar,
    this.bits,
    this.link,
    this.sats,
  });

  factory Low24h.fromJson(Map<String, dynamic> json) => _$Low24hFromJson(json);
}

@JsonSerializable()
class CommunityData {
  @JsonKey(name: 'twitter_followers')
  final num? twitterFollowers;
  @JsonKey(name: 'reddit_average_posts_48h')
  final num? redditAveragePosts48h;
  @JsonKey(name: 'reddit_average_comments_48h')
  final num? redditAverageComments48h;
  @JsonKey(name: 'reddit_subscribers')
  final num? redditSubscribers;
  @JsonKey(name: 'reddit_accounts_active_48h')
  final num? redditAccountsActive48h;

  const CommunityData({
    this.twitterFollowers,
    this.redditAveragePosts48h,
    this.redditAverageComments48h,
    this.redditSubscribers,
    this.redditAccountsActive48h,
  });

  factory CommunityData.fromJson(Map<String, dynamic> json) =>
      _$CommunityDataFromJson(json);
}

@JsonSerializable()
class DeveloperData {
  final num? forks;
  final num? stars;
  final num? subscribers;
  @JsonKey(name: 'total_issues')
  final num? totalIssues;
  @JsonKey(name: 'closed_issues')
  final num? closedIssues;
  @JsonKey(name: 'pull_requests_merged')
  final num? pullRequestsMerged;
  @JsonKey(name: 'pull_request_contributors')
  final num? pullRequestContributors;
  @JsonKey(name: 'code_additions_deletions_4_weeks')
  final CodeAdditionsDeletions4Weeks? codeAdditionsDeletions4Weeks;
  @JsonKey(name: 'commit_count_4_weeks')
  final num? commitCount4Weeks;
  @JsonKey(name: 'last_4_weeks_commit_activity_series')
  final List<dynamic>? last4WeeksCommitActivitySeries;

  const DeveloperData({
    this.forks,
    this.stars,
    this.subscribers,
    this.totalIssues,
    this.closedIssues,
    this.pullRequestsMerged,
    this.pullRequestContributors,
    this.codeAdditionsDeletions4Weeks,
    this.commitCount4Weeks,
    this.last4WeeksCommitActivitySeries,
  });

  factory DeveloperData.fromJson(Map<String, dynamic> json) =>
      _$DeveloperDataFromJson(json);
}

@JsonSerializable()
class CodeAdditionsDeletions4Weeks {
  final num? additions;
  final num? deletions;

  const CodeAdditionsDeletions4Weeks({
    this.additions,
    this.deletions,
  });

  factory CodeAdditionsDeletions4Weeks.fromJson(Map<String, dynamic> json) =>
      _$CodeAdditionsDeletions4WeeksFromJson(json);
}

@JsonSerializable()
class Tickers {
  final String? base;
  final String? target;
  final Market? market;
  final double? last;
  final double? volume;
  @JsonKey(name: 'converted_last')
  final ConvertedLast? convertedLast;
  @JsonKey(name: 'converted_volume')
  final ConvertedVolume? convertedVolume;
  @JsonKey(name: 'trust_score')
  final String? trustScore;
  @JsonKey(name: 'bid_ask_spread_percentage')
  final double? bidAskSpreadPercentage;
  final String? timestamp;
  @JsonKey(name: 'last_traded_at')
  final String? lastTradedAt;
  @JsonKey(name: 'last_fetch_at')
  final String? lastFetchAt;
  @JsonKey(name: 'is_anomaly')
  final bool? isAnomaly;
  @JsonKey(name: 'is_stale')
  final bool? isStale;
  @JsonKey(name: 'trade_url')
  final String? tradeUrl;
  @JsonKey(name: 'coin_id')
  final String? coinId;
  @JsonKey(name: 'target_coin_id')
  final String? targetCoinId;

  const Tickers({
    this.base,
    this.target,
    this.market,
    this.last,
    this.volume,
    this.convertedLast,
    this.convertedVolume,
    this.trustScore,
    this.bidAskSpreadPercentage,
    this.timestamp,
    this.lastTradedAt,
    this.lastFetchAt,
    this.isAnomaly,
    this.isStale,
    this.tradeUrl,
    this.coinId,
    this.targetCoinId,
  });

  factory Tickers.fromJson(Map<String, dynamic> json) =>
      _$TickersFromJson(json);
}

@JsonSerializable()
class Market {
  final String? name;
  final String? identifier;
  @JsonKey(name: 'has_trading_incentive')
  final bool? hasTradingIncentive;

  const Market({
    this.name,
    this.identifier,
    this.hasTradingIncentive,
  });

  factory Market.fromJson(Map<String, dynamic> json) => _$MarketFromJson(json);
}

@JsonSerializable()
class ConvertedLast {
  final double? btc;
  final double? eth;
  final num? usd;

  const ConvertedLast({
    this.btc,
    this.eth,
    this.usd,
  });

  factory ConvertedLast.fromJson(Map<String, dynamic> json) =>
      _$ConvertedLastFromJson(json);
}

@JsonSerializable()
class ConvertedVolume {
  final double? btc;
  final num? eth;
  final num? usd;

  const ConvertedVolume({
    this.btc,
    this.eth,
    this.usd,
  });

  factory ConvertedVolume.fromJson(Map<String, dynamic> json) =>
      _$ConvertedVolumeFromJson(json);
}
